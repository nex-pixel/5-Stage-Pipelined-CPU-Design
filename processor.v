/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
    //PC Stage
    wire[31:0] PCout, PCin, newPCcount, PCcountFromX, bypassedB;
    wire PCovf, PCcountSelect;
    wire[4:0] ALUrd, ALUopcode, WrBopcode;
    wire[26:0] ALUTarget;

    wire stallLogicResult;
    wire multDivOccuring;

    reg32only PC(PCout, PCin, !clock, !clock & !stallLogicResult, reset);

    assign address_imem = PCout[11:0];
    carryAheadAdder_32 PCadd(newPCcount, PCovf, PCout, 32'b00000000000000000000000000000001, 1'b0);

    wire branchWireStatement, takeBetX;
    wire[31:0] PCintra, PCintra2;

    mux_2 PCmuxPCcount(PCintra, branchWireStatement, newPCcount, PCcountFromX);

    //Jump or Jal command PC switch
    mux_2 PCmuxJumpPC(PCintra2, (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]) || (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & ALUopcode[1] & ALUopcode[0]) || 
        ((ALUopcode == 5'b10110) && takeBetX), PCintra, ALUTarget);

    //JR command PC switch
    mux_2 PCmuxJumpPC2(PCin, (ALUopcode == 5'b00100), PCintra2, bypassedB);

    //NOP into PCins to Reg
    wire[31:0] FDIRin;
    mux_2 branchtakenNop(FDIRin, branchWireStatement || (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]) || (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & ALUopcode[1] & ALUopcode[0]) || 
        (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & !ALUopcode[1] & !ALUopcode[0]), q_imem, 32'b0);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //F/D Latch

    wire[31:0] FDPCout, FDIRout;
    
    reg32only FDLatch1(FDPCout, newPCcount, !clock, !clock & !stallLogicResult, reset);
    reg32only FDlatch2(FDIRout, FDIRin, !clock, !clock & !stallLogicResult, reset);

    //================================================================================================================================================================================================

    //RegFile Stage

    wire[4:0] REGopcode, REGrd, REGrs, REGrt, REGshamt, REGALUop, intraRegB;
    wire[1:0] REGrZeroes;
    wire[16:0] REGImmediate;
    wire[26:0] REGTarget;
    wire[21:0] REGjIIZeroes;
    wire WrBregWriteEnable;

    IRDecode REGIRdecode(FDIRout, REGopcode, REGrd, REGrs, REGrt, REGshamt, REGALUop, REGrZeroes, REGImmediate, REGTarget, REGjIIZeroes);

    //sw pull rd for value to store
    mux_2 storeWordMux(intraRegB, (!REGopcode[4] & !REGopcode[3] & REGopcode[2] & REGopcode[1] & REGopcode[0]) | (REGopcode == 5'b00110) | (REGopcode == 5'b00010) | (REGopcode == 5'b00100), REGrt, REGrd);
    mux_2 betXMux(ctrl_readRegB, (REGopcode == 5'b10110), intraRegB, 5'b11110);

    assign ctrl_readRegA = REGrs;

    assign ctrl_writeEnable = !clock & WrBregWriteEnable;

    //STALL logic
    wire[31:0] DXIRin;

    assign stallLogicResult = multDivOccuring || ((ALUopcode == 5'b01000) && (((REGrs == ALUrd) || ((REGrt == ALUrd) && (ALUrd != 5'b0)) && (REGopcode != 5'b00111)))); 
    //assign stallLogicResult = 1'b0;

    mux_2 stallNOP(DXIRin, stallLogicResult || branchWireStatement || (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]) || (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & ALUopcode[1] & ALUopcode[0]) || 
        (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & !ALUopcode[1] & !ALUopcode[0]), FDIRout, 32'b0);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    //D/X Latch

    wire[31:0] DXPCout, DXIRout, Aout, Bout, DXBout;

    reg32only DXLatch1(DXPCout, FDPCout, !clock, !clock, reset);
    reg32only DXlatch2(DXIRout, DXIRin, !clock, !clock, reset);
    reg32only DXLatch3(Aout, data_readRegA, !clock, !clock, reset);
    reg32only DXlatch4(Bout, data_readRegB, !clock, !clock, reset);
    reg32only DXLatch5(DXBout, ctrl_readRegB, !clock, !clock, reset);

    //================================================================================================================================================================================================

    //ALU stage

    wire [4:0] ctrl_ALUopcode, aluINOPcode;
    wire [31:0] ALUout, ALUBin, B, ALUImmediateSignExtend, XMOout;                    //output
	wire isNotEqual, isLessThan, overflow;      //output
    
    wire[4:0] ALUrs, ALUrt, ALUshamt, ALUALUop, WrBrd, MEMrd;
    wire[1:0] ALUrZeroes;
    wire[16:0] ALUImmediate;
    wire[21:0] ALUjIIZeroes;

    IRDecode ALUIRdecode(DXIRout, ALUopcode, ALUrd, ALUrs, ALUrt, ALUshamt, ALUALUop, ALUrZeroes, ALUImmediate, ALUTarget, ALUjIIZeroes);

    wire ALUregWriteEnable, ALUaddressAddMux, ALUmemWrite, ALUwrBwriteSelect;
    opcodeTags ALUopcodeDecode(ALUopcode, ALUregWriteEnable, ALUaddressAddMux, ALUmemWrite, ALUwrBwriteSelect);

    //ALU BYPASS
    wire[31:0] intraAALU, intraBALU, bypassedA;
    
    mux_2 aluBypassA(intraAALU, ((ALUrs == WrBrd) & (WrBrd != 5'b0)) & (ALUrs != 5'b0) & (WrBopcode != 5'b00111), Aout, data_writeReg);
    mux_2 aluBypassA2(bypassedA, (ALUrs == MEMrd) & (MEMrd != 5'b0) & (ALUrs != 5'b0), intraAALU, XMOout);

    mux_2 aluBypassB(intraBALU, ((DXBout[4:0] == WrBrd) & (WrBrd != 5'b0)) & (DXBout[4:0] != 5'b0), Bout, data_writeReg);
    mux_2 aluBypassB2(bypassedB, (DXBout[4:0] == MEMrd) & (MEMrd != 5'b0) & (DXBout[4:0] != 5'b0), intraBALU, XMOout);
    
    //assign bypassedA = Aout;
    //assign bypassedB = Bout;

    //sign extend for immediate
    assign ALUImmediateSignExtend[16:0] = ALUImmediate[16:0];
    assign ALUImmediateSignExtend[31] = ALUImmediate[16];
    assign ALUImmediateSignExtend[30] = ALUImmediate[16];
    assign ALUImmediateSignExtend[29] = ALUImmediate[16];
    assign ALUImmediateSignExtend[28] = ALUImmediate[16];
    assign ALUImmediateSignExtend[27] = ALUImmediate[16];
    assign ALUImmediateSignExtend[26] = ALUImmediate[16];
    assign ALUImmediateSignExtend[25] = ALUImmediate[16];
    assign ALUImmediateSignExtend[24] = ALUImmediate[16];
    assign ALUImmediateSignExtend[23] = ALUImmediate[16];
    assign ALUImmediateSignExtend[22] = ALUImmediate[16];
    assign ALUImmediateSignExtend[21] = ALUImmediate[16];
    assign ALUImmediateSignExtend[20] = ALUImmediate[16];
    assign ALUImmediateSignExtend[19] = ALUImmediate[16];
    assign ALUImmediateSignExtend[18] = ALUImmediate[16];
    assign ALUImmediateSignExtend[17] = ALUImmediate[16];

    //add immediate LW or SW opcode (AddI, SW, LW, BNE, BLT)
    wire controlSignalForLWSWAddI, zeroresultALU;
    or orimmediateInsALU(controlSignalForLWSWAddI, (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]), (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & ALUopcode[1] & ALUopcode[0]), (!ALUopcode[4] & ALUopcode[3] & !ALUopcode[2] & !ALUopcode[1] & !ALUopcode[0]));

    mux_2 addImmedmux(B, controlSignalForLWSWAddI, bypassedB, ALUImmediateSignExtend);
    //mux_2 subImmedmuxIFBneg(aluINOPcode, (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]) & ALUImmediate[16], ctrl_ALUopcode, 5'b00001);

    mux_2 aluopcodein(ctrl_ALUopcode, !(|(ALUopcode)), 5'b00000, ALUALUop);

    alu ALU(bypassedA, B, ctrl_ALUopcode, ALUshamt, ALUout, isNotEqual, isLessThan, overflow);

    wire[31:0] intraOVF1, intraOVF2;
    mux_2 subOVF(intraOVF1, (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]), 32'h1, 32'h2);
    mux_2 subOVF2(intraOVF2, !(|(ALUopcode)) && (!ALUALUop[4] & !ALUALUop[3] & !ALUALUop[2] & !ALUALUop[1] & ALUALUop[0]), intraOVF1, 32'h3);

    wire[31:0] XMaluin, XMIRin, XMIRin2, intraXMaluin;
    mux_2 ovfDetection(intraXMaluin, overflow, ALUout, intraOVF2);
    mux_2 jalStoreVal(XMaluin, (ALUopcode == 5'b00011), intraXMaluin, DXPCout);

    mux_2 ovfIRReplacement(XMIRin, overflow, DXIRout, 32'b00000111100000000000000000000000);

    //branch shift calculation
    wire neglibleIsNotEq, neglibleIsLessThan, neglibleOvf;
    alu ALU2(DXPCout, ALUImmediateSignExtend, 5'b00000, ALUshamt, PCcountFromX, neglibleIsNotEq, neglibleIsLessThan, neglibleOvf);

    //BranchNoteq command or BranchLessThan command
    assign branchWireStatement = ((isNotEqual & (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & ALUopcode[1] & !ALUopcode[0])) || (isLessThan & (!ALUopcode[4] & !ALUopcode[3] & ALUopcode[2] & ALUopcode[1] & !ALUopcode[0])));

    //insert NOP for when a branching happens
    mux_2 branchingNOPinsert(XMIRin2, branchWireStatement | (!ALUopcode[4] & !ALUopcode[3] & !ALUopcode[2] & !ALUopcode[1] & ALUopcode[0]) | 
        ((ALUopcode == 5'b10110) && takeBetX) | (ALUopcode == 5'b00100), XMIRin, 32'b0);

    //BETx jump
    assign takeBetX = |(bypassedB);

    //================================================================================================================================================================================================

    //Multiplication and Division
    wire [31:0] data_result_multdiv;
    wire MDdata_exception, MDdata_resultRDY, MDdata_resultRDYout;

    wire ctrl_MULT, ctrl_DIV;
    assign ctrl_MULT = (!(|(ALUopcode))) & (ALUALUop == 5'b00110);
    assign ctrl_DIV  = (!(|(ALUopcode))) & (ALUALUop == 5'b00111);

    dffe_ref muldivOccuringHere(multDivOccuring, ctrl_DIV | ctrl_MULT, clock, (ctrl_DIV | ctrl_MULT), PWrdy | reset);

    multdiv multiDiv(bypassedA, bypassedB, ctrl_MULT, ctrl_DIV, clock, data_result_multdiv, MDdata_exception, MDdata_resultRDY);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //P/W Latch
    wire[31:0] PWIRout, PWout;
    wire PWrdy;
    reg32only PWlatch1(PWIRout, DXIRout, !clock, !clock && (ctrl_DIV | ctrl_MULT), reset);
    reg32only PWlatch2(PWout, data_result_multdiv, !clock, !clock && MDdata_resultRDY, reset);
    dffe_ref MDdataReady(PWrdy, MDdata_resultRDY, !clock, !clock, reset);

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //X/M Latch

    wire[31:0] XMIRout, XMBout;

    reg32only XMlatch1(XMIRout, XMIRin2, !clock, !clock, reset);
    reg32only XMlatch2(XMOout, XMaluin, !clock, !clock, reset);
    reg32only XMlatch3(XMBout, Bout, !clock, !clock, reset);

    //================================================================================================================================================================================================

    //Memory Stage

    wire[4:0] MEMopcode, MEMrs, MEMrt, MEMshamt, MEMALUop;
    wire[1:0] MEMrZeroes;
    wire[16:0] MEMImmediate;
    wire[26:0] MEMTarget;
    wire[21:0] MEMjIIZeroes;

    IRDecode MEMIRdecode(XMIRout, MEMopcode, MEMrd, MEMrs, MEMrt, MEMshamt, MEMALUop, MEMrZeroes, MEMImmediate, MEMTarget, MEMjIIZeroes);

    wire MEMregWriteEnable, MEMaddressAddMux, MEMmemWrite, MEMwrBwriteSelect;
    opcodeTags MEMopcodeDecode(MEMopcode, MEMregWriteEnable, MEMaddressAddMux, MEMmemWrite, MEMwrBwriteSelect);    


    //MEMORY BYPASS
    mux_2 memBypass(data, (MEMrd == WrBrd) && (WrBrd != 5'b0), XMBout, data_writeReg);

    assign wren = MEMmemWrite;

    assign address_dmem = XMOout;

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //M/W Latch

    wire[31:0] MWIRout, MWDout, MWOout;

    reg32only MWlatch1(MWIRout, XMIRout, !clock, !clock, reset);
    reg32only MWlatch2(MWOout, XMOout, !clock, !clock, reset);
    reg32only MWlatch3(MWDout, q_dmem, !clock, !clock, reset);

    //================================================================================================================================================================================================

    //WriteBack Stage

    wire[4:0] WrBrs, WrBrt, WrBshamt, WrBALUop;
    wire[1:0] WrBrZeroes;
    wire[16:0] WrBImmediate;
    wire[26:0] WrBTarget;
    wire[21:0] WrBjIIZeroes;

    IRDecode WrBIRdecode(MWIRout, WrBopcode, WrBrd, WrBrs, WrBrt, WrBshamt, WrBALUop, WrBrZeroes, WrBImmediate, WrBTarget, WrBjIIZeroes);
    
    wire[4:0] PWopcode, PWrs, PWrd, PWrt, PWshamt, PWALUop, opcoder;
    wire[1:0] PWrZeroes;
    wire[16:0] PWImmediate;
    wire[26:0] PWTarget;
    wire[21:0] PWjIIZeroes;

    IRDecode PWIRdecode(PWIRout, PWopcode, PWrd, PWrs, PWrt, PWshamt, PWALUop, PWrZeroes, PWImmediate, PWTarget, PWjIIZeroes);

    wire WrBaddressAddMux, WrBmemWrite, WrBwrBwriteSelect, WrBregWriteEnableOut;
    mux_2 selectMultDivORnormal(opcoder, PWrdy, WrBopcode, PWopcode);
    opcodeTags WrBopcodeDecode(opcoder, WrBregWriteEnableOut, WrBaddressAddMux, WrBmemWrite, WrBwrBwriteSelect);

    mux_2 IgnoreNormalALUMultDiv(WrBregWriteEnable, (WrBopcode == 5'b00000) & ((WrBALUop == 5'b00110) | (WrBALUop == 5'b00111)), WrBregWriteEnableOut, 1'b0);    

    wire[31:0] intraWRB, intraWRB2;
    mux_2 writeBackmux(intraWRB, WrBwrBwriteSelect, MWOout, MWDout);
    mux_2 setXvaluemux(intraWRB2, (WrBopcode == 5'b10101), intraWRB, WrBTarget);
    mux_2 writeBackmux2(data_writeReg, PWrdy, intraWRB2, PWout);
    
    //jal mux
    wire[4:0] intramediateWriteReg, intra_ctrl_writeReg, intra_ctrl_writeReg2;
    mux_2 wrD(intra_ctrl_writeReg, (WrBopcode == 5'b00011), WrBrd, 5'b11111);
    mux_2 setXRegCtrl(intra_ctrl_writeReg2, (WrBopcode == 5'b10101), intra_ctrl_writeReg, 5'b11110);
    mux_2 wrd2(ctrl_writeReg, PWrdy, intra_ctrl_writeReg2, PWrd);
	/* END CODE */

endmodule
