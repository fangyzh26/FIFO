module tb_read_empty ();

    reg        r_en;
    reg        r_clk;
    reg        r_rst;
    reg  [4:0] write_addr_gray_sync, temp, read_addr_gray;

    wire [3:0] read_addr;
    wire       flag_empty;

    integer i;

    initial begin
        r_clk     = 0;
        r_rst     = 0;
        #20 r_rst = 1;
        #40 r_rst = 0;
    end

    initial begin
        for(i=0; i<=150; i=i+1)
            #20 r_clk = ~r_clk;
    end

    initial begin
        r_en                = 0;
        #60 
        r_en                = 1;
        temp                = 3;
        write_addr_gray_sync = 0;
        if(r_en) begin
            for (i = 0; i <=120; i=i+1) begin
                temp                 = temp + 1;
                write_addr_gray_sync = (temp>>1) ^ temp;
                #45 ;
            end
        end
        else ;
    end

    read_empty #(
            .FIFO_DEPTH_BIT       (10'd4)
        ) inst_read_empty (
            .r_clk                (r_clk),
            .r_rst                (r_rst),
            .r_en                 (r_en),
            .write_addr_gray_sync (write_addr_gray_sync),

            .flag_empty           (flag_empty),
            .read_addr            (read_addr),
            .read_addr_gray       (read_addr_gray)
        );


    initial begin
        $vcdpluson;
    end


endmodule
