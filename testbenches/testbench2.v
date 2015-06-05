`timescale 1ns / 1ns
module testbench(sin, ssel, saddr, sclk, sout, pattern_out, field_byte_out, clk, bufp_in, buffer_select_in, fieldp_in, fieldwp_in, field_in_in, field_write_in) ;

parameter buffer_size = 12 ;
parameter buffer_width = 8 ;

defparam theBuffers.buffer_size = buffer_size ;
defparam theBuffers.buffer_width = buffer_width ;

input sin, sclk, ssel ;
input clk ; 
input [2:0] saddr ;
input [buffer_width-1:0] field_in_in ;
input field_write_in ;
output sout ;
output [buffer_width-1:0] field_byte_out ;

output [buffer_width-1:0] pattern_out [buffer_size] ;

reg [2:0] bufp ;
reg [2:0] buffer_select ;
reg [buffer_size-1:0] fieldp ;
reg [buffer_size-1:0] fieldwp ;
reg [buffer_width-1:0] pattern_out [buffer_size] ;
reg [buffer_width-1:0] field_byte_out ;


wire [buffer_width-1:0] field_byte ;
wire [buffer_width-1:0] current_buffer [buffer_size] ;


input [2:0] buffer_select_in ;
input [2:0] bufp_in ;
input [buffer_size-1:0] fieldp_in ;
input [buffer_size-1:0] fieldwp_in ;

reg [buffer_width-1:0] field_in ;
reg field_write ;

buffers theBuffers(sclk, sin, sout, ssel, saddr, bufp, buffer_select, current_buffer, fieldp, fieldwp, field_byte, field_in, field_write, clk) ;


/*
initial
begin
	sin = 1 ;
	fieldp = 0 ;
	sclk = 0 ;
	bufp = 0 ;
	ssel = 1 ;
	saddr = 0 ;
	counter = 0 ;
  // forever #1 sclk != sclk ;
end 
*/

//always #1 sclk = ~sclk;


//always #1 clk = ~clk ;
//


always @(posedge clk)
begin
 // bufp and fieldp cannot be simulaneously incremented, so model this
 buffer_select <= buffer_select_in ;
 bufp <= bufp_in ;	 
 fieldp <= fieldp_in ;
 fieldwp <= fieldwp_in ;
 pattern_out <= current_buffer ;
 field_byte_out <= field_byte ;
 field_write <= field_write_in ;
 field_in <= field_in_in ;
end


/*
// D-latch synthesis
always @(clk or incbufp or bufp_in or fieldp_in)
begin
	if (clk)
	begin
	bufp <= bufp_in ;
	fieldp <= fieldp_in ;
        end
end

always @(~clk or current_buffer or field_byte)
begin
	if (~clk)
	begin	
	pattern_out <= current_buffer ;
	field_byte_out <= field_byte ;
	end
end
*/
  
  
endmodule
