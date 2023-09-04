interface CacheReadWrite (
    input wire[adress_width-1:0] address,
    input wire write,
    input wire read,
    output reg[7:0] out_value
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

endmodule