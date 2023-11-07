`timescale 1ns / 100ps

module clark_transform (
	input logic clk, 
	input logic rst_n,
	input logic signed [15:0] a, b, c,
	output logic signed [15:0] alpha, beta, gamma
);

  parameter K1 = 2.0/3.0;
  parameter K2 = 1.0/3.0;
  parameter K3 = 1.0/$sqrt(3);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      alpha <= 16'b0;
      beta <= 16'b0;
      gamma <= 16'b0;
    end else begin
      alpha <= K1*a - K2*b - K2*c;
      beta <= K3*b - K3*c;
      gamma <= K2*a + K2*b + K2*c;
    end
  end

endmodule