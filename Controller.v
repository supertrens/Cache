// Controller

module Controller ( opcode,
                    funct,
                    // write your code in here
                    m_Rt_Rd,
                    m_ALU_PC8,
                    ALUOp,
                    mem_write_enable,
                    m_Rt2_imm,
                    reg_write_enable,
                    m_dtlh_ALUPC8,
                    m_R_31,
                    m_dt_lh,
                    m_dt_sh,
                    jump_pre_Op
                    );

    input  [5:0] opcode;
    input  [5:0] funct;

    // write your code in here
    output	m_Rt_Rd, m_ALU_PC8, mem_write_enable, m_Rt2_imm, reg_write_enable, m_dtlh_ALUPC8, m_R_31, m_dt_lh, m_dt_sh;
    output	[3:0]	ALUOp;
    output	[1:0]	jump_pre_Op;

    reg 	m_Rt_Rd, m_ALU_PC8, mem_write_enable, m_Rt2_imm, reg_write_enable, m_dtlh_ALUPC8, m_R_31, m_dt_lh, m_dt_sh;
    reg 	[3:0]	ALUOp;
    reg		[1:0]	jump_pre_Op;

    always @(*)	begin
    	m_Rt_Rd				= 0;
    	m_ALU_PC8			= 0;
    	mem_write_enable	= 0;
    	m_Rt2_imm			= 0;
    	reg_write_enable	= 0;
    	ALUOp				= 0;
    	m_dtlh_ALUPC8 		= 0;
    	m_R_31				= 0;
    	m_dt_lh				= 0;
    	m_dt_sh				= 0;
    	jump_pre_Op 		= 0;
    	case(opcode)
    		6'b00_0000	:	begin
				case(funct)
    				6'b10_0000 :	begin //add
    					ALUOp = 1;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;

					end
    				6'b10_0010 :	begin //sub
    					ALUOp = 2;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b10_0100 :	begin //and
    					ALUOp = 3;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b10_0101 :	begin //or
    					ALUOp = 4;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b10_0110 :	begin //xor
    					ALUOp = 5;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b10_0111 :	begin //nor
    					ALUOp = 6;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b10_1010 :	begin //slt
    					ALUOp = 7;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b00_0000 :	begin //sll
    					ALUOp = 8;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b00_0010 :	begin //srl
    					ALUOp = 9;
    					m_Rt_Rd = 1;
				    	reg_write_enable = 1;
    					m_dtlh_ALUPC8 = 1;
    				
					end
    				6'b00_1000 :	begin //jr
    					jump_pre_Op = 1;
                        m_dtlh_ALUPC8 = 1; // 因为 Hazard load 的判断是根据这个MUX！！
    				
					end
    				6'b00_1001 :	begin //jalr
    					m_R_31 = 1;
    					jump_pre_Op = 1;
				    	reg_write_enable = 1;
                        m_ALU_PC8           = 1;
                        m_dtlh_ALUPC8       = 1;

   				
					end
				endcase

			end
			// I-type
			6'b00_1000 	:	begin //addi
				ALUOp = 1;
				reg_write_enable = 1;
                m_dtlh_ALUPC8 = 1;
                m_Rt2_imm = 1;
				
			end
			6'b00_1100 	:	begin //andi
				ALUOp = 3;
                reg_write_enable = 1;
                m_dtlh_ALUPC8 = 1;
                m_Rt2_imm = 1;

			end
			6'b00_1010 	:	begin //slti
				ALUOp = 7;
				reg_write_enable = 1;
                m_dtlh_ALUPC8 = 1;
                m_Rt2_imm = 1;

			
			end
			6'b00_0100 	:	begin //beq
				ALUOp = 10;
				jump_pre_Op = 2;
                m_dtlh_ALUPC8 = 1;

				
			end
			6'b00_0101 	:	begin //bne
				ALUOp = 11;
				jump_pre_Op = 2;
                m_dtlh_ALUPC8 = 1;

			end
			6'b10_0011 	:	begin //lw
				ALUOp = 1;
				m_ALU_PC8 = 1;
				reg_write_enable = 1;
                m_Rt2_imm = 1;

			end
			6'b10_0001 	:	begin //lh
                ALUOp = 1;
                m_ALU_PC8 = 1;
                reg_write_enable = 1;
                m_dt_lh = 1;
                m_Rt2_imm = 1;


			end
			6'b10_1011 	:	begin //sw
				ALUOp = 1;
				mem_write_enable = 1;
                m_dtlh_ALUPC8 = 1;
                m_Rt2_imm = 1;

			end

			6'b10_1001 	:	begin //sh
                ALUOp = 1;
                mem_write_enable = 1;
                m_dtlh_ALUPC8 = 1;
                m_dt_sh = 1;
                m_Rt2_imm = 1;
			
			end
			// J-type
			6'b00_0010 	:	begin //j
				jump_pre_Op = 3;
                m_dtlh_ALUPC8 = 1;
			
			end
			6'b00_0011 	:	begin //jal
				jump_pre_Op = 3;
				m_R_31 = 1;
				reg_write_enable = 1;
                m_ALU_PC8 = 1;
                m_dtlh_ALUPC8       = 1;
                
			
			end
		endcase
    end

endmodule




