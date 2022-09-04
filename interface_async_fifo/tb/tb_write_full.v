module tb_write_full ();

    reg        w_en;
    reg        w_clk;
    reg        w_rst;
    reg  [4:0] read_addr_gray_sync, temp, write_addr_gray;

    wire [3:0] write_addr;
    wire       flag_full;

    integer i;

    initial begin
        w_clk     = 0;
        w_rst     = 0;
        #20 w_rst = 1;
        #40 w_rst = 0;
    end

    initial begin
        for(i=0; i<=100; i=i+1)
            #20 w_clk = ~w_clk;
    end

    initial begin
        w_en                = 0;
        #60 
        w_en                = 1;
        temp                = 3;
        read_addr_gray_sync = 0;
        if(w_en) begin
            for (i = 0; i <=100; i=i+1) begin
                temp                = temp + 1;
                read_addr_gray_sync = (temp>>1) ^ temp;
                #45 ;
            end
        end
        else ;
    end

	write_full #(
			.FIFO_DEPTH_BIT      (10'd4)
		) inst_write_full (
			.w_clk               (w_clk),
			.w_rst               (w_rst),
			.w_en                (w_en),
			.read_addr_gray_sync (read_addr_gray_sync),

			.flag_full           (flag_full),
			.write_addr          (write_addr),
			.write_addr_gray     (write_addr_gray)
		);


    initial begin
        $vcdpluson;
    end


endmodule
