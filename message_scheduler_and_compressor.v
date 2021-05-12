/*<This is program schedules the message and compresses it>
    Copyright (C) <2021>  <Gautham Krishna>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

module message_scheduler_and_compressor(clk,reset,chunk_512,h0,h1,h2,h3,h4,h5,h6,h7,digest,done);
	input [511:0]chunk_512;
	input clk,reset;
	input [31:0]h0,h1,h2,h3,h4,h5,h6,h7;
	output reg done;
	output reg[255:0] digest;
	reg tmp_chk;
	reg[31:0] m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,a,b,c,d,e,f,g,h;
	wire[31:0]a_new,b_new,c_new,d_new,e_new,f_new,g_new,h_new,s0,s1;
	wire [33:0]val;
	reg [6:0] iter;

	assign s0 = ({m1[6:0],m1[31:7]} ^ {m1[17:0],m1[31:18]} ^ {1'b0,1'b0,1'b0,m1[31:3]});
	assign s1 = {m14[16:0],m14[31:17]} ^ {m14[18:0],m14[31:19]} ^ {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,m14[31:10]};
    assign val = m0 + s0 + m9 + s1;

	compressor c1(.msg(m0),.iteration(iter),.a(a),.b(b),.c(c),.d(d),.e(e),.f(f),.g(g),.h(h),.out1(a_new),.out2(b_new),.out3(c_new),.out4(d_new),.out5(e_new),.out6(f_new),.out7(g_new),.out8(h_new));

	
	always @(posedge clk) begin
		if (reset == 1'b1) begin
			tmp_chk<=1'b1;
			done<=1'b0;
			iter = 7'b0;
			digest<=256'b0;
		end
		else if (reset==1'b0 && tmp_chk==1'b1) begin
			m15<=chunk_512[31:0];
			m14<=chunk_512[63:32];
			m13<=chunk_512[95:64];
			m12<=chunk_512[127:96];
			m11<=chunk_512[159:128];
			m10<=chunk_512[191:160];
			m9<=chunk_512[223:192];
			m8<=chunk_512[255:224];
			m7<=chunk_512[287:256];
			m6<=chunk_512[319:288];
			m5<=chunk_512[351:320];
			m4<=chunk_512[383:352];
			m3<=chunk_512[415:384];
			m2<=chunk_512[447:416];
			m1<=chunk_512[479:448];
			m0<=chunk_512[511:480];
			a<=h0;
			b<=h1;
			c<=h2;
			d<=h3;
			e<=h4;
			f<=h5;
			g<=h6;
			h<=h7;
			tmp_chk<=1'b0;
		end
		else if(reset == 1'b0 && done==1'b0) begin
			if(iter<64) begin
				a <= a_new;
				b <= b_new;
				c <= c_new;
				d <= d_new;
				e <= e_new;
				f <= f_new;
				g <= g_new;
				h <= h_new;
				m15 <= val[31:0];
				m14 <= m15;
				m13 <= m14;
				m12 <= m13;
				m11 <= m12;
				m10 <= m11;
				m9 <= m10;
				m8 <= m9;
				m7 <= m8;
				m6 <= m7;
				m5 <= m6;
				m4 <= m5;
				m3 <= m4;
				m2 <= m3;
				m1 <= m2;
				m0 <= m1;
				iter <= iter+1;
				
			end
			else if(iter == 7'b1000000) begin
				done = 1'b1;
				a = h0+a;
				b = h1+b;
				c = h2+c;
				d = h3+d;
				e = h4+e;
				f = h5+f;
				g = h6+g;
				h = h7+h;
				digest = {a,b,c,d,e,f,g,h};
			end
		end
	end

endmodule
