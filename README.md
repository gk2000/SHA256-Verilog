# SHA256-Verilog
Verilog code for SHA-256 hashing

If you want to directly run the code, create a text file with binary 8-bit ascii of every input character in a new line. Then change the path for input file inside `sha_tb.v` and then run it. Although, I did not measure the exact no. of clock cycles required, a good rule of thumb would be 100 clock cycles per 512 bit input size.
