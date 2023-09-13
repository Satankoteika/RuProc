enum bit[3:0] {
    SET_BY_COMMON_REG,
    SET_BY_CACHE
    ADD,
    SUB,
    MUL,
    DIV,
    SHL,
    SHR,
    ROL,
    ROR,
    NOT,
    AND,
    OR,
    XOR //14 operations
} ALU_OPERATION;
module ADDSUB_LAY #(
    parameter bit_width = 32
) (
    input wire                  IN_C,       //CARRY-FLAG IN
    input wire                  IN_OP,      //OPERATION (ADD or SUB)
    input wire[bit_width - 1:0] IN_A,       //OPERANDS A
    input wire[bit_width - 1:0] IN_B,       //OPERAND B
    output reg                  OUT_C,      //CARRY-FLAG OUT
    output reg[bit_width - 1:0] OUT_R,      //RESULT
    output reg[31:0]            OUT_FLAG    //FLAG OUT
);
wire[bit_width:0] circuit;
always @* begin
    //OPERATION: TRUE - SUB, FALSE - ADD
    assign circuit = IN_A + (IN_OP ? !IN_B : IN_B) + IN_C;
    OUT_C <= circuit[bit_width];
    OUT_R <= IN_OP ? !(circuit[bit_width - 1:0]) : circuit[bit_width - 1:0];
end
endmodule
module ADDSUB #(//todo
    parameter bit_width = 32
) (
    input wire[bit_width - 1:0] IN_A[2:0],  //OPERANDS A (3 inputs, [2:1] for superscalar ADD and SUB)
    input wire[bit_width - 1:0] IN_B,       //OPERAND B
    output reg[bit_width - 1:0] OUT_R       //RESULT
    //ports(todo)
);
genvar i;
generate
    for (i = 0; i < bit_width; i++) begin
        ADDSUB_LAY #(.bit_width(bit_width)) lay();
    end
endgenerate
endmodule
module ALU #(
    parameter bit_width = 32
) (
    input wire[3:0]             IN_OP,      //OPERATION
    input wire[bit_width - 1:0] IN_A[2:0],  //OPERANDS A (3 inputs, [2:1] for superscalar ADD and SUB)
    input wire[bit_width - 1:0] IN_B,       //OPERAND B
    input wire[bit_width - 1:0] IN_CASH,    //DATA FROM CASH
    input wire[31:0]            IN_FLAG,    //FLAG IN
    output reg[bit_width - 1:0] OUT_R,      //RESULT
    output reg[31:0]            OUT_FLAG    //FLAG OUT
);
always @* begin
    case (IN_OP)
        SET_BY_COMMON_REG:  OUT_R <= IN_A[0];
        SET_BY_CASH:        OUT_R <= IN_CASH;
        ADD:                OUT_R <= IN_A[0] + IN_B;//todo - need matrix for MUL
        SUB:                OUT_R <= IN_A[0] - IN_B;//todo - need matrix for DIV
        SHL:                OUT_R <= IN_A[0] >> IN_B;
        SHR:                OUT_R <= IN_A[0] << IN_B;
        ROL:                OUT_R <= {IN_A[0][0], IN_A[0][bit_width - 1:1]}; //todo (left 1 shift?)
        ROR:                OUT_R <= {IN_A[0][bit_width - 2:0], IN_A[0][bit_width - 1]}; //todo (left 1 shift?)
        NOT:                OUT_R <= !IN_A[0];
        AND:                OUT_R <= IN_A[0] & IN_B;
        OR:                 OUT_R <= IN_A[0] | IN_B;
        XOR:                OUT_R <= IN_A[0] ^ IN_B;
    endcase
end
endmodule