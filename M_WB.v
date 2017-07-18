// M_WB

module M_WB ( clk,
              rst,
              M_WBWrite,
			  M_MemtoReg,
			  M_RegWrite,
			  M_DM_Read_Data,
			  M_WD_out,
			  M_WR_out,
			  WB_MemtoReg,
			  WB_RegWrite,
			  WB_DM_Read_Data,
			  WB_WD_out,
              WB_WR_out
			  );
	
	parameter data_size = 32;
	
	input clk, rst, M_WBWrite;
	
	// WB
    input M_MemtoReg;	
    input M_RegWrite;	
	// pipe
    input [data_size-1:0] M_DM_Read_Data;
    input [data_size-1:0] M_WD_out;
    input [4:0] M_WR_out;

	// WB
	output WB_MemtoReg;
	output WB_RegWrite;
	// pipe
    output [data_size-1:0] WB_DM_Read_Data;
    output [data_size-1:0] WB_WD_out;
    output [4:0] WB_WR_out;
	
	// write your code in here
	reg WB_MemtoReg, WB_RegWrite;
	reg [data_size-1:0] WB_DM_Read_Data, WB_WD_out;
	reg [4:0] WB_WR_out;
	
	always @(negedge clk or posedge rst) begin
		if (rst)	begin
			WB_MemtoReg		 <= 1;
			WB_RegWrite		 <= 0;
			WB_DM_Read_Data	 <= 0;
			WB_WD_out		 <= 0;
			WB_WR_out		 <= 0;		
		end
		else if(M_WBWrite)	begin
			WB_MemtoReg		 <= M_MemtoReg;
			WB_RegWrite		 <= M_RegWrite;
			WB_DM_Read_Data	 <= M_DM_Read_Data;
			WB_WD_out		 <= M_WD_out;
			WB_WR_out		 <= M_WR_out;		
		end
		else	begin
			WB_MemtoReg		 <= WB_MemtoReg;
			WB_RegWrite		 <= WB_RegWrite;
			WB_DM_Read_Data	 <= WB_DM_Read_Data;
			WB_WD_out		 <= WB_WD_out;
			WB_WR_out		 <= WB_WR_out;		
		end
	end	

endmodule












