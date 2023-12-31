`include "constants.sv"
import cpu_params::*;

/* module TLB #(
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
            last_ptr <= 0;
            state <= TLB_COMPARE;
        end
        else begin
            case(state)
                TLB_COMPARE: begin 
                    if(enable) begin 
                        fault <= 1;
                        state <= TLB_FAULT;
                        for(i = 0; i < $clog2(size); i++) begin
                            if(page_map[i][(2*page_adress_width)-1:page_adress_width] == compare_input[bit_count-1:$clog2(page_size)]) begin
                                compare_output[bit_count-1:$clog2(page_size)] <= page_map[i][(2*page_adress_width)-1:page_adress_width];
                                compare_output[$clog2(page_size)-1:0] <= compare_input[$clog2(page_size)-1:0];
                                fault <= 0;
                                state <= TLB_COMPARE;
                            end                                
                        end
                    end
                end
                TLB_FAULT: begin 
                    if(unfault) begin 
                        page_map[last_ptr][(2*page_adress_width)-1:page_adress_width] <= compare_input[bit_count-1:$clog2(page_size)];
                        page_map[last_ptr][page_adress_width-1:0] <= fault_input[bit_count-1:$clog2(page_size)];
                        state <= TLB_COMPARE;
                        last_ptr <= last_ptr + 1;
                    end
                end
            endcase
        end
    end

endmodule */

module TLB #(
    parameter size_bits, associativity_bits = size_bits, port_count = 1,
    localparam size = 2**size_bits, associativity = 2**associativity_bits,
    localparam page_adress_width = ram_address_width - page_offset_bits, set_count = size/associativity
) (
    input wire clk,
    input wire rst,
    input wire write_enable,
    input wire read_enable,
    input wire[page_adress_width-1:0] key_address_write,
    input wire[page_adress_width-1:0] value_address_write,
    input wire[page_adress_width-1:0] key_address_read[0:port_count-1],
    output reg[page_adress_width-1:0] output_address[0:port_count-1]
);

    integer i, j;

    reg[page_adress_width-1:0] key_address[0:set_count-1][0:associativity-1];
    reg[page_adress_width-1:0] value_address[0:set_count-1][0:associativity-1];

    reg[$clog2(set_count)-1:0] last_index[0:set_count-1];

    always @(posedge clk) begin 
        if(rst) begin 
            for(i = 0; i < set_count; i++) begin 
                for(j = 0; j < associativity; j++) begin 
                    key_address[i][j] <= 0;
                end
            end
            for(i = 0; i < set_count; i++) begin 
                last_index[i] <= 0;
            end         
        end
        else if(write_enable) begin
            key_address[key_address_write[$clog2(set_count)-1:0]][last_index[key_address_write[$clog2(set_count)-1:0]]] <= key_address_write;
            value_address[key_address_write[$clog2(set_count)-1:0]][last_index[key_address_write[$clog2(set_count)-1:0]]] <= value_address_write;
            last_index[key_address_write[$clog2(set_count)-1:0]] <= last_index[key_address_write[$clog2(set_count)-1:0]] + 1;
        end
        else if(read_enable) begin
            for(i = 0; i < port_count; i++) begin
                for(j = 0; j < associativity; j++) begin
                    if(key_address[key_address_read[i][$clog2(set_count)-1:0]][j] == key_address_read[i]) begin 
                        output_address[i] <= value_address[key_address_read[i][$clog2(set_count)-1:0]][j];
                    end
                end
            end
        end
    end

    initial begin 
        $monitor("%h %h %h %h %h %h\n", key_address[0][0], key_address[1][0], key_address[0][1], key_address[1][1], output_address[0], output_address[1]);
    end

endmodule

module TLB_TB;

    reg clk;
  	reg rst;
    reg write_enable;
    reg read_enable;
    reg[ram_address_width - page_offset_bits] key_address;
    reg[ram_address_width - page_offset_bits] value_address;
    reg[ram_address_width - page_offset_bits] key_address_read[2];
    reg[ram_address_width - page_offset_bits] output_address[2];

    TLB #(.size_bits(2), .associativity_bits(1), .port_count(2)) tlb(clk, rst, write_enable, read_enable, key_address, value_address, key_address_read, output_address);
    
    initial begin
        clk = 0; 
    	rst = 1; 
        write_enable = 0;
        key_address = 20'hFFFFF;
        value_address = 20'hAABB0;
        clk = 1; #1 ; clk = 0; #1;
    	rst = 0;

        write_enable = 1;
        clk = 1; #1 ; clk = 0; #1;
        key_address = 20'h01010;
        value_address = 20'hAABA0;
        clk = 1; #1 ; clk = 0; #1;
        key_address = 20'h01110;
        value_address = 20'hAABF0;
        clk = 1; #1 ; clk = 0; #1;
        key_address_read[0] = 20'h01110;
        key_address_read[1] = 20'h01010;
        write_enable = 0;
        read_enable = 1;
        clk = 1; #1 ; clk = 0; #1;
    end
    /* reg clk;
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
        ci = 32'hFFFFF00A;
        clk = 1; #1 ; clk = 0; #1;
    	rst = 0;

        enable = 1;
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", fault);
        clk = 1; #1 ; clk = 0; #1;
        fi = 32'h10000000;
        unfault = 1;
        clk = 1; #1 ; clk = 0; #1;
        ci = 32'hFFFFF00B;
        clk = 1; #1 ; clk = 0; #1;
        $display("%h", co);
    end */

endmodule

/* interface CacheTLB #(
    parameter width, address_width
) (
    input wire fault_tlb,
    input wire[bit_count-1:0] physical_adress_tlb,
    output reg enable_tlb,
    output reg[bit_count-1:0] compare_tlb
);
endinterface

interface CacheRead #(
    parameter width, address_width
) (
    input wire enable,
    input wire[address_width-1:0] address,
    output reg[width-1:0] read_value
);
endinterface

interface CacheWrite #(
    parameter width, address_width
) (
    input wire enable,
    input wire[width-1:0] read_value,
    output reg[address_width-1:0] address
);
endinterface */

/* module CacheL1 #(
    parameter size = 65536, cache_line = 32, way_count = 4,
    localparam sets = size/(cache_line*way_count)  
) (
    input wire clk,
    CacheRead out,
    CacheWrite in,
    CacheTLB tlb
);
    
    integer i;

    reg state;
    parameter CACHE_ACCESS = 1'b0;
    parameter CACHE_TLB_FETCH = 1'b1;

    reg[$clog2(sets)+$clog2(way_count)+cache_line*8-1:0] memory[0:sets-1][0:way_count-1];

    always @(posedge clk) begin 
        case(state)
            CACHE_ACCESS: begin 
                for(i = 0; i < out.count; i++) begin 
                    if(out.enable) begin 
                        tlb.compare_tlb <= out.address;
                        tlb.enable <= 1;
                    end
                end
            end
            CACHE_TLB_FETCH: begin 
                tlb.enable <= 0;
                for(i = 0; i < way_count) begin 
                    if(memory[out.address[$clog2(cache_line*sets)-1:$clog2(cache_line)]][i][out.address[out.adress_width-1:$clog2(cache_line*sets)]])
                end
            end
        endcase
    end

endmodule */

/* module Cache #(
    parameter size = 1024, cache_line = 4, way_count = 2,
    localparam sets = size/(cache_line*way_count)  
) (
    input wire clk,
    input wire rst,
    input wire[adress_width-1:0] address,
    input wire write,
    input wire read,
    output reg[7:0] out_value
);

    reg[7:0] memory[0:size-1];
    
    always @(posedge clk) begin 

        //if(write && !read)

    end

endmodule */