module read_empty
    #(
        parameter FIFO_DEPTH_BIT = 10'd4
    )
    (
        input                         r_clk,
        input                         r_rst,
        input                         r_en,
        input [FIFO_DEPTH_BIT:0]      write_addr_gray_sync,

        output                        flag_empty,
        output [FIFO_DEPTH_BIT-1:0]   read_addr,
        output [FIFO_DEPTH_BIT:0]     read_addr_gray
    );
   
    reg  [FIFO_DEPTH_BIT:0] read_addr_bin; //expand read_addr for 1bit
    reg  [FIFO_DEPTH_BIT:0] i;
    reg                     flag;
    //reg                     r_en_delay_1, r_en_delay_2;

    always @(posedge r_clk or posedge r_rst) begin // read_addr pointer add 1 atumatically
        if(r_rst)
            read_addr_bin <= 0;
        else if(r_en && (!flag_empty))
            read_addr_bin <= read_addr_bin + 1'b1;
        else
            read_addr_bin <= read_addr_bin;
    end
    
    assign read_addr_gray = (read_addr_bin>>1) ^ read_addr_bin;                // binary to gray
    assign flag_empty     = (read_addr_gray == write_addr_gray_sync);  // produce flag_empty signal
    assign read_addr      = read_addr_bin[FIFO_DEPTH_BIT-1:0];         //assign write_addr, cut 1 bit of read_addr_bin

endmodule
