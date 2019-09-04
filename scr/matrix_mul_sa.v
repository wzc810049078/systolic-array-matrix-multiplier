//脉动阵列3*3矩阵乘法，vaild有效后输出结果矩阵
//designer：wangzichen

module matrix_mul_sa#(
parameter DW = 8
)(
input 				clk,
input 				rst_n,
input				start,
input signed[DW-1:0]		x_1,x_2,x_3,y_1,y_2,y_3,

output				finish,
output signed[2*DW:0]	p_1_1,p_1_2,p_1_3,p_2_1,p_2_2,p_2_3,p_3_1,p_3_2,p_3_3

);

reg[3:0] counter;
wire signed[2*DW:0]	p_1_1_t,p_1_2_t,p_1_3_t,p_2_1_t,p_2_2_t,p_2_3_t,p_3_1_t,p_3_2_t,p_3_3_t;
wire signed[DW-1:0] p11_x,p11_y;
wire signed[DW-1:0] p12_x,p12_y;
wire signed[DW-1:0] p21_x,p21_y;
wire signed[DW-1:0] p22_x,p22_y;
wire signed[DW-1:0] p31_x;
wire signed[DW-1:0] p32_x;
wire signed[DW-1:0] p13_y;
wire signed[DW-1:0] p23_y;



always @(posedge clk , negedge rst_n)
	begin
		if (!rst_n)
		 counter <= 0;
			else if (start) 
				begin
				if (counter == 7)
					counter <= 0;
						else
							counter <= counter + 1;
				end
				else
				counter <= 0;
end

assign finish = (counter == 7) ;
wire clr = finish ;
//pe 11
pe#(.DW(DW))
    pe_11
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(x_1),
    .y_i(y_1),
    .x_o(p11_x),
    .y_o(p11_y),
    .pe_out(p_1_1_t)
    );
//pe 12
pe#(.DW(DW))
    pe_12
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p11_x),
    .y_i(y_2),
    .x_o(p12_x),
    .y_o(p12_y),
    .pe_out(p_1_2_t)
    );
//pe 13
pe#(.DW(DW))
    pe_13
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p12_x),
    .y_i(y_3),
    .x_o(),
    .y_o(p13_y),
    .pe_out(p_1_3_t)
    );
//pe 21
pe#(.DW(DW))
    pe_21
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(x_2),
    .y_i(p11_y),
    .x_o(p21_x),
    .y_o(p21_y),
    .pe_out(p_2_1_t)
    );
//pe 22
pe#(.DW(DW))
    pe_22
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p21_x),
    .y_i(p12_y),
    .x_o(p22_x),
    .y_o(p22_y),
    .pe_out(p_2_2_t)
    );
//pe 23
pe#(.DW(DW))
    pe_23
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p22_x),
    .y_i(p13_y),
    .x_o(),
    .y_o(p23_y),
    .pe_out(p_2_3_t)
    );
//pe 31
pe#(.DW(DW))
    pe_31
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(x_3),
    .y_i(p21_y),
    .x_o(p31_x),
    .y_o(),
    .pe_out(p_3_1_t)
    );
//pe 32
pe#(.DW(DW))
    pe_32
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p31_x),
    .y_i(p22_y),
    .x_o(p32_x),
    .y_o(),
    .pe_out(p_3_2_t)
    );
//pe 33
pe#(.DW(DW))
    pe_33
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(clr),
    .x_i(p32_x),
    .y_i(p23_y),
    .x_o(),
    .y_o(),
    .pe_out(p_3_3_t)
    );

assign p_1_1 = (finish) ? p_1_1_t : 17'sb0;
assign p_1_2 = (finish) ? p_1_2_t : 17'sb0;
assign p_1_3 = (finish) ? p_1_3_t : 17'sb0;
assign p_2_1 = (finish) ? p_2_1_t : 17'sb0;
assign p_2_2 = (finish) ? p_2_2_t : 17'sb0;
assign p_2_3 = (finish) ? p_2_3_t : 17'sb0;
assign p_3_1 = (finish) ? p_3_1_t : 17'sb0;
assign p_3_2 = (finish) ? p_3_2_t : 17'sb0;
assign p_3_3 = (finish) ? p_3_3_t : 17'sb0;

endmodule