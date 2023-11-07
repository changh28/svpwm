`timescale 1ns / 100ps

module inv_park_transform (
	input logic clk, 
	input logic rst_n,
	input logic signed [15:0] d, q, theta,
	output logic signed [15:0] alpha, beta
);

  logic signed [15:0] sin, cos;
  
  assign sin = $signed($sin(theta));
  assign cos = $signed($cos(theta));

  always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
      alpha <= 16'b0;
      beta <= 16'b0;
    end else begin
      alpha <= d * cos - q * sin;
      beta <= d * sin + q * cos;
    end
  end

endmodule
