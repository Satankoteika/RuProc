enum bit[3:0] {
    ADD,
    SUB,
    SHL,
    SHR,
    ROL,
    ROR,
    NOT,
    AND,
    OR,
    XOR
} ALU_OPERATION;
module ALU #(
    parameter bit_depth = 8
) (
    input wire[3:0] IN_OP,
    input wire[bit_depth - 1:0] IN_A,
    input wire[bit_depth - 1:0] IN_B,
    output reg[bit_depth - 1:0] OUT_R
);
always @* begin
    case (IN_OP)
        ADD: OUT_R <= IN_A + IN_B;
        SUB: OUT_R <= IN_A - IN_B;
        SHL: OUT_R <= IN_A >> IN_B;
        SHR: OUT_R <= IN_A << IN_B;
        ROL: OUT_R <= {IN_A[0], IN_A[bit_depth - 1:1]}; //todo
        ROR: OUT_R <= {IN_A[bit_depth - 2:0], IN_A[bit_depth - 1]}; //todo
        NOT: OUT_R <= !IN_A;
        AND: OUT_R <= IN_A & IN_B;
        OR:  OUT_R <= IN_A | IN_B;
        XOR: OUT_R <= (IN_A | IN_B) & !(IN_A & IN_B);
    endcase
end
endmodule