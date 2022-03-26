module opcodeTags(opcode, regWriteEnable, addressAddMux, memWrite, wrBwriteSelect);
    input[4:0] opcode;

    output regWriteEnable, addressAddMux, memWrite, wrBwriteSelect;

    assign regWriteEnable = (!(|(opcode))) || (!opcode[4] & opcode[3] & !opcode[2] & !opcode[1] & !opcode[0]) || (!opcode[4] & !opcode[3] & !opcode[2] & opcode[1] & opcode[0]) ||
        (opcode[4] & !opcode[3] & opcode[2] & !opcode[1] & opcode[0]) || (!opcode[4] & !opcode[3] & opcode[2] & !opcode[1] & opcode[0]);

    assign addressAddMux = (!opcode[4] & !opcode[3] & opcode[2] & opcode[1] & opcode[0]) || (!opcode[4] & opcode[3] & !opcode[2] & !opcode[1] & !opcode[0]);

    assign memWrite = (!opcode[4] & !opcode[3] & opcode[2] & opcode[1] & opcode[0]);

    assign wrBwriteSelect = (!opcode[4] & opcode[3] & !opcode[2] & !opcode[1] & !opcode[0]);

endmodule