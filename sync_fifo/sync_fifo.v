module sync_fifo 
    #(
        parameter FIFO_WIDTH       = 10'd8,
        parameter FIFO_WIDTH_BIT   = 10'd3,
        parameter FIFO_DEPTH       = 10'd16,
        parameter FIFO_DEPTH_BIT   = 10'd4
    )
    (
        input                           clk,
        input                           rst,
        input                           w_en,
        input                           r_en,
        input [FIFO_WIDTH-1:0]          data_write,

        output                          flag_full,
        output                          flag_empty,
        output reg [FIFO_WIDTH-1:0]     data_read
    );
    
    reg [9:0]                   count; //counting fifo's space
    reg [FIFO_DEPTH_BIT:0]      index;
    reg [FIFO_DEPTH_BIT-1:0]    write_addr; //memory's wirting address
    reg [FIFO_DEPTH_BIT-1:0]    read_addr; //memory's reading address
    reg [FIFO_WIDTH-1:0]        memory [FIFO_DEPTH-1:0]; //the memory space of fifo

    always @(posedge clk or posedge rst) begin //initiating and writing data
        if (rst) begin
            write_addr <= 0;
            for(index=0; index<=FIFO_DEPTH-1; index=index+1'b1)
                memory[index] = 0; //initiate memory to 0
        end

        else if (w_en && (!flag_full)) begin
            memory[write_addr] <= data_write;
            write_addr         <= write_addr + 1'b1;
        end

        else ;
    end

    always @(posedge clk or posedge rst) begin // reading data
        if (rst) begin
            read_addr  <= 0;
        end

        else if (r_en && (!flag_empty)) begin
            data_read  <= memory[read_addr];
            read_addr <= read_addr + 1'b1;
        end

        else ;
    end
   
    always @(posedge clk or posedge rst) begin //
        if(rst) 
            count <= 0;
        else if( (w_en && (!flag_full)) &&  !(r_en && (!flag_empty)) )
            count <= count + 1'b1;
        else if( (r_en && (!flag_empty)) &&  !(w_en && (!flag_full)) ) 
            count <= count - 1'b1;
        else
            count <= count;
    end

    assign flag_empty = (count==0);
    assign flag_full  = (count==(FIFO_DEPTH));

endmodule
