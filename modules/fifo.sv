module FIFO #(
    parameter width = 8, depth = 8
) (
    input wire clk,
    input wire reset,

    input wire read,
    input wire write,

    output wire empty,
    output wire full,

    input wire[width-1:0] data_in,
    output reg[width-1:0] data_out
);

    integer index;

    reg[width-1:0] memory[0:depth];
    reg[$clog2(depth)-1:0] read_ptr, write_ptr;
    wire[width-1:0] aboba;
    
    assign full = (read_ptr - write_ptr == 1 || (read_ptr == 0 && write_ptr == depth-1)) ? 1 : 0;
    assign empty = (write_ptr == read_ptr) ? 1 : 0;
    assign aboba = memory[write_ptr];

    always @(posedge clk) begin
        if (reset)
        begin
            for(index = 0; index < depth; index++) begin 
                memory[index] <= 0;
            end
            data_out <= 0; write_ptr <= 0; read_ptr <= 0;
        end
        else begin
            if (write & !full) begin
               memory[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                $display("WRITTEN!, %t", $time);
            end
            if (read & !empty) begin
                data_out <= memory[read_ptr];
                read_ptr <= read_ptr + 1;
            end
        end
    end

    initial begin
		$monitor("Time %t | Result: %h",$time, aboba);
	end

endmodule

