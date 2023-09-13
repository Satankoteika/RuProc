module moduleName #(
    parameter bit_width = 32
) (
    input wire clk
);
//template
reg[bit_width - 1:0]    registers[33:0];    //COMMON(23:0) & SHARED(31:24) & FLAG(32:32) & ADDRESS(33:33) REGISTERS
/*
* REGISTER DESC:
* common registers can be accessed only by core
* shared registers can be accessed by core and soprocessor
* flag register can be accessed only by core
*/
ALU #(.bit_depth(bit_width)) alu(OP_TODO, IN_A4_TODO, IN_B_TODO, IN_CASH_TODO, registers[32], OUT_R_TODO, registers[32]);
endmodule