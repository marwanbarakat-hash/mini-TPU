module tb_hbm();
    logic        clk;
    logic        reset;
    logic [15:0] addr;
    logic        wr_en;
    logic        rd_en;
    logic [31:0] data_in;
    logic [31:0] data_out;

    hbm top(.clk        (clk),
            .reset      (reset),
            .addr       (addr),
            .wr_en      (wr_en),
            .rd_en      (rd_en),
            .data_in    (data_in),
            .data_out   (data_out));
            

endmodule