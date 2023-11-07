#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <hls_math.h>

// Performs Clark transform on a three-phase signal a_b_c
// to convert them into alpha_beta_gamma components
void clark_transform(double* alpha_beta_gamma, double a, double b, double c){
    double alpha = 2/3*a - 1/3*(b+c);
    double beta = 1/hls::sqrt(3) * (b-c);
    double gamma = 1/3 * (a+b+c);
    double alpha_beta_gamma[3] = {0, 0, 0};
    alpha_beta_gamma[0] = alpha;
    alpha_beta_gamma[1] = beta;
    alpha_beta_gamma[2] = gamma;
}

// Performs Park transform on a two-phase signal alpha_beta with an angle theta
// to convert them into d_q components
void park_transform(double* d_q, double alpha, double beta, double theta){
    double sine = hls::sin(theta);
    double cosine = hls::cos(theta);
    double d = alpha * cosine + beta * sine;
    double q = -alpha * sine + beta * cosine;
    double d_q[2] = {0, 0};
    d_q[0] = d;
    d_q[1] = q;
}

// Performs Inverse-park transform on a two-phase signal d_q with an angle theta
// to convert them into alpha_beta components
void inv_park_transform(double* alpha_beta, double d, double q, double theta){
    double sine = hls::sin(theta);
    double cosine = hls::cos(theta);
    double alpha = d * cosine - q * sine;
    double beta = d * sine + q * cosine;
    double alpha_beta[2] = {0, 0};
    alpha_beta[0] = alpha;
    alpha_beta[1] = beta;
}

// Determines the sector in which the synthesized vector lies in a hexagon
// Returns the sector number 0~5 representing sector 1~6 in the diagram
int determine_sector(double V_alpha, double V_beta){
    int sector = -1;
    if (V_beta >= 0 && V_beta <= hls::sqrt(3)*V_alpha) {
        sector = 0;
    } else if (V_beta >= 0 && ((V_alpha >= 0 && V_beta >= hls::sqrt(3)*V_alpha)
        || (V_alpha < 0 && V_beta >= -hls::sqrt(3)*V_alpha))) {
        sector = 1;
    } else if (V_beta >= 0 && V_beta <= -hls::sqrt(3)*V_alpha) {
        sector = 2;
    } else if (V_beta <= 0 && V_beta >= hls::sqrt(3)*V_alpha) {
        sector = 3;
    } else if (V_beta <= 0 && ((V_alpha <= 0 && V_beta <= hls::sqrt(3)*V_alpha)
        || (V_alpha > 0 && V_beta <= -hls::sqrt(3)*V_alpha))) {
        sector = 4;
    } else if (V_beta <= 0 && V_beta >= -hls::sqrt(3)*V_alpha) {
        sector = 5;
    }
    return sector;
}

// Computes the duty cycles Ta, Tb, and T0 based on sector and input voltages
void duty_cycle(double* Ta_Tb_T0, int sector, double V_alpha, double V_beta, double Vdc, double Ts){
    double X = hls::sqrt(3) * V_beta * Ts / Vdc;
    double Y = (1.5*V_alpha + hls::sqrt(3)/2*V_beta) * Ts / Vdc;
    double Z = (-1.5*V_alpha + hls::sqrt(3)/2*V_beta) * Ts / Vdc;
    double Ta, Tb;
    switch(sector){
        case 0:
            Ta = -Z;
            Tb = X;
            break;
        case 1:
            Ta = Y;
            Tb = Z;
            break;
        case 2:
            Ta = X;
            Tb = -Y;
            break;
        case 3:
            Ta = Z;
            Tb = -X;
            break;
        case 4:
            Ta = -Y;
            Tb = -Z;
            break;
        case 5:
            Ta = -X;
            Tb = Y;
            break;
        default:
            Ta = -1;
            Tb = -1;
            break;
    }
    double T0 = Ts - Ta - Tb;
    Ta_Tb_T0[0] = Ta;
    Ta_Tb_T0[1] = Tb;
    Ta_Tb_T0[2] = T0;
}

// Computes the intermidiate values K, L, M, N that are assigned to op-amp references subject to each sector
void half_period_switch_state(double* RefA_B_C, int sector, double Ta, double Tb, double T0){
    double K = T0/4;
    double L = T0/4 + Ta/2;
    double M = T0/4 + Tb/2;
    double N = T0/4 + Ta/2 + Tb/2;
    double RefA, RefB, RefC;
    switch(sector){
        case 0:
            RefA = K;
            RefB = L;
            RefC = N;
            break;
        case 1:
            RefA = M;
            RefB = K;
            RefC = N;
            break;
        case 2:
            RefA = N;
            RefB = K;
            RefC = L;
            break;
        case 3:
            RefA = N;
            RefB = M;
            RefC = K;
            break;
        case 4:
            RefA = L;
            RefB = N;
            RefC = K;
            break;
        case 5:
            RefA = K;
            RefB = N;
            RefC = M;
            break;
        default:
            RefA = -1;
            RefB = -1;
            RefC = -1;
            break;
    }
    RefA_B_C[0] = RefA;
    RefA_B_C[1] = RefB;
    RefA_B_C[2] = RefC;
}

// the top function of svpwm module
// @Inputs:
// V_alpha & V_beta: idealy sinusoidal waves with a phase difference of 90 degrees
// carrier: a triangular wave whose frequency determines the precison of pwm
// Vdc: DC power voltage
// Ts: period of the carrier wave
int svpwm(double V_alpha, double V_beta, double carrier, double Vdc, double Ts){
    int sector = determine_sector(V_alpha, V_beta);

    double Ta_Tb_T0[3] = {0, 0, 0};
    duty_cycle(sector, V_alpha, V_beta, Vdc, Ts);
    double Ta = Ta_Tb_T0[0];
    double Tb = Ta_Tb_T0[1];
    double T0 = Ta_Tb_T0[2];

    double RefA_B_C[3] = {0, 0, 0};
    half_period_switch_state(sector, Ta, Tb, T0);
    double RefA = RefA_B_C[0];
    double RefB = RefA_B_C[1];
    double RefC = RefA_B_C[2];
    
    // signals for debug only
    int switch_signal[3] = {0, 0, 0};
    int gate[6] = {0, 0, 0, 0, 0, 0};
    switch_signal[0] = (carrier > RefA)? 1:0;
    switch_signal[1] = (carrier > RefB)? 1:0;
    switch_signal[2] = (carrier > RefC)? 1:0;
    gate[0] = switch_signal[0];
    gate[1] = switch_signal[1];
    gate[2] = switch_signal[2];
    gate[3] = (switch_signal[0] == 0)? 1:0;
    gate[4] = (switch_signal[1] == 0)? 1:0;
    gate[5] = (switch_signal[2] == 0)? 1:0;

    int final = 0;
    int power = 1;
    for(int i = 0; i < 6; i++){
    	final += gate[i] * power;
    	power *= 2;
    }
    return final;
}
