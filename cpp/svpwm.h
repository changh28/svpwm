#ifndef SVPWM_H
#define SVPWM_H
#endif

double* clark_transform(double a, double b, double c);
double* park_transform(double alpha, double beta, double theta);
double* inv_park_transform(double d, double q, double theta);
int determine_sector(double V_alpha, double V_beta);
double* duty_cycle(int sector, double V_alpha, double V_beta, double Vdc, double Ts);
double* half_period_switch_state(int sector, double Ta, double Tb, double T0);
int* svpwm(double V_alpha, double V_beta, double carrier, double Vdc, double Ts);


