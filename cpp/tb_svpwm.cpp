#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <hls_math.h>
#include "svpwm.h"

int main(){
    double Ts = 131.07;
    double Vdc = 32;
    const int duration = 262140;

    double carrier[duration];
    double V_alpha[duration], V_beta[duration];
    int* gate_signal[duration];

    carrier[0] = -32767;
    for (int i = 1; i < duration; i++) {
        carrier[i] = (carrier[i-1] < 32767)? carrier[i-1]+1 : carrier[i-1]-1;
    }

    for (int i = 0; i < duration; i++) {
        V_alpha[i] = 32767 * hls::sin(i);
        V_beta[i] = 32767 * hls::cos(i);
        gate_signal[i] = svpwm(V_alpha[i], V_beta[i], carrier[i], Vdc, Ts);
    }
        
}
