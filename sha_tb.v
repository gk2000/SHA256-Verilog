/*<Testbench for the entire program.>
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

module sha_tb();
    reg clk,reset,reset1;
    integer scanfile, datafile;
    reg [7:0] data,data_in;
    reg data_end;
    wire [255:0] hash;
    wire hashing_done,delay;

    top_module top(clk,reset,data,data_end,delay,hashing_done,hash);

    initial begin
        datafile=$fopen("D:/Documents/3rd_year/Sem2/VLSI_for_Signal_Processing/Verilog_Assignments/SHA-256_Again/input.txt","r");
        reset = 1'b1;
		clk = 1'b1;
		data_end = 1'b0;
		#100;
		reset1 = 1'b0;
		#10;
		reset = 1'b0;
    end

    always begin
        #50;
        clk<=~clk;
    end


    always @(posedge clk) begin
        if(delay == 1'b0 && reset1 == 1'b0) begin
            scanfile = $fscanf(datafile,"%b",data_in);
            if(!$feof(datafile)) begin
                data = data_in;
            end
            else begin
                data <= data_in;
                data_end <= 1'b1;
            end
        end
    end
endmodule