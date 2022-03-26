module tflipflop(Q, notQ, T, Clock, reset);
    output Q, notQ;

    input T, Clock, reset;

    wire notT, notQ, din1, din2, datain;

    not nott(notT, T);
    not notq(notQ, Q);
    and input1(din1, Q, notT);
    and input2(din2, notQ, T);
    or datainsig(datain, din1, din2);
    dffe_ref regtflipflop(Q, datain, Clock, Clock, reset);
    
endmodule