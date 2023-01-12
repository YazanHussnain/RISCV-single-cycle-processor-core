module Datapath(instruction, lsuDataout, addrOut, mask, chipSelect, rd_enOut, wr_enOut, lsuDataIn, branchType, clk, reset, reg_write, ALUsel, signEx_sel, readData2_muxSel, wr_sel, rd_sel, rd_en, wr_en, dm_mux_sel, rdata1_mux_sel);

    output logic [31:0] instruction, lsuDataout, addrOut;
    output logic wr_enOut, rd_enOut, chipSelect;
    output logic [3:0] mask;
    input logic clk, reset, reg_write, readData2_muxSel, wr_en, rd_en, rdata1_mux_sel;
    input logic [3:0] ALUsel;
    input logic [1:0] wr_sel, dm_mux_sel;
    input logic [2:0] rd_sel, signEx_sel, branchType;
    input logic [31:0] lsuDataIn;

    logic [31:0] pc_to_adder, adder_to_pc, pc_mux_out, rdata1_mux_out, adder_to_dm_mux;
    logic [31:0] readData1, readData2_muxIn, ALUout, signEx_out, dm_mux_out, readData_dm, readData2_muxOut;
    logic branchTaken;

    Mux_2x1 Mux2x1_PC(.Mux2_out(pc_mux_out), .Mux2_In1(adder_to_pc), .Mux2_In2(ALUout), .Mux2_sel(branchTaken));

    Program_Counter PC(.clk(clk), .reset(reset), .PC_Next(pc_mux_out), .PC_Out(pc_to_adder));

    Adder adder(.added_data(adder_to_pc), .data1(32'h4), .data2(pc_to_adder));

    Instruction_Memory IM(.read_addr(pc_to_adder), .instruction(instruction));

    RegisterFile RF(.readData1(readData1), .readData2(readData2_muxIn), .writeData(dm_mux_out), .readAddr1(instruction[19:15]), .readAddr2(instruction[24:20]), .writeAddr(instruction[11:7]), .write_enable(reg_write), .clk(clk), .reset(reset));

    ALU Alu(.ALUout(ALUout), .readData1(rdata1_mux_out), .readData2(readData2_muxOut), .ALUsel(ALUsel));

    SignExtender SE(.signEx_out(signEx_out), .signEx_in(instruction[31:7]), .signEx_sel(signEx_sel));

    Mux_2x1 Mux2x1(.Mux2_out(readData2_muxOut), .Mux2_In1(readData2_muxIn), .Mux2_In2(signEx_out), .Mux2_sel(readData2_muxSel));

    Mux_2x1 Mux2x1_Reg1(.Mux2_out(rdata1_mux_out), .Mux2_In1(readData1), .Mux2_In2(pc_to_adder), .Mux2_sel(rdata1_mux_sel));

    LoadStoreUnit LSU(.lsuDataout(lsuDataout), .Addr(ALUout), .lsuDataIn(lsuDataIn), .WBdata(readData_dm), .addrOut(addrOut), .mask(mask), .writeData(readData2_muxIn), .rd_en(rd_enOut), .wr_en(wr_enOut), .rd_enIn(rd_en), .wr_enIn(wr_en), .wr_sel(wr_sel), .rd_sel(rd_sel), .chipSelect(chipSelect));

    //DataMemory DM(.readData(readData_dm), .Addr(ALUout), .dataWrite(readData2_muxIn), .wr_sel(wr_sel), .rd_sel(rd_sel), .wr_en(wr_en), .rd_en(rd_en), .clk(clk), .reset(reset));
    
    Mux_3x1 Mux3x1_DM(.Mux3_out(dm_mux_out), .Mux3_In1(ALUout), .Mux3_In2(readData_dm), .Mux3_In3(adder_to_dm_mux), .Mux3_sel(dm_mux_sel));

    Adder adder1(.added_data(adder_to_dm_mux), .data1(32'h4), .data2(pc_to_adder));

    BranchComparator BC(.branchType(branchType), .branchTaken(branchTaken), .reg1(readData1), .reg2(readData2_muxIn));

endmodule