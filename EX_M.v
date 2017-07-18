// EX_M

module EX_M ( clk,
			  rst,
			  EX_MWrite,
			  // input 
			  // WB
			  EX_MemtoReg,
			  EX_RegWrite,
			  // M
			  EX_MemWrite,
			  // write your code in here
			  EX_m_ALU_PC8,
			  // pipe
			  EX_ALU_result,
			  EX_Rt_data,
			  EX_PCplus8,
			  EX_WR_out,
			  EX_m_dt_lh,
			  EX_m_dt_sh,
			  // output
			  // WB
			  M_MemtoReg,
			  M_RegWrite,
			  // M
			  M_MemWrite,
			  // write your code in here
			  M_m_ALU_PC8,
			  // pipe
			  M_ALU_result,
			  M_Rt_data,
			  M_PCplus8,
			  M_WR_out,
			  M_m_dt_lh,
			  M_m_dt_sh
			  );
	
	parameter pc_size = 18;	
	parameter data_size = 32;
	
	input clk, rst, EX_MWrite;		  
			  
	// WB		  
	input EX_MemtoReg;
    input EX_RegWrite;
    // M
    input EX_MemWrite;
	// write your code in here
	input EX_m_ALU_PC8;
	// pipe		  
	input [data_size-1:0] EX_ALU_result;
    input [data_size-1:0] EX_Rt_data;
    input [data_size-1:0] EX_PCplus8;
    input [4:0] EX_WR_out;
	input EX_m_dt_lh;
	input EX_m_dt_sh;
	
	// WB
	output M_MemtoReg;	
	output M_RegWrite;	
	// M	
	output M_MemWrite;	
	// write your code in here
	output M_m_ALU_PC8;		
	// pipe		  
	output [data_size-1:0] M_ALU_result;
	output [data_size-1:0] M_Rt_data;
	output [data_size-1:0] M_PCplus8;
	output [4:0] M_WR_out;
	output M_m_dt_lh;
	output M_m_dt_sh;
	
	// write your code in here
	reg M_MemtoReg, M_RegWrite;	
	reg M_MemWrite, M_m_ALU_PC8;		
	reg [data_size-1:0] M_ALU_result, M_Rt_data;
	reg [data_size-1:0] M_PCplus8;
    reg [4:0] M_WR_out;
    reg M_m_dt_lh, M_m_dt_sh;

	always @(negedge clk or posedge rst) begin
		if (rst) begin
		    M_MemtoReg		<= 1;	
		    M_RegWrite		<= 0;	
		    M_MemWrite		<= 0;	
		    M_m_ALU_PC8		<= 0;		
		    M_ALU_result	<= 0;
		    M_Rt_data		<= 0;
		    M_PCplus8		<= 0;
		    M_WR_out		<= 0;	
			M_m_dt_lh		<= 0;
			M_m_dt_sh		<= 0;
		end
		else if(EX_MWrite)
		begin
			M_MemtoReg		<= EX_MemtoReg;
		    M_RegWrite		<= EX_RegWrite;
		    M_MemWrite		<= EX_MemWrite;
		    M_m_ALU_PC8		<= EX_m_ALU_PC8;	
		    M_ALU_result	<= EX_ALU_result;
		    M_Rt_data		<= EX_Rt_data;
		    M_PCplus8		<= EX_PCplus8;
		    M_WR_out		<= EX_WR_out;	
			M_m_dt_lh		<= EX_m_dt_lh;
			M_m_dt_sh		<= EX_m_dt_sh;
		end
		else
		begin
			M_MemtoReg		<= M_MemtoReg;
		    M_RegWrite		<= M_RegWrite;
		    M_MemWrite		<= M_MemWrite;
		    M_m_ALU_PC8		<= M_m_ALU_PC8;	
		    M_ALU_result	<= M_ALU_result;
		    M_Rt_data		<= M_Rt_data;
		    M_PCplus8		<= M_PCplus8;
		    M_WR_out		<= M_WR_out;	
			M_m_dt_lh		<= M_m_dt_lh;
			M_m_dt_sh		<= M_m_dt_sh;
		end
	end
	
	
endmodule


























