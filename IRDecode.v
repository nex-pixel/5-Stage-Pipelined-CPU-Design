module IRDecode(instructionIn, opcode, rd, rs, rt, shamt, ALUop, rZeroes, Immediate, Target, jIIZeroes);
    input[31:0] instructionIn;
    output[4:0] opcode, rd, rs, rt, shamt, ALUop;
    output[1:0] rZeroes;
    output[16:0] Immediate;
    output[26:0] Target;
    output[21:0] jIIZeroes;

    assign opcode = instructionIn[31:27];
    assign rd = instructionIn[26:22];
    assign rs = instructionIn[21:17];
    assign rt = instructionIn[16:12];
    assign shamt = instructionIn[11:7];
    assign ALUop = instructionIn[6:2];
    assign rZeroes = instructionIn[1:0];

    assign Immediate = instructionIn[16:0];

    assign Target = instructionIn[26:0];

    assign jIIZeroes = instructionIn[21:0];

    

endmodule