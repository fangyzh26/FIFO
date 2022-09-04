module tb_sync_addr_gray ();

    parameter FIFO_WIDTH       = 10'd8;
    parameter FIFO_WIDTH_BIT   = 10'd3;
    parameter FIFO_DEPTH       = 10'd16;
    parameter FIFO_DEPTH_BIT   = 10'd4;

    reg                       w_clk, r_clk;
    reg                       w_rst, r_rst;
    reg [FIFO_DEPTH_BIT:0]    write_addr_gray, read_addr_gray;
    wire [FIFO_DEPTH_BIT:0]   write_addr_gray_sync, read_addr_gray_sync;

    integer i,j,k;

    initial begin    //initiate write or read clk and rst
        w_clk     = 0;
        w_rst     = 0;
        r_clk     = 0;
        r_rst     = 0;
        #20 r_rst = 1; w_rst = 1;
        #40 r_rst = 0; w_rst = 0;
    end
     
    initial begin   //set w_clk and r_clk
        for(i=0; i<=100; i=i+1) begin
            #20 w_clk = ~w_clk;
                r_clk = ~r_clk;
        end
    end

    initial begin  //after 100ns, begin loading write_add 
        write_addr_gray = 0;
        #100
        for(j=0; j<=15 ; j=j+1) begin
            #40 write_addr_gray = write_addr_gray + 1;
        end
        #40
        read_addr_gray = 0;
        for(k=0; k<=15 ; k=k+1) begin
            #40 read_addr_gray = read_addr_gray + 1;
        end
    end

	sync_addr_gray #(
			.FIFO_DEPTH_BIT       (FIFO_DEPTH_BIT)
		) inst_sync_addr_gray (
			.w_clk                (w_clk),
			.r_clk                (r_clk),
			.w_rst                (w_rst),
			.r_rst                (r_rst),
			.write_addr_gray      (write_addr_gray),
			.read_addr_gray       (read_addr_gray),

			.write_addr_gray_sync (write_addr_gray_sync),
			.read_addr_gray_sync  (read_addr_gray_sync)
		);

    initial begin
        $vcdpluson;
    end


endmodule
