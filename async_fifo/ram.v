module ram
    #(    
        parameter FIFO_WIDTH     = 10'd8,
        parameter FIFO_WIDTH_BIT = 10'd3,
        parameter FIFO_DEPTH     = 10'd16,
        parameter FIFO_DEPTH_BIT = 10'd4
    ) 
    (
        input                      w_clk,r_clk,
        input                      w_rst,r_rst,
        input                      w_en ,r_en,
        input                      flag_full,flag_empty,
        input [FIFO_DEPTH_BIT-1:0] write_addr,
        input [FIFO_DEPTH_BIT-1:0] read_addr,
        input [FIFO_WIDTH-1:0]     data_write,

        output reg [FIFO_WIDTH-1:0] data_read
    );
  
    reg [FIFO_WIDTH-1:0] memory [FIFO_DEPTH-1:0];
    reg [FIFO_DEPTH_BIT:0] index;

    always @(posedge w_clk or posedge w_rst) begin
        if(w_rst) //initiate RAM 
            for(index=0 ; index<=FIFO_DEPTH-1 ;index=index+1)
                memory[index] <= 0;
        else if(w_en && (!flag_full))
            	memory[write_addr] <= data_write; //write data
        else ;
    end

    always @(posedge r_clk or posedge r_rst) begin
        if (r_en && (!flag_empty ))
            data_read <= memory[read_addr]; //read data
        else ;
    end


endmodule
