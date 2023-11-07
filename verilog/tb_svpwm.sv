`timescale 1ps / 1ps

module svpwm_tb;

  // Inputs
  logic clk;
  logic rst_n;
  logic signed [15:0] V_alpha, V_beta;
  logic signed [15:0] carrier;

  // Outputs
  logic signed [15:0] X, Y, Z;
  logic signed [15:0] Ta, Tb;
  logic signed [15:0] T0;
  logic signed [15:0] RefA, RefB, RefC;
  logic [2:0] sector;
  logic [2:0] switch;
  logic [5:0] gate;

  // parameter PI = 3.1415927;

  svpwm uut (
    .clk(clk), 
    .rst_n(rst_n), 
    .V_alpha(V_alpha), 
    .V_beta(V_beta), 
    .carrier(carrier),
    .RefA(RefA),
    .RefB(RefB),
    .RefC(RefC),
    .X(X),
    .Y(Y),
    .Z(Z),
    .Ta(Ta),
    .Tb(Tb),
    .T0(T0),
    .sector(sector),
    .switch(switch),
    .gate(gate)
  );

  logic tri_clk;
  always #1 tri_clk = ~tri_clk;

  always #50000 clk = ~clk;

  // triangular wave Ts = 262140 ns
  logic [16:0] counter;
  always_ff @(posedge tri_clk or negedge rst_n) begin
    if (!rst_n) begin
			counter <= 17'b0;
      V_alpha <= 16'b0;
      V_beta <= 16'b0;
      carrier <= 16'h8001; // maximum negative value= -32767
		end else begin
      counter <= counter + 17'b1;
      V_alpha <= 32767 * $signed($sin(counter));
      V_beta <= 32767 * $signed($cos(counter));
      carrier <= (counter < 17'hffff)? carrier + 1 : carrier - 1;
    end
  end

  initial begin
    clk = 0;
    tri_clk = 0;
    rst_n = 0;
    #200;
    rst_n = 1;
    #100000;
  end

endmodule