`timescale 1ns/100ps

module clark_transform_tb;

  // Inputs
  logic clk;
  logic rst_n;
  logic signed [15:0] a, b, c;
  
  // Outputs
  logic signed [15:0] alpha, beta, gamma;
  
  // Instantiate the DUT
  clark_transform dut(
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .c(c),
    .alpha(alpha),
    .beta(beta),
    .gamma(gamma)
  );
  
  // Clock 
  always #5 clk = ~clk;
  
  initial begin
    a = 0;
    b = 0;
    c = 0;
    clk = 0;
    rst_n = 0;
    #20;
    rst_n = 1;
  end
  
  initial begin
    #10 a = 32767; b = 0; c = -32767;
    #10 $display("alpha=%f, beta=%f, gamma=%f", alpha, beta, gamma);
    
    #10 a = 0; b = 32767; c = -32767;
    #10 $display("alpha=%f, beta=%f, gamma=%f", alpha, beta, gamma);
    
    #10 a = -32767; b = 32767; c = 0;
    #10 $display("alpha=%f, beta=%f, gamma=%f", alpha, beta, gamma);
    
  end
  
endmodule