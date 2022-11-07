module sync_addr_gray 
    #(
       parameter FIFO_DEPTH_BIT = 10'd4
    )
    (
        input                         w_clk,r_clk,
        input                         w_rst,r_rst,
        input [FIFO_DEPTH_BIT:0]      write_addr_gray,
        input [FIFO_DEPTH_BIT:0]      read_addr_gray,
        
        output reg [FIFO_DEPTH_BIT:0] write_addr_gray_sync,
        output reg [FIFO_DEPTH_BIT:0] read_addr_gray_sync
    );

    reg [FIFO_DEPTH_BIT:0] write_addr_gray_sync_temp1,write_addr_gray_sync_temp2;
    reg [FIFO_DEPTH_BIT:0] read_addr_gray_sync_temp1, read_addr_gray_sync_temp2; 
    
    always @(posedge r_clk or posedge r_rst) begin//write_addr_gary delay 2 clks 
        write_addr_gray_sync_temp1 <= write_addr_gray;
        write_addr_gray_sync_temp2 <= write_addr_gray_sync_temp1;
        write_addr_gray_sync       <= write_addr_gray_sync_temp2;
    end

     always @(posedge w_clk or posedge w_rst) begin//write_addr_gary delay 2 clks 
        read_addr_gray_sync_temp1 <= read_addr_gray;
        read_addr_gray_sync_temp2 <= read_addr_gray_sync_temp1;
        read_addr_gray_sync       <= read_addr_gray_sync_temp2;
    end

endmodule
