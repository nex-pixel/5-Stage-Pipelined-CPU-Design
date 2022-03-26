module selfadjust_reg_32(datareadA, datareadB, datain, clock, we, clear, readAen, readBen);

    //Inputs
    input [31:0] datain; 
    input clock, clear, readAen, readBen, we;

    //Output
    output [31:0] datareadA, datareadB;

    wire [31:0] q;

    dffe_ref internalRegister(q[0], datain[0], clock, we, clear);
    dffe_ref internalRegister1(q[1], datain[1], clock, we, clear);
    dffe_ref internalRegister2(q[2], datain[2], clock, we, clear);
    dffe_ref internalRegister3(q[3], datain[3], clock, we, clear);

    dffe_ref internalRegister4(q[4], datain[4], clock, we, clear);
    dffe_ref internalRegister5(q[5], datain[5], clock, we, clear);
    dffe_ref internalRegister6(q[6], datain[6], clock, we, clear);
    dffe_ref internalRegister7(q[7], datain[7], clock, we, clear);

    dffe_ref internalRegister8(q[8], datain[8], clock, we, clear);
    dffe_ref internalRegister9(q[9], datain[9], clock, we, clear);
    dffe_ref internalRegister10(q[10], datain[10], clock, we, clear);
    dffe_ref internalRegister11(q[11], datain[11], clock, we, clear);

    dffe_ref internalRegister12(q[12], datain[12], clock, we, clear);
    dffe_ref internalRegister13(q[13], datain[13], clock, we, clear);
    dffe_ref internalRegister14(q[14], datain[14], clock, we, clear);
    dffe_ref internalRegister15(q[15], datain[15], clock, we, clear);

    dffe_ref internalRegister16(q[16], datain[16], clock, we, clear);
    dffe_ref internalRegister17(q[17], datain[17], clock, we, clear);
    dffe_ref internalRegister18(q[18], datain[18], clock, we, clear);
    dffe_ref internalRegister19(q[19], datain[19], clock, we, clear);

    dffe_ref internalRegister20(q[20], datain[20], clock, we, clear);
    dffe_ref internalRegister21(q[21], datain[21], clock, we, clear);
    dffe_ref internalRegister22(q[22], datain[22], clock, we, clear);
    dffe_ref internalRegister23(q[23], datain[23], clock, we, clear);

    dffe_ref internalRegister24(q[24], datain[24], clock, we, clear);
    dffe_ref internalRegister25(q[25], datain[25], clock, we, clear);
    dffe_ref internalRegister26(q[26], datain[26], clock, we, clear);
    dffe_ref internalRegister27(q[27], datain[27], clock, we, clear);

    dffe_ref internalRegister28(q[28], datain[28], clock, we, clear);
    dffe_ref internalRegister29(q[29], datain[29], clock, we, clear);
    dffe_ref internalRegister30(q[30], datain[30], clock, we, clear);
    dffe_ref internalRegister31(q[31], datain[31], clock, we, clear);

    
    tristate_buff readoutA(datareadA, q, readAen);
    tristate_buff readoutB(datareadB, q, readBen);

endmodule


