`timescale 1ns / 100ps

module inv_clark_transform (
	input logic clk, 
	input logic rst_n,
	input logic signed [15:0] alpha, beta, gamma,
  output logic signed [15:0] a, b, c
);

  parameter K1 = 1.0/2.0;
  parameter K2 = $sqrt(3)/2.0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      a <= 16'b0;
      b <= 16'b0;
      c <= 16'b0;
    end else begin
      a <= alpha + gamma;
      b <= -K1*alpha + K2*beta + gamma;
      c <= -K1*alpha - K2*beta + gamma;
    end
  end

endmodule