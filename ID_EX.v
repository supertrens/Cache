// ID_EX

module ID_EX ( clk,  
               rst,
               // input 
			   ID_Flush,
	           ID_EXWrite,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M
			   ID_MemWrite,
			   // write your code in here
			   ID_m_ALU_PC8,
			   // EX
			   ID_Reg_imm,
			   // write your code in here	   
			   ID_jump_pre_Op,
			   // pipe
			   ID_PC,
			   ID_ALUOp,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
               ID_m_dt_lh,
               ID_m_dt_sh,
			   // output
			   // WB
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemWrite,
			   // write your code in here
			   EX_m_ALU_PC8,
			   // EX
			   EX_Reg_imm,
			   // write your code in here
			   EX_jump_pre_Op,
			   // pipe
			   EX_PC,
			   EX_ALUOp,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt,
               EX_m_dt_lh,
               EX_m_dt_sh
			   );
	
	parameter pc_size = 18;			   
	parameter data_size = 32;
	
	input clk, rst;
	input ID_Flush, ID_EXWrite;
	
	// WB
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite;
	// write your code in here
	input ID_m_ALU_PC8;
	// EX
	input ID_Reg_imm;
	// write your code in here
	input [1:0] ID_jump_pre_Op;
	// pipe
    input [pc_size-1:0] ID_PC;
    input [3:0] ID_ALUOp;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
    input 		ID_m_dt_lh;
	input 		ID_m_dt_sh;
	
	// WB
	output EX_MemtoReg;
	output EX_RegWrite;
	// M
	output EX_MemWrite;
	// write your code in here
	output EX_m_ALU_PC8;
	// EX
	output EX_Reg_imm;
	// write your code in here
	output [1:0] EX_jump_pre_Op;
	// pipe
	output [17:0] EX_PC;
	output [3:0] EX_ALUOp;
	output [4:0] EX_shamt;
	output [data_size-1:0] EX_Rs_data;
	output [data_size-1:0] EX_Rt_data;
	output [data_size-1:0] EX_se_imm;
	output [4:0] EX_WR_out;
	output [4:0] EX_Rs;
	output [4:0] EX_Rt;
    output 		EX_m_dt_lh;
	output 		EX_m_dt_sh;
	
	// write your code in here
	reg EX_MemtoReg, EX_RegWrite;
	reg EX_MemWrite, EX_m_ALU_PC8;
	reg EX_Reg_imm;
	reg [1:0] EX_jump_pre_Op;
	reg [17:0] EX_PC;
	reg [3:0] EX_ALUOp;
	reg [data_size-1:0] EX_Rs_data, EX_Rt_data, EX_se_imm;
	reg [4:0] EX_shamt, EX_WR_out, EX_Rs, EX_Rt;
	reg EX_m_dt_lh, EX_m_dt_sh;

	always @(negedge clk or posedge rst) begin
		if (rst || ID_Flush)	begin
		    EX_MemtoReg	 	<= 1; // 判断load是根据这个是不是0 ！！！！
			EX_RegWrite	 	<= 0;
			EX_MemWrite	 	<= 0;
		    EX_m_ALU_PC8	<= 0;
		    EX_Reg_imm	 	<= 0;
		    EX_jump_pre_Op	<= 0;		
		    EX_PC		 	<= 0;
		    EX_ALUOp	 	<= 0;
		    EX_shamt	 	<= 0;
		    EX_Rs_data	 	<= 0;
		    EX_Rt_data	 	<= 0;
		    EX_se_imm	 	<= 0;
		    EX_WR_out	 	<= 0;
		    EX_Rs		 	<= 0;
		    EX_Rt		 	<= 0;
    		EX_m_dt_lh		<= 0;
			EX_m_dt_sh		<= 0;
		end
		else if (ID_EXWrite)	begin
			EX_MemtoReg	 	<= ID_MemtoReg;
		    EX_RegWrite	 	<= ID_RegWrite;
		    EX_MemWrite	 	<= ID_MemWrite;
		    EX_m_ALU_PC8	<= ID_m_ALU_PC8;
		    EX_Reg_imm	 	<= ID_Reg_imm;
		    EX_jump_pre_Op	<= ID_jump_pre_Op;
		    EX_PC		 	<= ID_PC;
		    EX_ALUOp	 	<= ID_ALUOp;
		    EX_shamt	 	<= ID_shamt;
		    EX_Rs_data	 	<= ID_Rs_data;
		    EX_Rt_data	 	<= ID_Rt_data;
		    EX_se_imm	 	<= ID_se_imm;
		    EX_WR_out	 	<= ID_WR_out;
		    EX_Rs		 	<= ID_Rs;
		    EX_Rt		 	<= ID_Rt;
    		EX_m_dt_lh		<= ID_m_dt_lh;
			EX_m_dt_sh		<= ID_m_dt_sh;
		end
		else	begin
			EX_MemtoReg	 	<= EX_MemtoReg;
		    EX_RegWrite	 	<= EX_RegWrite;
		    EX_MemWrite	 	<= EX_MemWrite;
		    EX_m_ALU_PC8	<= EX_m_ALU_PC8;
		    EX_Reg_imm	 	<= EX_Reg_imm;
		    EX_jump_pre_Op	<= EX_jump_pre_Op;
		    EX_PC		 	<= EX_PC;
		    EX_ALUOp	 	<= EX_ALUOp;
		    EX_shamt	 	<= EX_shamt;
		    EX_Rs_data	 	<= EX_Rs_data;
		    EX_Rt_data	 	<= EX_Rt_data;
		    EX_se_imm	 	<= EX_se_imm;
		    EX_WR_out	 	<= EX_WR_out;
		    EX_Rs		 	<= EX_Rs;
		    EX_Rt		 	<= EX_Rt;
    		EX_m_dt_lh		<= EX_m_dt_lh;
			EX_m_dt_sh		<= EX_m_dt_sh;
		end		
	end			
	
endmodule










