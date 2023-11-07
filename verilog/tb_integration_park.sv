`timescale 1ns / 100ps

module park_integration_tb;

  // Inputs1
  logic clk;
  logic rst_n;
  logic signed [15:0] alpha;
  logic signed [15:0] beta;
  logic signed [15:0] theta;

  // Outputs1, Inputs2
  logic signed [15:0] d;
  logic signed [15:0] q;

  // Outputs2
  logic signed [15:0] alpha2;
  logic signed [15:0] beta2;

  park_transform uut (
    .clk(clk),
    .rst_n(rst_n),
    .alpha(alpha),
    .beta(beta),
    .theta(theta),
    .d(d),
    .q(q)
  );

  inv_park_transform dut (
    .clk(clk),
    .rst_n(rst_n),
    .d(d),
    .q(q),
    .theta(theta),
    .alpha(alpha2),
    .beta(beta2)
  );
  
  // Clock 
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst_n = 0;
    alpha = 0;
    beta = 0;
    theta = 0;

    #20; rst_n = 1;

    alpha = 32767;
    beta = 0;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

    alpha = 0;
    beta = 32767;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

    alpha = 32767;
    beta = 32767;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

    alpha = -32767;
    beta = 0;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

    alpha = 0;
    beta = -32767;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

    alpha = -32767;
    beta = -32767;
    theta = 0;
    #10;
    $display("alpha2 = %f, beta2 = %f", alpha2, beta2);

  end

endmodule