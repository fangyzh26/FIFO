module ram
    #(    
        parameter DATAIN_WIDTH   = 10'd16, //input data's width, must equel to RAM's width
        parameter DATAOUT_WIDTH  = 10'd32, //output data's width
        parameter FIFO_WIDTH     = 10'd8,
        parameter FIFO_WIDTH_BIT = 10'd3,
        parameter FIFO_DEPTH     = 10'd16,
        parameter FIFO_DEPTH_BIT = 10'd4
    )
    (
        input                           w_clk,r_clk,
        input                           w_rst,r_rst,
        input                           w_en ,r_en,
        input                           flag_full,flag_empty,
        input [FIFO_DEPTH_BIT-1:0]      write_addr,
        input [FIFO_DEPTH_BIT-1:0]      read_addr,
        input [DATAIN_WIDTH-1:0]        data_write,

        output reg [DATAOUT_WIDTH-1:0]  data_read
    );
    
    parameter MUL_FACTOR = DATAOUT_WIDTH/DATAIN_WIDTH; //multi factor
    parameter DIV_FACTOR = DATAIN_WIDTH/DATAOUT_WIDTH; //div factor 

    reg [FIFO_WIDTH-1:0]      memory [FIFO_DEPTH-1:0];//define RAM
    reg [DATAIN_WIDTH-1:0]    data_read_temp;
    reg [FIFO_DEPTH_BIT:0]    index,i,count,count_delay;

    always @(posedge w_clk or posedge w_rst) begin
        if(w_rst) //initiate RAM 
            for(index=0 ; index<=FIFO_DEPTH-1 ;index=index+1)
                memory[index] <= 0;
        else if(w_en && (!flag_full))
            	memory[write_addr] <= data_write; //write data
        else ;
    end

    always @(posedge r_clk or posedge r_rst) begin
        if(r_rst)
            count <= 0;
        else if (r_en && (!flag_empty ))
            if((MUL_FACTOR==5'd2) && (!DIV_FACTOR))
                data_read <= {memory[read_addr+1],memory[read_addr]}; //inputdata is 2times bigger than output
            //else if((MUL_FACTOR==5'd4))
                //data_read <= {memory[read_addr+3],memory[read_addr+2],memory[read_addr+1],memory[read_addr]};//inputdata is 4times bigger than output
            else if((DIV_FACTOR==5'd2) && (!MUL_FACTOR)) begin
                data_read_temp <= memory[read_addr];
                if(count==0) 
                    data_read <= data_read_temp[(DATAIN_WIDTH-1):(DATAIN_WIDTH/2)];
                else 
                    data_read <= data_read_temp[(DATAIN_WIDTH/2-1):0];
                count <= (count==DIV_FACTOR-1) ? 0 : count+1;
            end

                //data_read <= memory[DATAIN_WIDTH_BIT-1:0];
                
            else
                data_read <= memory[read_addr]; //read data
        else ;   
    end

     always @(posedge r_clk or posedge r_rst) begin
        if(r_rst)
            count_delay <= 0;
        else if(flag_empty && !DIV_FACTOR) begin
            if(count_delay==1)
                data_read   <= data_read_temp[(DATAIN_WIDTH/2-1):0];
            else
                data_read   <= data_read;
            count_delay <= (count_delay>1) ? count_delay: count_delay+1;
        end

        else ;    
            
     end


endmodule
