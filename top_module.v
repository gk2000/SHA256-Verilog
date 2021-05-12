/*<Top module.>
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

module top_module(clk,master_reset,data_in,data_end,delay,hash_done,hash_out);
	input clk,data_end,master_reset;
	input [7:0] data_in;
	integer index;
	wire scheduling_done;
	output reg delay;
	reg rst,tmp_chk;
	reg [1:0] second_route;
	reg[63:0] length;
	reg [31:0] h0,h1,h2,h3,h4,h5,h6,h7;
	wire [255:0] digest;
	output reg hash_done;
	output reg [255:0] hash_out;
	reg [511:0] block_512;

	message_scheduler_and_compressor m1(.reset(rst),.chunk_512(block_512),.clk(clk),.h0(h0),.h1(h1),.h2(h2),.h3(h3),.h4(h4),.h5(h5),.h6(h6),.h7(h7),.digest(digest),.done(scheduling_done));

	always@(posedge clk) begin
		if(master_reset == 1'b1) begin
			hash_done <= 1'b0;
			hash_out<=256'b0;
			tmp_chk <= 1'b1;
			delay <= 1'b0;
			block_512<=512'b0;
			rst<=1'b1;
			index = 0;
			length<= 64'b0;
			second_route = 2'b0;
			h0 <= 32'b01101010000010011110011001100111;
			h1 <= 32'b10111011011001111010111010000101;
			h2 <= 32'b00111100011011101111001101110010;
			h3 <= 32'b10100101010011111111010100111010;
			h4 <= 32'b01010001000011100101001001111111;
			h5 <= 32'b10011011000001010110100010001100;
			h6 <= 32'b00011111100000111101100110101011;
			h7 <= 32'b01011011111000001100110100011001;
		end
		else begin
			if(second_route == 2'd3) begin
				rst = 1'b0;
				delay = 1'b1;
				second_route = 2'd2;
			end
			else if(second_route == 2'd1) begin
				block_512[63:0] = length[63:0];
				rst = 1'b0;
				delay = 1'b1;
				second_route = 2'd0;
			end
			else if(delay==1'b1) begin
				if(scheduling_done == 1'b1) begin
					rst = 1'b1;
					delay = 1'b0;
					block_512=512'b0;
					h0 = digest[255:224];
					h1 = digest[223:192];
					h2 = digest[191:160];
					h3 = digest[159:128];
					h4 = digest[127:96];
					h5 = digest[95:64];
					h6 = digest[63:32];
					h7 = digest[31:0];
					if(second_route == 2'd2) begin
						second_route = 2'd1;
					end
					else if (second_route == 2'b0 && tmp_chk==1'b0) begin
						hash_done = 1'b1;
						hash_out = {h0,h1,h2,h3,h4,h5,h6,h7};
					end
				end
			end
			else begin
				if(data_end==1'b0) begin
					block_512[511-index]= data_in[7];
					block_512[511-index-1]= data_in[6];
					block_512[511-index-2]= data_in[5];
					block_512[511-index-3]= data_in[4];
					block_512[511-index-4]= data_in[3];
					block_512[511-index-5]= data_in[2];
					block_512[511-index-6]= data_in[1];
					block_512[511-index-7]= data_in[0];
					index = index + 8;
					if (index>511) begin 
						rst = 1'b0;
						delay = 1'b1;
						length = length + 512;
						index = 0;
					end

				end
				else if(data_end==1'b1 && tmp_chk==1'b1) begin 
					block_512[511-index]= data_in[7];
					block_512[511-index-1]= data_in[6];
					block_512[511-index-2]= data_in[5];
					block_512[511-index-3]= data_in[4];
					block_512[511-index-4]= data_in[3];
					block_512[511-index-5]= data_in[2];
					block_512[511-index-6]= data_in[1];
					block_512[511-index-7]= data_in[0];
					index = index + 8;
					block_512[511-index] = 1'b1;
					length = length+index;
					tmp_chk = 1'b0;
					if(index<=448) begin
						block_512[63:0] = length[63:0];
						rst = 1'b0;
						delay = 1'b1;
					end
					else begin
						second_route=2'd3;
					end
				end
			end
		end
	end
endmodule