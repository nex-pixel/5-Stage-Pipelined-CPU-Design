module reg32only(dataout, datain, clock, we, clear);

    //Inputs
    input [31:0] datain; 
    input clock, clear, readAen, readBen, we;

    //Output
    output [31:0] dataout;

    dffe_ref internalRegister(dataout[0], datain[0], clock, we, clear);
    dffe_ref internalRegister1(dataout[1], datain[1], clock, we, clear);
    dffe_ref internalRegister2(dataout[2], datain[2], clock, we, clear);
    dffe_ref internalRegister3(dataout[3], datain[3], clock, we, clear);

    dffe_ref internalRegister4(dataout[4], datain[4], clock, we, clear);
    dffe_ref internalRegister5(dataout[5], datain[5], clock, we, clear);
    dffe_ref internalRegister6(dataout[6], datain[6], clock, we, clear);
    dffe_ref internalRegister7(dataout[7], datain[7], clock, we, clear);

    dffe_ref internalRegister8(dataout[8], datain[8], clock, we, clear);
    dffe_ref internalRegister9(dataout[9], datain[9], clock, we, clear);
    dffe_ref internalRegister10(dataout[10], datain[10], clock, we, clear);
    dffe_ref internalRegister11(dataout[11], datain[11], clock, we, clear);

    dffe_ref internalRegister12(dataout[12], datain[12], clock, we, clear);
    dffe_ref internalRegister13(dataout[13], datain[13], clock, we, clear);
    dffe_ref internalRegister14(dataout[14], datain[14], clock, we, clear);
    dffe_ref internalRegister15(dataout[15], datain[15], clock, we, clear);

    dffe_ref internalRegister16(dataout[16], datain[16], clock, we, clear);
    dffe_ref internalRegister17(dataout[17], datain[17], clock, we, clear);
    dffe_ref internalRegister18(dataout[18], datain[18], clock, we, clear);
    dffe_ref internalRegister19(dataout[19], datain[19], clock, we, clear);

    dffe_ref internalRegister20(dataout[20], datain[20], clock, we, clear);
    dffe_ref internalRegister21(dataout[21], datain[21], clock, we, clear);
    dffe_ref internalRegister22(dataout[22], datain[22], clock, we, clear);
    dffe_ref internalRegister23(dataout[23], datain[23], clock, we, clear);

    dffe_ref internalRegister24(dataout[24], datain[24], clock, we, clear);
    dffe_ref internalRegister25(dataout[25], datain[25], clock, we, clear);
    dffe_ref internalRegister26(dataout[26], datain[26], clock, we, clear);
    dffe_ref internalRegister27(dataout[27], datain[27], clock, we, clear);

    dffe_ref internalRegister28(dataout[28], datain[28], clock, we, clear);
    dffe_ref internalRegister29(dataout[29], datain[29], clock, we, clear);
    dffe_ref internalRegister30(dataout[30], datain[30], clock, we, clear);
    dffe_ref internalRegister31(dataout[31], datain[31], clock, we, clear);

endmodule