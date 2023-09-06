package opcodes;

    parameter NOP = 8'h00;
    parameter HLT = 8'hFF;
    
endpackage

package cpu_params;

    parameter page_size = 4096; 
    parameter large_page_size = 2079152;
    parameter bit_count = 32;
    parameter ram_address_width = bit_count;
    
endpackage