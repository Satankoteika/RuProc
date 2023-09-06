`include "modules/constants.sv"
import cpu_params::*;

module TLB #(
    parameter size,
    localparam page_adress_width = ram_address_width - $clog2(page_size)
) (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire unfault,
    input wire[bit_count-1:0] compare_input,
    input wire[bit_count-1:0] fault_input,
    output reg[bit_count-1:0] compare_output,
    output reg fault
);   

    integer i;

    reg state;

    reg[(2*page_adress_width)-1:0] page_map[size-1:0];
    reg[$clog2(size)-1:0] out_ptr;
    reg[$clog2(size)-1:0] last_ptr;

    parameter TLB_COMPARE = 1'b0;
    parameter TLB_FAULT = 1'b1;

    always @(posedge clk) begin 
        if(rst) begin
            for(i = 0; i < size; i++)
                page_map[i] <= 0;
            page_map[0] <= 40'hFFFFF00000;
            last_ptr <= 0;
            state <= TLB_COMPARE;
        end
        else begin
            case(state)
                TLB_COMPARE: begin 
                    if(enable) begin 
                        for(i = 0; i < $clog2(size); i++) begin
                            if(page_map[i][(2*page_adress_width)-1:page_adress_width] == compare_input[bit_count-1:$clog2(page_size)]) begin
                                compare_output[bit_count-1:$clog2(page_size)] <= page_map[i][(2*page_adress_width)-1:page_adress_width];
                                compare_output[$clog2(page_size):0] <= compare_input[$clog2(page_size):0];
                            end                                
                        end
                    end
                end
            endcase
        end
    end

endmodule

module TLB_TB;

    reg clk;
  	reg rst;
    reg enable;
    reg unfault;
    reg[31:0] ci;
    reg[31:0] fi;
    reg[31:0] co;
    reg fault;

    TLB #(.size(4)) tlb(clk, rst, enable, unfault, ci, fi, co, fault);

    initial begin
        clk = 0; 
    	rst = 1; 
        enable = 0;
        ci = 32'hFFFFF000;
        clk = 1; #1 ; clk = 0; #1;
    	rst = 0;

        enable = 1;
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", co);
    end

endmodule

/*interface CacheRead #(
    parameter width, address_width, count
) (
    input wire[address_width-1:0] address[0:count-1],
    output reg[width-1:0] read_value[0:count-1]
)
endinterface

interface CacheFetchVirtual #(
    parameter address_width
) (
    input wire[address_width-1:0] address,
)
endinterface

interface CacheInterface #(

    

) (

)
endinterface

module Cache #(
    parameter size = 1024, cache_line = 4, way_count = 2,
    localparam sets = size/(cache_line*way_count),  
) (
    input wire clk;
    input wire[adress_width-1:0] address,
    input wire write,
    input wire read,
    output reg[7:0] out_value
)

    reg[7:0] memory[0:size-1];
    
    always @(posedge clk) begin 

        if(write && !read)

    end

endmodule*/