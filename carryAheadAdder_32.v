module carryAheadAdder_32(result, Cout, A, B, Cin);
    input [31:0] A, B;
    input Cin;

    output Cout;
    output [31:0] result;

    wire g0, g1, g2, g3, p0, p1, p2, p3;
    wire c8,c16,c24;

    carryAheadAdder_8 firstBlock(result[7:0], g0, p0, A[7:0], B[7:0], Cin);
    wire carry8sub1;
    and carryout_8_sub1(carry8sub1, Cin, p0);
    or carry8over(c8, carry8sub1, g0);

    carryAheadAdder_8 secondBlock(result[15:8], g1, p1, A[15:8], B[15:8], c8);
    wire carry16sub1, carry16sub2;
    and carryout_16_sub1(carry16sub1, Cin, p0, p1);
    and carryout_16_sub2(carry16sub2, g0, p1);
    or carry16over(c16, carry16sub1, carry16sub2, g1);

    carryAheadAdder_8 thirdBlock(result[23:16], g2, p2, A[23:16], B[23:16], c16);
    wire carry24sub1, carry24sub2, carry24sub3;
    and carryout_24_sub1(carry24sub1, Cin, p0, p1, p2);
    and carryout_24_sub2(carry24sub2, g0, p1, p2);
    and carryout_24_sub3(carry24sub3, g1, p2);
    or carry24over(c24, carry24sub1, carry24sub2, carry24sub3, g2);

    carryAheadAdder_8 fourthBlock(result[31:24], g3, p3, A[31:24], B[31:24], c24);
    wire carry32sub1, carry32sub2, carry32sub3, carry32sub4;
    and carryout_32_sub1(carry32sub1, Cin, p0, p1, p2, p3);
    and carryout_32_sub2(carry32sub2, g0, p1, p2, p3);
    and carryout_32_sub3(carry32sub3, g1, p2, p3);
    and carryout_32_sub4(carry32sub4, g2, p3);
    or carry32over(Cout, carry32sub1, carry32sub2, carry32sub3, carry32sub4, g3);

endmodule
