//脉动阵列3*3矩阵乘法，vaild有效后输出结果矩阵
//designer：wangzichen

module matrix_mul_sa_pipe#(
parameter DW = 8
)(
input 				clk,
input 				rst_n,
input				start,
input signed[DW-1:0]		x_1,x_2,x_3,y_1,y_2,y_3,

output				p11_v,p1221_v,p132231_v,p3223_v,p33_v,
//output				p11_vp,p1221_vp,p132231_vp,p3223_vp,p33_vp,
output signed[2*DW:0]	p_1_1,p_1_2,p_1_3,p_2_1,p_2_2,p_2_3,p_3_1,p_3_2,p_3_3
//output signed[2*DW:0]	p_1_1p,p_1_2p,p_1_3p,p_2_1p,p_2_2p,p_2_3p,p_3_1p,p_3_2p,p_3_3p

);

reg[3:0] counter,counter_1,counter_2,counter_3,counter_4;
wire signed[2*DW:0]	p_1_1_t,p_1_2_t,p_1_3_t,p_2_1_t,p_2_2_t,p_2_3_t,p_3_1_t,p_3_2_t,p_3_3_t;
//wire signed[2*DW:0]	p_1_1_tt,p_1_2_tt,p_1_3_tt,p_2_1_tt,p_2_2_tt,p_2_3_tt,p_3_1_tt,p_3_2_tt,p_3_3_tt;
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
		if (!rst_n) begin
		counter <= 0;
		counter_1 <= 0;
		counter_2 <= 0;
		counter_3 <= 0;
		counter_4 <= 0;
		end
			else if (start) 
				begin
				    counter_1 <= counter;
					counter_2 <= counter_1;
					counter_3 <= counter_2;
					counter_4 <= counter_3;
				if (counter == 3)
					counter <= 0;
						else
							counter <= counter + 1;
				end
				else
				counter <= 0;
end

assign p11_v = (counter == 3);
assign p1221_v = (counter_1 == 3);
assign p132231_v = (counter_2 == 3);
assign p3223_v = (counter_3 == 3);
assign p33_v = (counter_4 == 3);

//assign p11_vp = (counter_1 == 2);
//assign p1221_vp = (counter_2 == 3);
//assign p132231_vp = (counter_3 == 4);
//assign p3223_vp = (counter_4 == 5);
//assign p33_vp = (counter == 6);

wire p11_clr = (counter == 3) ;
wire p1221_clr = (counter_1 == 3);
wire p132231_clr = (counter_2 == 3);
wire p3223_clr = (counter_3 == 3);
wire p33_clr =  (counter_4 == 3);
//wire clr = finish ;
//pe 11
pe#(.DW(DW))
    pe_11
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p11_clr),
    .x_i(x_1),
    .y_i(y_1),
    .x_o(p11_x),
    .y_o(p11_y),
    .pe_out(p_1_1_t)
//	.pe_t_o(p_1_1_tt)
    );
//pe 12
pe#(.DW(DW))
    pe_12
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p1221_clr),
    .x_i(p11_x),
    .y_i(y_2),
    .x_o(p12_x),
    .y_o(p12_y),
    .pe_out(p_1_2_t)
//	.pe_t_o(p_1_2_tt)
    );
//pe 13
pe#(.DW(DW))
    pe_13
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p132231_clr),
    .x_i(p12_x),
    .y_i(y_3),
    .x_o(),
    .y_o(p13_y),
    .pe_out(p_1_3_t)
//	.pe_t_o(p_1_3_tt)
    );
//pe 21
pe#(.DW(DW))
    pe_21
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p1221_clr),
    .x_i(x_2),
    .y_i(p11_y),
    .x_o(p21_x),
    .y_o(p21_y),
    .pe_out(p_2_1_t)
//	.pe_t_o(p_2_1_tt)
    );
//pe 22
pe#(.DW(DW))
    pe_22
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p132231_clr),
    .x_i(p21_x),
    .y_i(p12_y),
    .x_o(p22_x),
    .y_o(p22_y),
    .pe_out(p_2_2_t)
//	.pe_t_o(p_2_2_tt)
    );
//pe 23
pe#(.DW(DW))
    pe_23
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p3223_clr),
    .x_i(p22_x),
    .y_i(p13_y),
    .x_o(),
    .y_o(p23_y),
    .pe_out(p_2_3_t)
//	.pe_t_o(p_2_3_tt)
    );
//pe 31
pe#(.DW(DW))
    pe_31
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p132231_clr),
    .x_i(x_3),
    .y_i(p21_y),
    .x_o(p31_x),
    .y_o(),
    .pe_out(p_3_1_t)
//	.pe_t_o(p_3_1_tt)
    );
//pe 32
pe#(.DW(DW))
    pe_32
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p3223_clr),
    .x_i(p31_x),
    .y_i(p22_y),
    .x_o(p32_x),
    .y_o(),
    .pe_out(p_3_2_t)
//	.pe_t_o(p_3_2_tt)
    );
//pe 33
pe#(.DW(DW))
    pe_33
    (
    .clk(clk),
    .rst_n(rst_n),
    .clr(p33_clr),
    .x_i(p32_x),
    .y_i(p23_y),
    .x_o(),
    .y_o(),
    .pe_out(p_3_3_t)
//	.pe_t_o(p_3_3_tt)
    );

assign p_1_1 = (p11_v) ? p_1_1_t : 17'sb0;
assign p_1_2 = (p1221_v) ? p_1_2_t : 17'sb0;
assign p_1_3 = (p132231_v) ? p_1_3_t : 17'sb0;
assign p_2_1 = (p1221_v) ? p_2_1_t : 17'sb0;
assign p_2_2 = (p132231_v) ? p_2_2_t : 17'sb0;
assign p_2_3 = (p3223_v) ? p_2_3_t : 17'sb0;
assign p_3_1 = (p132231_v) ? p_3_1_t : 17'sb0;
assign p_3_2 = (p3223_v) ? p_3_2_t : 17'sb0;
assign p_3_3 = (p33_v) ? p_3_3_t : 17'sb0;

//assign p_1_1p = (p11_vp) ? p_1_1_tt : 17'sb0;
//assign p_1_2p = (p1221_vp) ? p_1_2_tt : 17'sb0;
//assign p_1_3p = (p132231_vp) ? p_1_3_tt : 17'sb0;
//assign p_2_1p = (p1221_vp) ? p_2_1_tt : 17'sb0;
///assign p_2_2p = (p132231_vp) ? p_2_2_tt : 17'sb0;
//assign p_2_3p = (p3223_vp) ? p_2_3_tt : 17'sb0;
//assign p_3_1p = (p132231_vp) ? p_3_1_tt : 17'sb0;
//assign p_3_2p = (p3223_vp) ? p_3_2_tt : 17'sb0;
//assign p_3_3p = (p33_vp) ? p_3_3_tt : 17'sb0;

endmodule