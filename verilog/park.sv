`timescale 1ns / 100ps

module park_transform (
	input logic clk, 
	input logic rst_n,
	input logic signed [15:0] alpha, beta,
  input logic signed [15:0] theta,
	output logic signed [15:0] d, q
);

  logic signed [15:0] sin, cos;
  
  assign sin = $signed($sin(theta));
  assign cos = $signed($cos(theta));

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      d <= 16'b0;
      q <= 16'b0;
    end else begin
      d <= alpha * cos + beta * sin;
      q <= -alpha * sin + beta * cos;
    end
  end

endmodule