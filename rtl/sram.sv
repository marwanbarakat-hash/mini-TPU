module sram #(
	parameter int ADDR_WIDTH = 16, //there's 65,536 unique locations in high bandwidth mmeory (HBM)
	parameter int DATA_WIDTH = 32, //32-bit register size
	parameter int ADDR_RANGE = 1 << ADDR_WIDTH //Address range: 2^16 = 65,536 total entries
) (
	input logic        		  clk,
	input logic        		  reset,
	input logic  [ADDR_WIDTH - 1:0]   addr,
	input logic        		  wr_en,
	input logic        		  rd_en,
	input logic  [DATA_WIDTH - 1:0]   data_in,
	output logic [DATA_WIDTH - 1:0]   data_out
);

	logic [DATA_WIDTH-1:0] sram_mem [0:ADDR_RANGE-1];

	// Synchronous clock block
	always_ff @(posedge clk) begin
        	if (reset) begin
            		data_out <= '0;                 // Parameterized reset value
        	end else begin
            		if (wr_en) begin
                		sram_mem[addr] <= data_in;  // Fixed array name
            		end
            		if (rd_en) begin
                		data_out <= sram_mem[addr]; // Fixed array name
            		end
       		 end
   	 end

endmodule
