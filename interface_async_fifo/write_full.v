module write_full 
    #(
        parameter FIFO_DEPTH_BIT = 10'd4
    )
    (
        input                         w_clk,
        input                         w_rst,
        input                         w_en,
        input [FIFO_DEPTH_BIT:0]      read_addr_gray_sync,
        
        output                        flag_full,
        output [FIFO_DEPTH_BIT-1:0]   write_addr,
        output [FIFO_DEPTH_BIT:0]     write_addr_gray
    );
    
    reg  [FIFO_DEPTH_BIT:0] write_addr_bin; //expand write_addr for 1bit
    reg  [FIFO_DEPTH_BIT:0] i;

    always @(posedge w_clk or posedge w_rst) begin // write_addr pointer add 1 atumatically
        if(w_rst)
            write_addr_bin <= 0;
        else if(w_en && !flag_full)
            write_addr_bin <= write_addr_bin + 1'b1;
        else
            write_addr_bin <= write_addr_bin;
    end

    assign write_addr_gray = (write_addr_bin>>1) ^ write_addr_bin; // binary to gray
    assign flag_full       = (write_addr_gray == {~read_addr_gray_sync[FIFO_DEPTH_BIT],~read_addr_gray_sync[FIFO_DEPTH_BIT-1],read_addr_gray_sync[FIFO_DEPTH_BIT-2:0]}); // produce flag_full signal
    assign write_addr      = write_addr_bin[FIFO_DEPTH_BIT-1:0]; //assign write_addr, cut 1 bit of write_addr_bin

endmodule
