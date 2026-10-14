module hbm #(
    parameter int HBM_ADDR_WIDTH = 32,  // 32-bit address line = 4 GB address space
    parameter int HBM_DATA_WIDTH = 256  // 256-bit wide bus (8 words per transfer)
) (
	input  logic                        clk,
	input  logic                        reset,
	input  logic [HBM_ADDR_WIDTH-1:0]   addr,
	input  logic                        wr_en,
	input  logic                        rd_en,
	input  logic [HBM_DATA_WIDTH-1:0]   data_in,
	output logic [HBM_DATA_WIDTH-1:0]   data_out,
	output logic                        ready
);

	// an array to simulate HBM
	logic [HBM_DATA_WIDTH-1:0] hbm_mem [logic [HBM_ADDR_WIDTH-1:0]];

    always_ff @(posedge clk) begin
        if (reset) begin
            data_out <= '0;
            ready    <= 1'b1;
        end else begin
            if (wr_en) begin
                hbm_mem[addr] = data_in;  // Write 256-bit wide word
            end
            if (rd_en) begin
                if (hbm_mem.exists(addr)) begin
                    data_out <= hbm_mem[addr];
                end else begin
                    data_out <= '0;        // Uninitialized addresses return zero
                end
            end
        end
    end

endmodule