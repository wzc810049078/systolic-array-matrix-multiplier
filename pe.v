//基础功能单元pe

module pe#(
parameter DW = 8
)(
input clk,
input rst_n,
input clr,
input signed[DW-1:0] x_i,y_i,

output signed[DW-1:0] x_o,y_o,
output signed[2*DW:0] pe_out

);

reg signed[DW-1:0] x_reg,y_reg;
reg signed[2*DW:0] pe_reg;

wire signed[2*DW-1:0] x_mul_y = x_i * y_i ;


wire signed[2*DW:0] pe_t = x_mul_y + pe_reg;

always @(posedge clk , negedge rst_n )
	begin
		if (!rst_n) begin
			pe_reg <= 0;
			x_reg <= 0;
			y_reg <= 0;
			end
			else if (clr) begin
				pe_reg <= 0;
				x_reg <= 0;
				y_reg <= 0;
				end 
				else begin
					pe_reg <= pe_t;
					x_reg <= x_i;
					y_reg <= y_i;
					end
	end



assign x_o = x_reg;
assign y_o = y_reg;
assign pe_out = pe_reg;

endmodule