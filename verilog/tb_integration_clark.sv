`timescale 1ns / 100ps

module clark_integration_tb;

  // Inputs1
  logic clk;
  logic rst_n;
  logic signed [15:0] a;
  logic signed [15:0] b;
  logic signed [15:0] c;

  // Outputs1, Inputs2
  logic signed [15:0] alpha;
  logic signed [15:0] beta;
  logic signed [15:0] gamma;

  // Outputs2
  logic signed [15:0] a2;
  logic signed [15:0] b2;
  logic signed [15:0] c2;

  clark_transform uut (
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .c(c),
    .alpha(alpha),
    .beta(beta),
    .gamma(gamma)
  );

  inv_clark_transform dut (
    .clk(clk),
    .rst_n(rst_n),
    .alpha(alpha),
    .beta(beta),
    .gamma(gamma),
    .a(a2),
    .b(b2),
    .c(c2)
  );
  
  // Clock 
  always #5 clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst_n = 0;
    a = 0;
    b = 0;
    c = 0;

    #20; rst_n = 1;

    a = 32767;
    b = 0;
    c = 0;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 0;
    b = 32767;
    c = 0;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 0;
    b = 0;
    c = 32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 32767;
    b = 0;
    c = 32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 32767;
    b = 32767;
    c = 32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = -32767;
    b = 0;
    c = 0;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 0;
    b = -32767;
    c = 0;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 0;
    b = 0;
    c = -32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 0;
    b = -32767;
    c = -32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

    a = 32767;
    b = 0;
    c = -32767;
    #10;
    $display("a2 = %f, b2 = %f", a2, b2);

  end

endmodule