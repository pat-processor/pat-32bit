module digital(clk, reset, pwm_low, pwm_high, inputs_pads, imem_write_adr, imem_write, imem_in, outputs_pads,
bufp, fieldp, fieldwp, field_write_en_low, field_write_en_high, field_fromPAT, field_toPAT_low, field_toPAT_high) ;

parameter d_width = 8 ;
parameter i_adr_width = 10 ;
parameter i_width = 23 ; // instruction width
parameter i_buffer_size = 2 ;
parameter bufp_width = 3 ;
parameter fieldp_width = 5 ;

//input scan_enable ;
//input scan_in ;
input pwm_high ;
input pwm_low ;
input clk ;
input reset ;
input [d_width-1:0] inputs_pads ;
input [i_adr_width-1:0] imem_write_adr ;
input imem_write ;
input [(i_buffer_size*i_width)-1:0] imem_in ;
input [d_width-1:0] field_toPAT_low ;
input [d_width-1:0] field_toPAT_high ;

output [d_width-1:0] outputs_pads ;

output [bufp_width-1:0] bufp ;
output [fieldp_width-1:0] fieldp ;
output [fieldp_width-1:0] fieldwp ;
output field_write_en_low ;
output field_write_en_high ;
output [d_width-1:0] field_fromPAT ;

wire [i_adr_width-1:0] pc ;
wire jump ;
wire [i_width-1:0] instruction ;

wire [d_width-1:0] outputs_pat [3] ;
wire [d_width-1:0] inputs_pat [3] ;

reg [7:0] timer ;
reg [7:0] timer_div ;
always @(posedge clk)
begin
    if (reset) begin
        timer_div <= 0 ;
        timer <= 0 ;
    end
    else begin
    timer_div <= timer_div + 1 ;
    if (timer_div == 0) timer <= timer + 1 ;
    end
end

assign outputs_pads = outputs_pat[0] ;
// other two outputs currently unused. Should be used to access memory.

assign inputs_pat[0] = inputs_pads ;
assign inputs_pat[1] = {1'b0, 1'b0, 1'b0, 1'b0, imem_write, reset, pwm_high, pwm_low} ; // i.e. control and status signals
assign inputs_pat[2] = timer ; // Could also be an external data memory

//inst_mem iMem(pc, imem_write_adr, imem_write, imem_in, instruction) ;
instruction_buffer iBuffer(clk, reset, pc, instruction, imem_write_adr, imem_write, imem_in, jump) ;

pat thePAT(clk, reset, pc, jump, bufp, fieldp, fieldwp, field_write_en_low, field_write_en_high, field_fromPAT, instruction, field_toPAT_low, field_toPAT_high, inputs_pat, outputs_pat) ;

endmodule
