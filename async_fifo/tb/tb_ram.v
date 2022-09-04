module tb_ram ();

    parameter FIFO_WIDTH       = 10'd8;
    parameter FIFO_WIDTH_BIT   = 10'd3;
    parameter FIFO_DEPTH       = 10'd16;
    parameter FIFO_DEPTH_BIT   = 10'd4;

    reg                      w_clk, r_clk;
    reg                      w_rst, r_rst;
    reg                      w_en , r_en ;   
    reg [FIFO_WIDTH-1:0]     data_write, data_read;

    reg [FIFO_DEPTH_BIT-1:0] write_addr, read_addr;
    reg                      flag_empty, flag_full;

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
        w_en = 0;
        r_en = 0;       
        #100
        w_en = 1;
        write_addr = 0;
        flag_full  = 0;
        flag_empty = 0;
        data_write = 100;
        for(j=0; j<=15; j=j+1) begin
            #40 write_addr = write_addr + 1;
                data_write = {$random} %256; //generate random numbers(0-255)
                //data_write = data_write + 5;

        end  
        flag_full = 1; 
        w_en =0; 
        #40
        r_en = 1;
        read_addr  = 0;
        for(k=0; k<=15; k=k+1) begin
            flag_full = 0;
            #40 read_addr = read_addr + 1;
        end 
        flag_empty = 1;
        r_en = 0;
        #100 ;
    end


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

    initial begin
        $vcdpluson;
    end


endmodule
