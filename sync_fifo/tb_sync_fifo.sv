
class random;
    rand bit [7:0] data_in;
    constraint range {data_in inside {[0:255]}; };
endclass


module tb_sync_fifo();
        
    reg        clk;
    reg        rst;
    reg        w_en;
    reg        r_en;
    reg [7:0]  data_write;
    wire       flag_full;
    wire       flag_empty;
    reg [7:0]  data_read;

    initial begin
        rst         = 0;
        #20 rst     = 1;
        #40 rst     = 0;
    end
    
    initial begin
        clk = 0;
        for(int i=0; i<=200 ;i++)
            #20 clk = ~clk;
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


   sync_fifo inst_sync_fifo (
        .clk        (clk),
        .rst        (rst),
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
