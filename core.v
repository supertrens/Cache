// top

`include "PC.v"
`include "Controller.v"
`include "Regfile.v"
`include "ALU.v"
`include "Jump_Ctrl.v"
`include "ADDER.v"
`include "MUX_2_1.v"
`include "MUX_4_1.v"
`include "SignExtend.v"
`include "LeftShift2.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_M.v"
`include "M_WB.v"

module core (
			  clk,
              rst,
			  // Instruction Cache
			  IC_stall,
			  IC_Address,
              Instruction,
			  // Data Cache
			  DC_stall,
			  DC_Address,
			  DC_Read_enable,
			  DC_Write_enable,
			  DC_Write_Data,
			  DC_Read_Data
			  );

	parameter data_size = 32;
	parameter mem_size = 16;
	parameter pc_size = 18;
	
	input  clk, rst;
	
	// Instruction Cache
	input  IC_stall;
	output [mem_size-1:0] IC_Address;
	input  [data_size-1:0] Instruction;
	
	// Data Cache
	input  DC_stall;
	output [mem_size-1:0] DC_Address;
	output DC_Read_enable;
	output DC_Write_enable;
	output [data_size-1:0] DC_Write_Data;
    input  [data_size-1:0] DC_Read_Data;
	
	// Write your code here
	wire [17:0] PCin;
    wire [17:0] PCout;
    wire PCWrite;
    assign IC_Address = PCout[17:2];
    PC myPC ( 
            .clk(clk), 
            .rst(rst),
            .PCWrite(PCWrite),
            .PCin(PCin), 
            .PCout(PCout)
            );

    wire [17:0] PC4;
    wire [17:0] four;
    assign four = {{15{1'b0}}, 3'b100};
    ADDER PC_PC4( 
                .in1(PCout),
                .in2(four),
                .out(PC4)
                );

    wire [17:0] ID_PC4;
    wire  [data_size-1:0] ID_Instruction;
    wire IF_IDWrite, IF_Flush; //Haven't used !!!
    IF_ID myIF_ID (.clk(clk),
                   .rst(rst),
                   .IF_IDWrite(IF_IDWrite),
                   .IF_Flush(IF_Flush),
                   .IF_PC(PC4),
                   .IF_ir(Instruction),
                   .ID_PC(ID_PC4),
                   .ID_ir(ID_Instruction)
                   );

    wire [5:0]  opcode;
    wire [5:0]  funct;
    wire        m_Rt_Rd; //2
    wire        m_R_31; //2
    wire        reg_write_enable; //2
    wire        m_Rt2_imm; //3
    wire [3:0]  ALUOp; //3
    wire [1:0]  jump_pre_Op; //3
    wire        mem_write_enable; //4
    wire        m_dt_lh; //4
    wire        m_dt_sh; //4
    wire        m_ALU_PC8; //4
    wire        m_dtlh_ALUPC8; //5
    //wire        m_Jr;
    //wire        m_Branch;
    //wire        m_Jump;
    //wire        m_ALU_dtex; // NO
    //wire        m_PC8_ALUdtex; // NO
    assign opcode = ID_Instruction[31:26];
    assign funct = ID_Instruction[5:0];

    Controller  myController(
                            .opcode(opcode),
                            .funct(funct),
                            .m_Rt_Rd(m_Rt_Rd),
                            .m_R_31(m_R_31),
                            .reg_write_enable(reg_write_enable),
                            .m_Rt2_imm(m_Rt2_imm),
                            .ALUOp(ALUOp),
                            .jump_pre_Op(jump_pre_Op),
                            .mem_write_enable(mem_write_enable),
                            .m_dt_lh(m_dt_lh),
                            .m_dt_sh(m_dt_sh),
                            .m_ALU_PC8(m_ALU_PC8),
                            .m_dtlh_ALUPC8(m_dtlh_ALUPC8)
                            );

    wire [4:0]  Rs, Rt, Rd;
    wire [31:0] Rs2, Rt2;
    wire [31:0] Write_data;
    wire [4:0]  WB_Write_addr;
    wire        WB_reg_write_enable;
    assign Rs = ID_Instruction[25:21];
    assign Rt = ID_Instruction[20:16];
    assign Rd = ID_Instruction[15:11];
    Regfile myRegfile(   
                    .clk(clk), 
                    .rst(rst),
                    .Read_addr_1(Rs),
                    .Read_addr_2(Rt),
                    .Read_data_1(Rs2),
                    .Read_data_2(Rt2),
                    .RegWrite(WB_reg_write_enable),
                    .Write_addr(WB_Write_addr),
                    .Write_data(Write_data)
                    );

    wire [15:0] imm;
    wire [31:0] imm_extended;
    assign imm = ID_Instruction[15:0];
    SignExtend  mySign  ( 
                        .in(imm),
                        .out(imm_extended)
                        );

    wire [4:0]  Rt_Rd;
    MUX_2_1#(5) Mux_Rt_Rd   (
                            .in0(Rt),
                            .in1(Rd),
                            .sec(m_Rt_Rd),
                            .out(Rt_Rd)
                            );

    wire [4:0]  R31;
    wire [4:0]  Write_addr;
    assign R31 = {5{1'b1}};
    MUX_2_1#(5) Mux_R_31    (
                        .in0(Rt_Rd),
                        .in1(R31),
                        .sec(m_R_31),
                        .out(Write_addr)
                        );

    wire[4:0]   shamt;
    assign shamt = ID_Instruction[10:6];

    wire                    ID_Flush;
    wire                    ID_EXWrite;
    wire                    EX_m_dtlh_ALUPC8;
    wire                    EX_reg_write_enable;
    wire                    EX_mem_write_enable;
    wire                    EX_m_ALU_PC8;
    wire                    EX_m_Rt2_imm;
    wire [1:0]              EX_jump_pre_Op;
    wire [17:0]             EX_PC4;
    wire [3:0]              EX_ALUOp;
    wire [4:0]              EX_shamt;
    wire [data_size-1:0]    EX_Rs2;
    wire [data_size-1:0]    EX_Rt2;
    wire [data_size-1:0]    EX_imm_extended;
    wire [4:0]              EX_Write_addr;
    wire [4:0]              EX_Rs;
    wire [4:0]              EX_Rt;
    wire                    EX_m_dt_lh;
    wire                    EX_m_dt_sh;
    ID_EX myID_EX   ( 
                    .clk(clk),  
                    .rst(rst),
                    .ID_Flush(ID_Flush),
		            .ID_EXWrite(ID_EXWrite),
                    .ID_MemtoReg(m_dtlh_ALUPC8),
                    .ID_RegWrite(reg_write_enable),
                    .ID_MemWrite(mem_write_enable),
                    .ID_m_ALU_PC8(m_ALU_PC8),
                    .ID_Reg_imm(m_Rt2_imm),
                    .ID_jump_pre_Op(jump_pre_Op),
                    .ID_PC(ID_PC4),
                    .ID_ALUOp(ALUOp),
                    .ID_shamt(shamt),
                    .ID_Rs_data(Rs2),
                    .ID_Rt_data(Rt2),
                    .ID_se_imm(imm_extended),
                    .ID_WR_out(Write_addr),
                    .ID_Rs(Rs),
                    .ID_Rt(Rt),
                    .ID_m_dt_lh(m_dt_lh),
                    .ID_m_dt_sh(m_dt_sh),
                    .EX_MemtoReg(EX_m_dtlh_ALUPC8),
                    .EX_RegWrite(EX_reg_write_enable),
                    .EX_MemWrite(EX_mem_write_enable),
                    .EX_m_ALU_PC8(EX_m_ALU_PC8),
                    .EX_Reg_imm(EX_m_Rt2_imm),
                    .EX_jump_pre_Op(EX_jump_pre_Op),
                    .EX_PC(EX_PC4),
                    .EX_ALUOp(EX_ALUOp),
                    .EX_shamt(EX_shamt),
                    .EX_Rs_data(EX_Rs2),
                    .EX_Rt_data(EX_Rt2),
                    .EX_se_imm(EX_imm_extended),
                    .EX_WR_out(EX_Write_addr),
                    .EX_Rs(EX_Rs),
                    .EX_Rt(EX_Rt),
                    .EX_m_dt_lh(EX_m_dt_lh),
                    .EX_m_dt_sh(EX_m_dt_sh)
                    );

    wire [17:0] imm_shifted;
    LeftShift2 myLeft   ( 
                        .in(EX_imm_extended[15:0]),
                        .out(imm_shifted)
                        );   

    wire[17:0]  PC4imm;
    ADDER PC4_imm ( 
                  .in1(EX_PC4),
                  .in2(imm_shifted),
                  .out(PC4imm)
                  );

    wire [31:0] M_WB_1;
    wire [31:0] ALU_PC8;
    MUX_2_1#(data_size) Mux_M_WB_1   (
                                    .in0(ALU_PC8),
                                    .in1(Write_data),
                                    .sec(mf_M_WB_1),
                                    .out(M_WB_1)
                                    );
    wire [31:0]   ALU_src1;
    MUX_2_1#(data_size) Mux_forward_Rs2 (
                                        .in0(M_WB_1),
                                        .in1(EX_Rs2),
                                        .sec(mf_forward_Rs2),
                                        .out(ALU_src1)
                                        );

    wire [31:0] M_WB_2;
    MUX_2_1#(data_size) Mux_M_WB_2   (
                                    .in0(ALU_PC8),
                                    .in1(Write_data),
                                    .sec(mf_M_WB_2),
                                    .out(M_WB_2)
                                    );

    wire [data_size-1:0]   forward_Rt2;
    MUX_2_1#(data_size) Mux_forward_Rt2 (
                                        .in0(M_WB_2),
                                        .in1(EX_Rt2),
                                        .sec(mf_forward_Rt2),
                                        .out(forward_Rt2)
                                        );

    wire [data_size-1:0]    ALU_src2;
    MUX_2_1#(data_size) Mux_Rt2_imm (
                                    .in0(forward_Rt2),
                                    .in1(EX_imm_extended),
                                    .sec(EX_m_Rt2_imm),
                                    .out(ALU_src2)
                                    );

    wire [data_size-1:0] ALU_result;
    wire                 Zero;
    ALU myALU   (   
                .ALUOp(EX_ALUOp),
                .src1(ALU_src1),
                .src2(ALU_src2),
                .shamt(EX_shamt),
                .ALU_result(ALU_result),
                .Zero(Zero)
                );

    wire [1:0] JumpOp;
    Jump_Ctrl   myJump  ( 
                        .Zero(Zero),
                        .JumpOp(JumpOp),
                        .jump_pre_Op(EX_jump_pre_Op)
                        );

    MUX_4_1 Jump_Mux    (
                        .in0(PC4),
                        .in1(ALU_src1[17:0]),
                        .in2(PC4imm),
                        .in3(imm_shifted),
                        .sec(JumpOp),
                        .out(PCin)
                        );

    wire [31:0] PC8;
    ADDER#(18, data_size) PC4_PC8   ( 
                                    .in1(EX_PC4),
                                    .in2(four),
                                    .out(PC8)
                                    );


	wire 	EX_MWrite;
	wire 	M_WBWrite;
    HDU myHDU(
             .ID_Rs(Rs),
             .ID_Rt(Rt),
             .IC_stall(IC_stall),
             .DC_stall(DC_stall),
             .EX_WR_out(EX_Write_addr),
             .EX_MemtoReg(EX_m_dtlh_ALUPC8),
             .EX_JumpOP(JumpOp),
             .PCWrite(PCWrite),
             .IF_IDWrite(IF_IDWrite),        
             .ID_EXWrite(ID_EXWrite),
			 .EX_MWrite(EX_MWrite),
			 .M_WBWrite(M_WBWrite),
             .IF_Flush(IF_Flush),
             .ID_Flush(ID_Flush)
             );

    wire                    M_m_dtlh_ALUPC8;
    wire                    M_reg_write_enable;
    wire                    M_mem_write_enable;
    wire                    M_m_ALU_PC8;
    wire [data_size-1:0]    M_ALU_result;
    wire [data_size-1:0]    M_forward_Rt2;
    wire [data_size-1:0]    M_PC8;
    wire [4:0]              M_Write_addr;
    wire                    M_m_dt_lh;
    wire                    M_m_dt_sh;
    assign DC_Read_enable = ~M_m_dtlh_ALUPC8;
    EX_M    myEX_M  (   
                    .clk(clk),
                    .rst(rst),
					.EX_MWrite(EX_MWrite),
                    .EX_MemtoReg(EX_m_dtlh_ALUPC8),
                    .EX_RegWrite(EX_reg_write_enable),
                    .EX_MemWrite(EX_mem_write_enable),
                    .EX_m_ALU_PC8(EX_m_ALU_PC8),
                    .EX_ALU_result(ALU_result),
                    .EX_Rt_data(forward_Rt2),
                    .EX_PCplus8(PC8),
                    .EX_WR_out(EX_Write_addr),
                    .EX_m_dt_lh(EX_m_dt_lh),
                    .EX_m_dt_sh(EX_m_dt_sh),
                    .M_MemtoReg(M_m_dtlh_ALUPC8),
                    .M_RegWrite(M_reg_write_enable),
                    .M_MemWrite(M_mem_write_enable),
                    .M_m_ALU_PC8(M_m_ALU_PC8),
                    .M_ALU_result(M_ALU_result),
                    .M_Rt_data(M_forward_Rt2),
                    .M_PCplus8(M_PC8),
                    .M_WR_out(M_Write_addr),
                    .M_m_dt_lh(M_m_dt_lh),
                    .M_m_dt_sh(M_m_dt_sh)
                    );  

    assign DC_Address = M_ALU_result[17:2];

    MUX_2_1#(data_size) Mux_dt_sh   (
                                    .in0(M_forward_Rt2),
                                    .in1({{16{M_forward_Rt2[15]}}, M_forward_Rt2[15:0]}),
                                    .sec(M_m_dt_sh),
                                    .out(DC_Write_Data)
                                    );

    wire [31:0] dt_lh;
    MUX_2_1#(data_size) Mux_dt_lh   (
                                    .in0(DC_Read_Data),
                                    .in1({{16{DC_Read_Data[15]}}, DC_Read_Data[15:0]}),
                                    .sec(M_m_dt_lh),
                                    .out(dt_lh)
                                    );

    MUX_2_1#(data_size) Mux_ALU_PC8 (
                        .in0(M_ALU_result),
                        .in1(M_PC8),
                        .sec(M_m_ALU_PC8),
                        .out(ALU_PC8)
                        );

    assign DC_Write_enable = M_mem_write_enable;

    wire                    WB_m_dtlh_ALUPC8;
    wire [data_size-1:0]    WB_dt_lh;
    wire [data_size-1:0]    WB_ALU_PC8;

    M_WB    myM_WB  ( 
                    .clk(clk),
                    .rst(rst),
					.M_WBWrite(M_WBWrite),
                    .M_MemtoReg(M_m_dtlh_ALUPC8),
                    .M_RegWrite(M_reg_write_enable),
                    .M_DM_Read_Data(dt_lh),
                    .M_WD_out(ALU_PC8),
                    .M_WR_out(M_Write_addr),
                    .WB_MemtoReg(WB_m_dtlh_ALUPC8),
                    .WB_RegWrite(WB_reg_write_enable),
                    .WB_DM_Read_Data(WB_dt_lh),
                    .WB_WD_out(WB_ALU_PC8),
                    .WB_WR_out(WB_Write_addr)
                    );
    
    MUX_2_1#(data_size) Mux_dtlh_ALUPC8 (
                                        .in0(WB_dt_lh),
                                        .in1(WB_ALU_PC8),
                                        .sec(WB_m_dtlh_ALUPC8),
                                        .out(Write_data)
                                        );

    FU myFU (
            .EX_Rs(EX_Rs),
            .EX_Rt(EX_Rt),
            .M_RegWrite(M_reg_write_enable),
            .M_WR_out(M_Write_addr),
            .WB_RegWrite(WB_reg_write_enable),
            .WB_WR_out(WB_Write_addr),
            .mf_M_WB_1(mf_M_WB_1),
            .mf_forward_Rs2(mf_forward_Rs2),
            .mf_M_WB_2(mf_M_WB_2),
            .mf_forward_Rt2(mf_forward_Rt2)
            );

endmodule
