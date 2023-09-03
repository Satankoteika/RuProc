import opcodes::*;

module InstructionMMU #(
	parameter depth = 8, address_size = 32, width = 32, memsize = 32
) (
	input wire clk,
	input wire rst,
	input wire next,
	input wire stop,
	output reg[width-1:0] instruction
);

	reg [1:0] state = P_IDLE;
	reg[address_size-1:0] pc = 0;
	reg[7:0] memory[0:memsize-1];

	reg[$clog2(width):0] fetchingIndex = 0;
	reg[width-1:0] fetchingInstruction = 0;

	reg read;
	reg write;

	reg empty;
	reg full;

	FIFO #(.width(width), .depth(depth)) fifo(clk, rst, read, write, empty, full, fetchingInstruction, instruction);

	parameter P_IDLE = 2'b00;
	parameter P_FETCH = 2'b01;
	parameter P_PUSH = 2'b10;

	always @(posedge clk) begin

		case (state)
  			P_IDLE: begin
    			if (stop == 0 && full == 0) state <= P_FETCH;
  			end
      		P_FETCH: begin
	    		fetchingInstruction[width-8-fetchingIndex +:8] <= memory[pc];
    			fetchingIndex <= fetchingIndex + 8;
				if(fetchingIndex == width) begin 
					write <= 1;
					state <= P_PUSH;	
				end
				else
					pc <= pc + 1;
  			end
  			P_PUSH: begin
				write <= 0;
				fetchingInstruction <= 0;
				fetchingIndex <= 0;
				if (full == 0)
					state <= P_FETCH;
				else
        			state <= P_IDLE;
  			end
		endcase

		if(next == 1)
			read <= 1;
		else 
			read <= 0;

	end

	initial begin
		//$monitor("Time %t | fetching: %h | write: %h",$time, fetchingInstruction, write);
		$readmemh("output.bin", memory);
	end

endmodule
