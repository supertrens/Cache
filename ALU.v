// ALU

module ALU ( ALUOp,
			 src1,
			 src2,
			 shamt,
			 ALU_result,
			 Zero);
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output [bit_size-1:0] ALU_result;
	output Zero;
			
	// write your code in here
	reg [bit_size-1:0] 	ALU_result;
	reg					Zero;
	always@(*)
	begin
		ALU_result = 0;
		Zero = 0;
		case(ALUOp)
			 1	:	 ALU_result = src1 + src2;	
			 2	:	 ALU_result = src1 - src2;	
			 3	:	 ALU_result = src1 & src2;
			 4	:	 ALU_result = src1 | src2;
			 5	:	 ALU_result = src1 ^ src2;
			 6	:	 ALU_result = ~(src1 | src2);
			 7	:	 ALU_result = {{31{1'b0}}, src1 < src2 ? 1 : 0};
			 8	:	 ALU_result = src2 << shamt;
			 9	:	 ALU_result = src2 >> shamt;
			10	:		  Zero = src1 == src2 ? 1 : 0;
			11	:		  Zero = src1 == src2 ? 0 : 1;
		endcase
	end

endmodule
