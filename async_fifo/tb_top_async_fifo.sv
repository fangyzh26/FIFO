
class random;
    rand bit [7:0] data_in;
    constraint range {data_in inside {[0:255]}; };
endclass


module tb_top_async_fifo();
        
    reg        w_clk, r_clk;
    reg        w_rst, r_rst;
    reg        w_en , r_en;
 
    reg [7:0]  data_write, data_read ;
    wire       flag_full, flag_empty;


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
        for(int i=0; i<=200 ;i++)
            #20 w_clk = ~w_clk;
    end

    initial begin
        r_clk = 0;
        for(int i=0; i<=200 ;i++)
            #19 r_clk = ~r_clk;
    end

    initial begin
        random data_in = new();
        w_en        = 0;
        r_en        = 0;
        #240 w_en    = 1;

        for(int i=1; i<=20 ;i++) begin
             data_write = i;
             #40;
        end 
        w_en   = 0; 

        #40 r_en  = 1;     
        
        #800 r_en  = 0;

        #40 w_en  = 1;

        for(int i=17; i<=47 ;i++) begin
             if(i>=27) 
                r_en = 1;///********
             else 
                r_en  = 0;
             //data_in.randomize();
             //data_write = data_in.data_in;
             data_write = i;
             #40;
        end
        w_en = 0;

        #700
        r_en = 0;

        #100;


    end

     top_async_fifo inst_top_async_fifo(
        .w_clk          (w_clk),//input
        .w_rst          (w_rst),
        .r_clk          (r_clk),
        .r_rst          (r_rst),
        .r_en           (r_en),
        .w_en           (w_en),
        .data_write     (data_write),

        .flag_full      (flag_full),//output
        .flag_empty     (flag_empty),
        .data_read      (data_read)
        );
    
    initial 
        $vcdpluson();

endmodule
