
class random;
    rand bit [15:0] data_in;
    constraint range {data_in inside {[0:65535]}; };
endclass


module tb_top_async_fifo();

    parameter DATAIN_WIDTH     = 10'd8; //input data's width, must equel to RAM's width
    parameter DATAOUT_WIDTH    = 10'd16;  //output data's width
    localparam FIFO_WIDTH     = DATAIN_WIDTH; //define the width of RAM, must equel to input data's width
    localparam FIFO_DEPTH     = 8*DATAIN_WIDTH; //define the depth of RAM
    localparam FIFO_WIDTH_BIT = $clog2(FIFO_WIDTH);//get bits of RAM's width, though function clog2
    localparam FIFO_DEPTH_BIT = $clog2(FIFO_DEPTH);//get bits of RAM's depth

    reg        w_clk, r_clk;
    reg        w_rst, r_rst;
    reg        w_en , r_en;
 
    reg [DATAIN_WIDTH-1:0]   data_write;
    reg [DATAOUT_WIDTH-1:0]  data_read ;
    wire                     flag_full, flag_empty;


    initial begin
        w_rst         = 0;
        r_rst         = 0;
        #20 w_rst     = 1;
            r_rst     = 1;

        #40 w_rst     = 0;
            r_rst     = 0;
    end
    
    initial begin
        w_clk = 0;
        for(int i=0; i<=300 ;i++)
            #20 w_clk = ~w_clk;
    end

    initial begin
        r_clk = 0;
        for(int i=0; i<=300 ;i++)
            #19 r_clk = ~r_clk;
    end

    initial begin
        random data_in = new();
        w_en        = 0;
        r_en        = 0;
        #220 w_en    = 1;

        for(int i=1; i<=20 ;i++) begin
            data_in.randomize();
            //data_write = data_in.data_in;
            data_write = i;
            #40;
        end 
        w_en   = 0; 

        #40 r_en  = 1;     
        
        #800 r_en  = 0;

        #40 w_en  = 1;

        for(int i=17; i<=56 ;i++) begin
             if(i>=50) 
                r_en = 1;///********
             else 
                r_en  = 0;
             data_in.randomize();
             //data_write = data_in.data_in;
             data_write = i;
             #40;
        end
        w_en = 0;

        #1500
        r_en = 0;

        #100;


    end

	top_async_fifo #(
        .DATAIN_WIDTH   (DATAIN_WIDTH),
        .DATAOUT_WIDTH  (DATAOUT_WIDTH)
		) inst_top_async_fifo (
			.w_clk      (w_clk),
			.r_clk      (r_clk),
			.w_rst      (w_rst),
			.r_rst      (r_rst),
			.w_en       (w_en),
			.r_en       (r_en),
			.data_write (data_write),
			.flag_full  (flag_full),
			.flag_empty (flag_empty),
			.data_read  (data_read)
		);

    
    initial 
        $vcdpluson();

endmodule
