// Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			// write your code in here
			mf_M_WB_1,
			mf_forward_Rs2,
			mf_M_WB_2,
			mf_forward_Rt2
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	output mf_M_WB_1;
	output mf_forward_Rs2;
	output mf_M_WB_2;
	output mf_forward_Rt2;

	reg mf_M_WB_1;
	reg mf_forward_Rs2;
	reg mf_M_WB_2;
	reg mf_forward_Rt2;

	// write your code in here
	always@ (*)	begin
		mf_M_WB_1		= 0;
		mf_forward_Rs2	= 1;
		mf_M_WB_2		= 0;
		mf_forward_Rt2	= 1;

		// 顺序很重要！！=.=
		if(WB_RegWrite && WB_WR_out != 0) begin// 隔着一个指令RAW

			
			if(WB_WR_out == EX_Rs)	begin 
				mf_M_WB_1		= 1;
				mf_forward_Rs2	= 0;
			end
			else if(WB_WR_out == EX_Rt) begin
				mf_M_WB_2		= 1;
				mf_forward_Rt2	= 0;
			end

		end
		if(M_RegWrite && M_WR_out != 0) begin// 直接RAW

			if(M_WR_out == EX_Rs)	begin 	
				mf_M_WB_1		= 0; //不然会被前面覆盖！！=.=
				mf_forward_Rs2	= 0;
			end
			else if(M_WR_out == EX_Rt)	begin
				mf_M_WB_2		= 0;
				mf_forward_Rt2	= 0;
			end
		end

	end
endmodule




























