module RegisterFile(readData1, readData2, writeData, readAddr1, readAddr2, writeAddr, write_enable, clk, reset);

    output logic [31:0] readData1, readData2;
    input logic [4:0] readAddr1, readAddr2, writeAddr;
    input logic [31:0] writeData;
    input clk, reset, write_enable;

    logic [31:0] registers [0:31];

    initial begin
        $readmemh("./Register.regfile", registers, 0, 31);
    end

    always_comb begin
        readData1 = (|readAddr1) ? registers[readAddr1] : 32'h0;
        readData2 = (|readAddr2) ? registers[readAddr2] : 32'h0;
    end

    always_ff @(negedge clk) begin
        if((|writeAddr) & (!write_enable))
            registers[writeAddr] <= writeData;
    end

endmodule