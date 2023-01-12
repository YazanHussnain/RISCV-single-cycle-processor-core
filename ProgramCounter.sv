module Program_Counter(clk, reset, PC_Next, PC_Out);
	input logic clk, reset;
	input logic [31:0] PC_Next;
	output logic [31:0] PC_Out;
	
	always_ff@(posedge clk) begin
		if(reset) begin
			PC_Out <= 32'h00000000;
		end else begin
			PC_Out <= PC_Next;
		end
	end
endmodule