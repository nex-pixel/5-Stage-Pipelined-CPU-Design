module decoder_32(out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16,
    out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31, in);

    input [4:0] in;

    output out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16,
    out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31;

    wire notin0, notin1, notin2, notin3, notin4;

    not in0(notin0, in[0]);
    not in1(notin1, in[1]);
    not in2(notin2, in[2]);
    not in3(notin3, in[3]);
    not in4(notin4, in[4]);

    and out_0(out0, notin4, notin3, notin2, notin1, notin0);
    and out_1(out1, notin4, notin3, notin2, notin1, in[0]);
    and out_2(out2, notin4, notin3, notin2, in[1], notin0);
    and out_3(out3, notin4, notin3, notin2, in[1], in[0]);
    and out_4(out4, notin4, notin3, in[2], notin1, notin0);
    and out_5(out5, notin4, notin3, in[2], notin1, in[0]);
    and out_6(out6, notin4, notin3, in[2], in[1], notin0);
    and out_7(out7, notin4, notin3, in[2], in[1], in[0]);
    
    and out_8(out8, notin4, in[3], notin2, notin1, notin0);
    and out_9(out9, notin4, in[3], notin2, notin1, in[0]);
    and out_10(out10, notin4, in[3], notin2, in[1], notin0);
    and out_11(out11, notin4, in[3], notin2, in[1], in[0]);
    and out_12(out12, notin4, in[3], in[2], notin1, notin0);
    and out_13(out13, notin4, in[3], in[2], notin1, in[0]);
    and out_14(out14, notin4, in[3], in[2], in[1], notin0);
    and out_15(out15, notin4, in[3], in[2], in[1], in[0]);
    
    and out_16(out16, in[4], notin3, notin2, notin1, notin0);
    and out_17(out17, in[4], notin3, notin2, notin1, in[0]);
    and out_18(out18, in[4], notin3, notin2, in[1], notin0);
    and out_19(out19, in[4], notin3, notin2, in[1], in[0]);
    and out_20(out20, in[4], notin3, in[2], notin1, notin0);
    and out_21(out21, in[4], notin3, in[2], notin1, in[0]);
    and out_22(out22, in[4], notin3, in[2], in[1], notin0);
    and out_23(out23, in[4], notin3, in[2], in[1], in[0]);
    
    and out_24(out24, in[4], in[3], notin2, notin1, notin0);
    and out_25(out25, in[4], in[3], notin2, notin1, in[0]);
    and out_26(out26, in[4], in[3], notin2, in[1], notin0);
    and out_27(out27, in[4], in[3], notin2, in[1], in[0]);
    and out_28(out28, in[4], in[3], in[2], notin1, notin0);
    and out_29(out29, in[4], in[3], in[2], notin1, in[0]);
    and out_30(out30, in[4], in[3], in[2], in[1], notin0);
    and out_31(out31, in[4], in[3], in[2], in[1], in[0]);

endmodule