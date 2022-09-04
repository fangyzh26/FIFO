module top_async_fifo (
    input        w_clk,r_clk,
    input        w_rst,r_rst,
    input        w_en,r_en,
    input [7:0]  data_write,
    
    output       flag_full,
    output       flag_empty,
    output [7:0] data_read
    );
    
    parameter FIFO_WIDTH       = 10'd8;
    parameter FIFO_WIDTH_BIT   = 10'd3;
    parameter FIFO_DEPTH       = 10'd16;
    parameter FIFO_DEPTH_BIT   = 10'd4;


    wire [FIFO_DEPTH_BIT-1:0] write_addr,read_addr;
    wire [FIFO_DEPTH_BIT:0]   write_addr_gray,read_addr_gray;
    wire [FIFO_DEPTH_BIT:0]   write_addr_gray_sync,read_addr_gray_sync;
	
    ram #(
        .FIFO_WIDTH     (FIFO_WIDTH),
        .FIFO_WIDTH_BIT (FIFO_WIDTH_BIT),
        .FIFO_DEPTH     (FIFO_DEPTH),
        .FIFO_DEPTH_BIT (FIFO_DEPTH_BIT)
    ) inst_ram (
        .w_clk      (w_clk),//input
        .r_clk      (r_clk),
        .w_rst      (w_rst),
        .r_rst      (r_rst),
        .w_en       (w_en),
        .r_en       (r_en),
        .flag_full  (flag_full),
        .flag_empty (flag_empty),
        .write_addr (write_addr),
        .read_addr  (read_addr),
        .data_write (data_write),

        .data_read  (data_read)//output
    );

    write_full #(
        .FIFO_DEPTH_BIT (FIFO_DEPTH_BIT)
    ) inst_write_full (
        .w_clk               (w_clk),//input
        .w_rst               (w_rst),
        .w_en                (w_en),
        .read_addr_gray_sync (read_addr_gray_sync),
        .write_addr_gray     (write_addr_gray),

        .write_addr          (write_addr),//output
        .flag_full           (flag_full)

    );

    read_empty #(
        .FIFO_DEPTH_BIT (FIFO_DEPTH_BIT)
    ) inst_read_empty (
        .r_clk                (r_clk),//input
        .r_rst                (r_rst),
        .r_en                 (r_en),
        .write_addr_gray_sync (write_addr_gray_sync),
        .read_addr_gray       (read_addr_gray),

        .read_addr            (read_addr),//output
        .flag_empty           (flag_empty)
    );

    sync_addr_gray #(
        .FIFO_DEPTH_BIT (FIFO_DEPTH_BIT)
    ) inst_sync_addr_gray (
        .w_clk                (w_clk),//input
        .r_clk                (r_clk),
        .w_rst                (w_rst),
        .r_rst                (r_rst),
        .write_addr_gray      (write_addr_gray),
        .read_addr_gray       (read_addr_gray),

        .write_addr_gray_sync (write_addr_gray_sync),//output
        .read_addr_gray_sync  (read_addr_gray_sync)
    );

endmodule
