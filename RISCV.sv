module RISCV(clk, reset, ledOut, Anodeselect, reset1);

    input logic clk, reset, reset1;
    output logic [7:0] Anodeselect;
    output logic [6:0] ledOut;

    logic [31:0] instruction, lsuDataout, lsuDataIn, Addr, displayData;
    logic reg_write, readData2_muxSel, wr_en, rd_en, rdata1_mux_sel, chipSelect, rd_enOut, wr_enOut;
    logic [1:0] wr_sel, dm_mux_sel;
    logic [2:0] rd_sel, signEx_sel, branchType;
    logic [3:0] ALUsel, mask;
    logic clkOut;

    ClockDivider clkDiv(.clk(clk), .reset(reset1), .clkOut(clkOut));

    sevenSeg segSeven(.clk(clk), .reset(reset), .data1(displayData), .ledOut(ledOut), .Anodeselect(Anodeselect));

    DataMemory DM(.readData(lsuDataIn), .Addr(Addr), .dataWrite(lsuDataout), .wr_en(wr_enOut), .rd_en(rd_enOut), .chipSelect(chipSelect), .clk(clkOut), .reset(reset), .mask(mask), .displayData(displayData));

    Datapath DP(.instruction(instruction), .lsuDataout(lsuDataout), .addrOut(Addr), .mask(mask), .chipSelect(chipSelect), .rd_enOut(rd_enOut), .wr_enOut(wr_enOut), .lsuDataIn(lsuDataIn), .branchType(branchType), .clk(clkOut), .reset(reset), .reg_write(reg_write), .ALUsel(ALUsel), .signEx_sel(signEx_sel), .readData2_muxSel(readData2_muxSel), .wr_sel(wr_sel), .rd_sel(rd_sel), .rd_en(rd_en), .wr_en(wr_en), .dm_mux_sel(dm_mux_sel), .rdata1_mux_sel(rdata1_mux_sel));

    Controller Control(.reg_write(reg_write), .ALUsel(ALUsel), .readData2_muxSel(readData2_muxSel), .signEx_sel(signEx_sel), .wr_en(wr_en), .rd_en(rd_en), .wr_sel(wr_sel), .rd_sel(rd_sel), .dm_mux_sel(dm_mux_sel), .rdata1_mux_sel(rdata1_mux_sel), .instruction(instruction), .branchType(branchType));

endmodule