`timescale 1ns / 100ps

module svpwm (
	input logic clk,
	input logic rst_n,
	input logic signed [15:0] V_alpha, V_beta,
	input logic signed [15:0] carrier,
	output logic signed [15:0] X, Y, Z,
	output logic signed [15:0] Ta, Tb,
	output logic signed [15:0] T0,
	output logic signed [15:0] RefA, RefB, RefC,
	output logic [2:0] sector,
	output logic [2:0] switch,
	output logic [5:0] gate
);

	parameter PI = 3.1415927;
	parameter Ts = 131.07; // switching period
	// 65535
	parameter Vdc = 24; // DC voltage

	logic signed [15:0] Va, Vb, Vc;
	// logic [2:0] sector;
	logic [2:0] sector_buff, sector_buff2, sector_buff3;

	// logic signed [15:0] X, Y, Z;
	// logic signed [15:0] Ta, Tb;
	logic signed [15:0] Ta_buff, Tb_buff;
	// logic signed [15:0] T0;
	logic signed [15:0] K, L, M, N;
	// logic signed [15:0] RefA, RefB, RefC;

	// logic [2:0] switch;

	// determine sector
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			sector <= 3'b0;
			sector_buff <= 3'b0;
			sector_buff2 <= 3'b0;
			sector_buff3 <= 3'b0;
		end else begin
			if (V_beta >= 0 && V_beta <= $sqrt(3)*V_alpha) begin
				sector <= 3'b0; // sector 1
			end else if (V_beta >= 0 && ((V_alpha >= 0 && V_beta >= $sqrt(3)*V_alpha)
			|| (V_alpha < 0 && V_beta >= -$sqrt(3)*V_alpha))) begin
				sector <= 3'd1; // sector 2
			end else if (V_beta >= 0 && V_beta <= -$sqrt(3)*V_alpha) begin
				sector <= 3'd2; // sector 3
			end else if (V_beta <= 0 && V_beta >= $sqrt(3)*V_alpha) begin
				sector <= 3'd3; // sector 4
			end else if (V_beta <= 0 && ((V_alpha <= 0 && V_beta <= $sqrt(3)*V_alpha)
			|| (V_alpha > 0 && V_beta <= -$sqrt(3)*V_alpha))) begin
				sector <= 3'd4; // sector 5
			end else if (V_beta <= 0 && V_beta >= -$sqrt(3)*V_alpha) begin
				sector <= 3'd5; // sector 6
			end else begin
				$display("Error in sector determination");
			end
			sector_buff <= sector;
			sector_buff2 <= sector_buff;
			sector_buff3 <= sector_buff2;
		end
	end

	// duty cycles
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			X <= 16'b0;
			Y <= 16'b0;
			Z <= 16'b0;
			Ta <= 16'b0;
			Tb <= 16'b0;
			Ta_buff <= 16'b0;
			Tb_buff <= 16'b0;
			T0 <= 16'b0;
		end else begin
			X <= $sqrt(3) * V_beta * Ts / Vdc;
			Y <= (1.5*V_alpha + $sqrt(3)/2.0*V_beta) * Ts / Vdc;
			Z <= (-1.5*V_alpha + $sqrt(3)/2.0*V_beta) * Ts / Vdc;
			case (sector)
				3'd0: begin
					Ta <= -Z;
					Tb <= X;
				end
				3'd1: begin 
					Ta <= Y;
					Tb <= Z;
				end
				3'd2: begin 
					Ta <= X;
					Tb <= -Y;
				end
				3'd3: begin
					Ta <= Z;
					Tb <= -X;
				end
				3'd4: begin
					Ta <= -Y;
					Tb <= -Z;
				end
				3'd5: begin
					Ta <= -X;
					Tb <= Y;
				end
				default: begin 
					$display("Invalid sector number");
				end
			endcase
			Ta_buff <= Ta;
			Tb_buff <= Tb;
			T0 <= Ts - Ta - Tb;
		end
	end

	// switch states within a half period
	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			K <= 16'b0;
			L <= 16'b0;
			M <= 16'b0;
			N <= 16'b0;
			RefA <= 16'b0;
			RefB <= 16'b0;
			RefC <= 16'b0;
		end else begin
			K <= T0/4.0;
			L <= T0/4.0 + Ta_buff/2.0;
			M <= T0/4.0 + Tb_buff/2.0;
			N <= T0/4.0 + Ta_buff/2.0 + Tb_buff/2.0;
			case (sector_buff3)
				3'd0: begin
					RefA <= K;
					RefB <= L;
					RefC <= N;
				end
				3'd1: begin 
					RefA <= M;
					RefB <= K;
					RefC <= N;
				end
				3'd2: begin 
					RefA <= N;
					RefB <= K;
					RefC <= L;
				end
				3'd3: begin
					RefA <= N;
					RefB <= M;
					RefC <= K;
				end
				3'd4: begin
					RefA <= L;
					RefB <= N;
					RefC <= K;
				end
				3'd5: begin
					RefA <= K;
					RefB <= N;
					RefC <= M;
				end
				default: begin 
					$display("Invalid sector number");
				end
			endcase
		end
	end

	// output switch signals
	always_comb begin
		switch[0] = (carrier > RefA);
		switch[1] = (carrier > RefB);
		switch[2] = (carrier > RefC);
		gate[0] = switch[0];
		gate[2] = switch[1];
		gate[4] = switch[2];
		gate[3] = ~gate[0];
		gate[5] = ~gate[2];
		gate[1] = ~gate[4];
	end

endmodule