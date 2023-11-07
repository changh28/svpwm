`timescale 1ns / 100ps

module top (
	input logic clk, 
	input logic rst_n,
    input logic signed [15:0] Vd, Vq, V_theta,
	input logic signed [15:0] Ia, Ib, Ic, I_theta,
    input logic signed [15:0] carrier,
    output logic signed [15:0] Id, Iq,
	output logic [5:0] gate
);

    logic signed [15:0] V_alpha, V_beta;
    logic signed [15:0] I_alpha, I_beta, I_gamma;

    Inverse_park inv_park(
        .clk(clk),
        .rst_n(rst_n),
        .d(Vd),
        .q(Vq),
        .theta(V_theta),
        .alpha(V_alpha),
        .beta(V_beta)
    );

    Svpwm svpwm(
        .clk(clk),
        .rst_n(rst_n),
        .V_alpha(V_alpha),
        .V_beta(V_beta),
        .carrier(carrier),
        .gate(gate)
    );

    Clark clark_transform(
        .clk(clk),
        .rst_n(rst_n),
        .a(Ia),
        .b(Ib),
        .c(Ic),
        .alpha(I_alpha),
        .beta(I_beta),
        .gamma(I_gamma)
    );

    Park park_transform(
        .clk(clk),
        .rst_n(rst_n),
        .alpha(I_alpha),
        .beta(I_beta),
        .theta(I_theta),
        .d(Id),
        .q(Iq)
    );


endmodule