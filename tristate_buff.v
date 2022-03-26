module tristate_buff(out, in, oe);
    
    input [31:0] in;
    input oe;
    output [31:0] out;
    
    assign out = oe ? in : {32{1'bz}};

endmodule