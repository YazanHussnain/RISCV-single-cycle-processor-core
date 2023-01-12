module DataMemory(readData, Addr, dataWrite, wr_en, rd_en, chipSelect, clk, reset, mask, displayData);

    output logic [31:0] readData, displayData;
    input logic [31:0] Addr, dataWrite;
    input logic clk, reset, wr_en, rd_en, chipSelect;
    input [3:0] mask;

    logic [31:0] dataMemory [0:512];

    initial begin
        $readmemh("E:/CA_Lab/RISC-V/RIB-Type-LW-SW-RISCV/DataMemory.datamem", dataMemory, 0, 511);
    end

    always_comb begin
        displayData = dataMemory[2];
    end

    always_ff @(negedge clk) begin
        if(!chipSelect) begin
            if(rd_en) begin
                readData = dataMemory[Addr >> 2];
            end
        end
    end

    always_ff @(negedge clk) begin
        if(!chipSelect) begin
            if(!wr_en) begin
                if(mask[0]) begin
                    dataMemory[Addr >> 2][7:0] <= dataWrite[7:0];
                end
                if(mask[1]) begin
                    dataMemory[Addr >> 2][15:8] <= dataWrite[15:8];
                end
                if(mask[2]) begin
                    dataMemory[Addr >> 2][23:16] <= dataWrite[23:16];
                end
                if(mask[3]) begin
                    dataMemory[Addr >> 2][31:24] <= dataWrite[31:24];
                end
            end
        end
    end

endmodule