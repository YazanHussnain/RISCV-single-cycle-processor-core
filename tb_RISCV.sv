module tb_RISCV();

    logic clk, reset, reset1;
    logic [6:0] ledOut;
    logic [7:0] Anodeselect;
    RISCV riscv(.clk(clk), .reset(reset), .ledOut(ledOut), .Anodeselect(Anodeselect), .reset1(reset1));

    initial begin
        clk <= 1'b1;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        reset1 = 1;
        repeat(2)@(posedge clk)
        reset1 = 0;
        @(posedge clk)
        reset <= 1'b1;
        repeat(2) @(posedge riscv.clkOut);
        reset <= 1'b0;
        repeat (2200000) @(posedge clk);
        $stop;
    end

endmodule