module hbm (
    input logic        clk,
    input logic        reset,
    input logic [15:0] addr,
    input logic        wr_en,
    input logic        rd_en,
    input logic [31:0] data_in,
    output logic [31:0] data_out
);

    logic [31:0] mem [65535:0];

    always_ff @( posedge clk , posedge reset ) begin
        if (reset ) begin
            data_out <= 32'h0000_0000;
        end else begin
            if (wr_en) begin
                mem[addr] <= data_in;  // Write operation
            end
            if (rd_en) begin
                data_out <= mem[addr]; // Read operation
            end       
        end
    end
endmodule