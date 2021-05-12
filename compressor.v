/*<This module compresses the scheduled message sent to it.>
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

module compressor(msg,iteration,a,b,c,d,e,f,g,h,out1,out2,out3,out4,out5,out6,out7,out8);

input [31:0]msg,a,b,c,d,e,f,g,h;
input [6:0]iteration;
wire [31:0]K[63:0];
wire[31:0] s1,ch,s0,maj;
wire[33:0] temp1,temp2,t1,t2;
output[31:0]out1,out2,out3,out4,out5,out6,out7,out8;

assign K[0]=32'h428a2f98;
assign K[1]=32'h71374491;
assign K[2]=32'hb5c0fbcf;
assign K[3]=32'he9b5dba5;
assign K[4]=32'h3956c25b;
assign K[5]=32'h59f111f1;
assign K[6]=32'h923f82a4;
assign K[7]=32'hab1c5ed5;
assign K[8]=32'hd807aa98;
assign K[9]=32'h12835b01;
assign K[10]=32'h243185be;
assign K[11]=32'h550c7dc3;
assign K[12]=32'h72be5d74;
assign K[13]=32'h80deb1fe;
assign K[14]=32'h9bdc06a7;
assign K[15]=32'hc19bf174;
assign K[16]=32'he49b69c1;
assign K[17]=32'hefbe4786;
assign K[18]=32'h0fc19dc6;
assign K[19]=32'h240ca1cc;
assign K[20]=32'h2de92c6f;
assign K[21]=32'h4a7484aa;
assign K[22]=32'h5cb0a9dc;
assign K[23]=32'h76f988da;
assign K[24]=32'h983e5152;
assign K[25]=32'ha831c66d;
assign K[26]=32'hb00327c8;
assign K[27]=32'hbf597fc7;
assign K[28]=32'hc6e00bf3;
assign K[29]=32'hd5a79147;
assign K[30]=32'h06ca6351;
assign K[31]=32'h14292967;
assign K[32]=32'h27b70a85;
assign K[33]=32'h2e1b2138;
assign K[34]=32'h4d2c6dfc;
assign K[35]=32'h53380d13;
assign K[36]=32'h650a7354;
assign K[37]=32'h766a0abb;
assign K[38]=32'h81c2c92e;
assign K[39]=32'h92722c85;
assign K[40]=32'ha2bfe8a1;
assign K[41]=32'ha81a664b;
assign K[42]=32'hc24b8b70;
assign K[43]=32'hc76c51a3;
assign K[44]=32'hd192e819;
assign K[45]=32'hd6990624;
assign K[46]=32'hf40e3585;
assign K[47]=32'h106aa070;
assign K[48]=32'h19a4c116;
assign K[49]=32'h1e376c08;
assign K[50]=32'h2748774c;
assign K[51]=32'h34b0bcb5;
assign K[52]=32'h391c0cb3;
assign K[53]=32'h4ed8aa4a;
assign K[54]=32'h5b9cca4f;
assign K[55]=32'h682e6ff3;
assign K[56]=32'h748f82ee;
assign K[57]=32'h78a5636f;
assign K[58]=32'h84c87814;
assign K[59]=32'h8cc70208;
assign K[60]=32'h90befffa;
assign K[61]=32'ha4506ceb;
assign K[62]=32'hbef9a3f7;
assign K[63]=32'hc67178f2;


assign s1 = {e[5:0],e[31:6]} ^ {e[10:0],e[31:11]} ^ {e[24:0],e[31:25]};
assign ch = (e&f) ^ (~e & g);
assign temp1 = h+s1+ch+K[iteration]+msg;
assign s0 = {a[1:0],a[31:2]} ^ {a[12:0],a[31:13]} ^ {a[21:0],a[31:22]};
assign maj = (a&b) ^ (a&c) ^ (b&c);
assign temp2 = s0+maj;
assign t2 = temp1[31:0]+temp2[31:0];
assign out1 = t2[31:0];
assign out8 = g;
assign out7 = f;
assign out6 = e;
assign t1 = d+temp1[31:0];
assign out5 = t1[31:0];
assign out4 = c;
assign out3 = b;
assign out2 = a;
//assign t2 = temp1[31:0]+temp2[31:0];
///assign out1 = t2[31:0];
//assign out1 = 32'b0;

/*
initial begin
s1 = {e[5:0],e[31:6]} ^ {e[10:0],e[31:11]} ^ {e[24:0],e[31:25]};
ch = (e&f) ^ (~e & g);
temp1 = h+s1+ch+K[iteration]+msg;
s0 = {a[1:0],a[31:2]} ^ {a[12:0],a[31:13]} ^ {a[21:0],a[31:22]};
maj = (a&b) ^ (a&c) ^ (b&c);
temp2 = s0+maj;
out8 = g;
out7 = f;
out6 = e;
t1 = d+temp1[31:0];
out5 = t1[31:0];
out4 = c;
out3 = b;
out2 = a;
t2 = temp1[31:0]+temp2[31:0];
out1 = t2[31:0];
end*/

endmodule