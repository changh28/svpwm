`timescale 1ns / 100ps

module inv_park_tb;

  // Inputs
  logic clk;
  logic rst_n;
  logic signed [15:0] d;
  logic signed [15:0] q;
  logic signed [15:0] theta;

  // Outputs
  logic signed [15:0] alpha;
  logic signed [15:0] beta;

  // Instantiate the DUT
  inv_park_transform dut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .q(q),
    .theta(theta),
    .alpha(alpha),
    .beta(beta)
  );

  // Clock
  always #5 clk = ~clk;

  initial begin
    d = 0;
    q = 0;
    theta = 0;
    clk = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
  end

  initial begin
    d = 32767;
    q = 0;
    theta = 0;
    #10;
    $display("alpha = %f, beta = %f", alpha, beta);

    d = 32767;
    q = 0;
    theta = 32767;
    #10;
    $display("alpha = %f, beta = %f", alpha, beta);

    d = 32767;
    q = 32767;
    theta = 0;
    #10;
    $display("alpha = %f, beta = %f", alpha, beta);

    d = 32767;
    q = 32767;
    theta = 32767;
    #10;
    $display("alpha = %f, beta = %f", alpha, beta);

  end

endmodule