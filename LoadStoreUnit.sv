module LoadStoreUnit(lsuDataout, Addr, lsuDataIn, WBdata, addrOut, mask, writeData, rd_en, wr_en, rd_enIn, wr_enIn, wr_sel, rd_sel, chipSelect);

    output logic [31:0] lsuDataout, addrOut, WBdata;
    output logic [3:0] mask;
    output logic rd_en, wr_en, chipSelect;
    input logic [31:0] lsuDataIn, writeData;
    input logic [31:0] Addr;
    input logic [2:0] rd_sel;
    input logic [1:0] wr_sel;
    input logic rd_enIn, wr_enIn;


    always_comb begin
        addrOut = Addr;
        chipSelect = 1'b0;
        rd_en = rd_enIn;
        wr_en = wr_enIn;
        lsuDataout = writeData;
        case(rd_sel)
            3'h0: begin
                case(Addr[1:0])
                    2'h0: begin
                        WBdata = {{24{lsuDataIn[7]}}, lsuDataIn[7:0]};
                    end
                    2'h1: begin
                        WBdata = {{24{lsuDataIn[15]}}, lsuDataIn[15:8]};
                    end
                    2'h2: begin
                        WBdata = {{24{lsuDataIn[23]}}, lsuDataIn[23:16]};
                    end
                    2'h3: begin
                        WBdata = {{24{lsuDataIn[31]}}, lsuDataIn[31:24]};
                    end
                endcase
            end
            3'h1: begin
                case(Addr[1])
                    1'h0: begin
                        WBdata = {{16{lsuDataIn[15]}}, lsuDataIn[15:0]};
                    end
                    1'h1: begin
                        WBdata = {{16{lsuDataIn[31]}}, lsuDataIn[31:16]};
                    end
                endcase
            end
            3'h2: begin
                WBdata = lsuDataIn;
            end
            3'h3: begin
                case(Addr[1:0])
                    2'h0: begin
                        WBdata = {{24{1'b0}}, lsuDataIn[7:0]};
                    end
                    2'h1: begin
                        WBdata = {{24{1'b0}}, lsuDataIn[15:8]};
                    end
                    2'h2: begin
                        WBdata = {{24{1'b0}}, lsuDataIn[23:16]};
                    end
                    2'h3: begin
                        WBdata = {{24{1'b0}}, lsuDataIn[31:24]};
                    end
                endcase
            end
            3'h4: begin
                case(Addr[1])
                    1'h0: begin
                        WBdata = {{16{1'b0}}, lsuDataIn[15:0]};
                    end
                    1'h1: begin
                        WBdata = {{16{1'b0}}, lsuDataIn[31:16]};
                    end
                endcase
            end
        endcase
        case(wr_sel)
            2'h0: begin
                mask = 4'b1111;
            end
            2'h1: begin
                case(Addr[1:0])
                    2'h0: begin
                        mask = 4'b0001;
                    end
                    2'h1: begin
                        mask = 4'b0010;
                    end
                    2'h2: begin
                        mask = 4'b0100;
                    end
                    2'h3: begin
                        mask = 4'b1000;
                    end
                endcase
            end
            2'h2: begin
                case(Addr[1])
                1'h0: begin
                    mask = 4'b0011;
                end
                1'h1: begin
                    mask = 4'b1100;
                end
            endcase
            end
        endcase
    end

endmodule