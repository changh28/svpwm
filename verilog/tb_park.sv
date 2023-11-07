`timescale 1ns / 100ps

module park_tb;

  // Inputs
  logic clk;
  logic rst_n;
  logic signed [15:0] alpha;
  logic signed [15:0] beta;
  logic signed [15:0] theta;

  // Outputs
  logic signed [15:0] d;
  logic signed [15:0] q;

  // Instantiate the Unit Under Test (UUT)
  park_transform uut (
    .clk(clk),
    .rst_n(rst_n),
    .alpha(alpha),
    .beta(beta),
    .theta(theta),
    .d(d),
    .q(q)
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
    $display("Test 1: d=%f, q=%f", d, q);

    alpha = 0;
    beta = 32767;
    theta = 0;
    #10;
    $display("Test 2: d=%f, q=%f", d, q);

    alpha = 32767;
    beta = 32767;
    theta = 0;
    #10;
    $display("Test 3: d=%f, q=%f", d, q);

    alpha = -32767;
    beta = 0;
    theta = 0;
    #10;
    $display("Test 4: d=%f, q=%f", d, q);

    alpha = 0;
    beta = -32767;
    theta = 0;
    #10;
    $display("Test 5: d=%f, q=%f", d, q);

    alpha = -32767;
    beta = -32767;
    theta = 0;
    #10;
    $display("Test 6: d=%f, q=%f", d, q);

  end

endmodule