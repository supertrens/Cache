// Program Counter

module PC ( clk, 
            rst,
            PCWrite,
            PCin, 
            PCout);

    parameter bit_size = 18;
    
    input  clk, rst;
    input  PCWrite;
    input  [bit_size-1:0] PCin;
    output [bit_size-1:0] PCout;

    // write your code in here
    reg     [bit_size-1:0] PCout;
    
    always@(negedge clk or posedge rst) begin
        if(rst)
            PCout <= 0;
        else if(PCWrite)
            PCout <= PCin;
        else
            PCout <= PCout;
    end

endmodule

