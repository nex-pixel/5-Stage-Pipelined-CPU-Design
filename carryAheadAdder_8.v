module carryAheadAdder_8(result, G, P, A, B, Cin);
        
    input [7:0] A, B;
    input Cin;

    output [7:0] result;
    output G, P;
    wire p0, p1, p2, p3, p4, p5, p6, p7, g0, g1, g2, g3, g4, g5, g6, g7;
    wire c1, c2, c3, c4, c5, c6, c7;

    and g0_generate(g0, A[0], B[0]);
    and g1_generate(g1, A[1], B[1]);
    and g2_generate(g2, A[2], B[2]);
    and g3_generate(g3, A[3], B[3]);
    and g4_generate(g4, A[4], B[4]);
    and g5_generate(g5, A[5], B[5]);
    and g6_generate(g6, A[6], B[6]);
    and g7_generate(g7, A[7], B[7]);

    or p0_propogate(p0, A[0], B[0]);
    or p1_propogate(p1, A[1], B[1]);
    or p2_propogate(p2, A[2], B[2]);
    or p3_propogate(p3, A[3], B[3]);
    or p4_propogate(p4, A[4], B[4]);
    or p5_propogate(p5, A[5], B[5]);
    or p6_propogate(p6, A[6], B[6]);
    or p7_propogate(p7, A[7], B[7]);

    //0 bits added
    xor add_0(result[0], A[0], B[0], Cin);
    wire carry0sub1;
    and carryout_0_sub1(carry0sub1, Cin, p0);
    or carry0over(c1, carry0sub1, g0);

    //1 bits added
    xor add_1(result[1], A[1], B[1], c1);
    wire carry1sub1, carry1sub2;
    and carryout_1_sub1(carry1sub1, Cin, p0, p1);
    and carryout_1_sub2(carry1sub2, g0, p1);
    or carry1over(c2, carry1sub1, carry1sub2, g1);

    xor add_2(result[2], A[2], B[2], c2);
    wire carry2sub1, carry2sub2, carry2sub3;
    and carryout_2_sub1(carry2sub1, Cin, p0, p1, p2);
    and carryout_2_sub2(carry2sub2, g0, p1, p2);
    and carryout_2_sub3(carry2sub3, g1, p2);
    or carry2over(c3, carry2sub1, carry2sub2, carry2sub3, g2);

    xor add_3(result[3], A[3], B[3], c3);
    wire carry3sub1, carry3sub2, carry3sub3, carry3sub4;
    and carryout_3_sub1(carry3sub1, Cin, p0, p1, p2, p3);
    and carryout_3_sub2(carry3sub2, g0, p1, p2, p3);
    and carryout_3_sub3(carry3sub3, g1, p2, p3);
    and carryout_3_sub4(carry3sub4, g2, p3);
    or carry3over(c4, carry3sub1, carry3sub2, carry3sub3, carry3sub4, g3);

    xor add_4(result[4], A[4], B[4], c4);
    wire carry4sub1, carry4sub2, carry4sub3, carry4sub4, carry4sub5;
    and carryout_4_sub1(carry4sub1, Cin, p0, p1, p2, p3, p4);
    and carryout_4_sub2(carry4sub2, g0, p1, p2, p3, p4);
    and carryout_4_sub3(carry4sub3, g1, p2, p3, p4);
    and carryout_4_sub4(carry4sub4, g2, p3, p4);
    and carryout_4_sub5(carry4sub5, g3, p4);
    or carry4over(c5, carry4sub1, carry4sub2, carry4sub3, carry4sub4, carry4sub5, g4);

    xor add_5(result[5], A[5], B[5], c5);
    wire carry5sub1, carry5sub2, carry5sub3, carry5sub4, carry5sub5, carry5sub6;
    and carryout_5_sub1(carry5sub1, Cin, p0, p1, p2, p3, p4, p5);
    and carryout_5_sub2(carry5sub2, g0, p1, p2, p3, p4, p5);
    and carryout_5_sub3(carry5sub3, g1, p2, p3, p4, p5);
    and carryout_5_sub4(carry5sub4, g2, p3, p4, p5);
    and carryout_5_sub5(carry5sub5, g3, p4, p5);
    and carryout_5_sub6(carry5sub6, g4, p5);
    or carry5over(c6, carry5sub1, carry5sub2, carry5sub3, carry5sub4, carry5sub5, carry5sub6, g5);

    xor add_6(result[6], A[6], B[6], c6);
    wire carry6sub1, carry6sub2, carry6sub3, carry6sub4, carry6sub5, carry6sub6, carry6sub7;
    and carryout_6_sub1(carry6sub1, Cin, p0, p1, p2, p3, p4, p5, p6);
    and carryout_6_sub2(carry6sub2, g0, p1, p2, p3, p4, p5, p6);
    and carryout_6_sub3(carry6sub3, g1, p2, p3, p4, p5, p6);
    and carryout_6_sub4(carry6sub4, g2, p3, p4, p5, p6);
    and carryout_6_sub5(carry6sub5, g3, p4, p5, p6);
    and carryout_6_sub6(carry6sub6, g4, p5, p6);
    and carryout_6_sub7(carry6sub7, g5, p6);
    or carry6over(c7, carry6sub1, carry6sub2, carry6sub3, carry6sub4, carry6sub5, carry6sub6, carry6sub7, g6);

    xor add_7(result[7], A[7], B[7], c7);
    and finalP(P, p0, p1, p2, p3, p4, p5, p6, p7);
    wire carry7sub2, carry7sub3, carry7sub4, carry7sub5, carry7sub6, carry7sub7, carry7sub8;
    and carryout_7_sub2(carry7sub2, g0, p1, p2, p3, p4, p5, p6, p7);
    and carryout_7_sub3(carry7sub3, g1, p2, p3, p4, p5, p6, p7);
    and carryout_7_sub4(carry7sub4, g2, p3, p4, p5, p6, p7);
    and carryout_7_sub5(carry7sub5, g3, p4, p5, p6, p7);
    and carryout_7_sub6(carry7sub6, g4, p5, p6, p7);
    and carryout_7_sub7(carry7sub7, g5, p6, p7);
    and carryout_7_sub8(carry7sub8, g6, p7);
    or carry7over(G, carry7sub2, carry7sub3, carry7sub4, carry7sub5, carry7sub6, carry7sub7, carry7sub8, g7);

endmodule