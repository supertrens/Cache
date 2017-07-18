// Cache Control

module Cache_Control ( 
					   clk,
					   rst,
					   // input
					   en_R,
					   en_W,
					   hit,
					   // output
					   Read_mem,
					   Write_mem,
					   Valid_enable,
					   Tag_enable,
					   Data_enable,
					   sel_mem_core,
					   stall
					   );

	input clk, rst;
	input en_R;
	input en_W;
    input hit;

	output Read_mem;
	output Write_mem;
	output Valid_enable;
	output Tag_enable;
	output Data_enable;
	output sel_mem_core;		// 0 data from mem, 1 data from core
	output stall;

	// write your code here
	reg Read_mem;
	reg Write_mem;
	reg Valid_enable;
	reg Tag_enable;
	reg Data_enable;
	reg sel_mem_core;
	reg stall;	

	reg [1:0] state_now;
	reg [1:0] state_nxt;

	wire r_miss;
	assign r_miss =  en_R == 1 && hit == 0 ? 1 : 0;

	// states, r for read
	parameter r_idle	= 0,
			  r_wait	= 1,
			  r_mem		= 2;

	// states, w for write
	parameter w_miss = 0,
			  w_hit	 = 1;
	
	always @ (*) begin
		case (state_now)
			r_idle		: state_nxt = r_miss ? r_wait : r_idle;
			r_wait		: state_nxt = r_mem;
			r_mem		: state_nxt = r_idle;
		endcase
	end
	
	always @ (*) begin
		if(r_miss)
			stall = 1;
		else 
			stall = 0;

		Read_mem	 = 0;
		Write_mem	 = 0;
		Valid_enable = 0;
		Tag_enable	 = 0;
		Data_enable	 = 0;
		sel_mem_core = 0;
		
		case ({{en_R},{en_W}})
			2'b01	 : begin // write
				Write_mem	= 1;
				if(hit == 1) 	begin 
					Valid_enable = 1;
					Tag_enable	 = 1;
					Data_enable	 = 1;
					sel_mem_core = 1;
				end
			end
			2'b10: 		begin // read
				if(state_now == r_idle)
					Read_mem = 1;
				else if(state_now == r_mem) 	begin
					Read_mem = 1;
					Valid_enable = 1;
					Tag_enable	 = 1;
					Data_enable	 = 1;
				end
			end
		endcase
	end

	always @ (posedge clk or posedge rst)
		state_now <=  rst ? r_idle : state_nxt;
	
endmodule
