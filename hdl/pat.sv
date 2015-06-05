`define INSTR_NOP 20'h06ff5
module pat(clk, reset, pc, jump, bufp, fieldp, fieldwp, field_write_en_low, field_write_en_high, field_out, instruction_in, field_in_low, field_in_high, inputs, outputs) ;

parameter i_adr_width = 10 ; // instruction address space size
parameter i_width = 23 ; // instruction width
parameter d_adr_width = 3 ; // data address space size
parameter d_width = 32 ; // data width
parameter rd_width = 3 ; // destination register width
parameter call_stack_size = 8 ; // max call depth supported
parameter call_stack_pointer_size = 3 ; // bits for call stack pointer
parameter bufp_width = 3 ;
parameter fieldp_width = 5 ;
parameter buffer_width = 8 ;
parameter opcode_i8_width = 4 ; // width of opcode for i8 instruction
parameter opcode_i3_width = 4 ; // width of opcode for i3 instruction
parameter opcode_i0_width = 4 ; // width of opcode for i0 instruction
parameter field_latency = 4 ; // cycle count between field read and write


`define i3_opcode_prefix 4'b1111  // prefix string from i8 space
`define i0_opcode_prefix 4'b1111  // prefix string from i3 space

input clk ;
input reset ;
input [i_width-1:0] instruction_in ;
input [buffer_width-1:0] field_in_low ;
input [buffer_width-1:0] field_in_high ;
input [d_width-1:0] inputs [3] ;

output [i_adr_width-1:0] pc ;
output jump ;
output [bufp_width-1:0] bufp ;
output [fieldp_width-1:0] fieldp ;
output [fieldp_width-1:0] fieldwp ;
output field_write_en_low ;
output field_write_en_high ;
output [buffer_width-1:0] field_out ;

output [d_width-1:0] outputs [3] ;
reg [i_width-1:0] instruction_1 ;
reg [i_width-1:0] instruction_3 ; // duplicate for FO optimisation
reg [i_width-1:0] instruction_4 ; // duplicate for FO optimisation

reg [d_adr_width-1:0] sp ; // stack pointer
reg z ; // zero flag
reg n ; // neg flag

reg [i_adr_width-1:0] call_stack [call_stack_size] ;
reg [call_stack_pointer_size-1:0] call_stack_pointer ;

reg [d_width-1:0] data_out ;
reg [bufp_width-1:0] bufp ;
reg [fieldp_width-1:0] fieldp ;
reg [fieldp_width-1:0] fieldwp ;
reg field_write_en_low ;
reg field_write_en_high ;
reg [buffer_width-1:0] field_out ;
reg [fieldp_width-1:0] fieldp_history [field_latency] ;
reg low_high_buffer ; // '0' means use low-side buffer; '1' means use high-side

reg [d_width-1:0] outputs [3] ;


// =========================================================
// ============== PIPELINE STAGE 1 =========================
// =========================================================




// **** DECODE ******

// instruction type selection
wire i_t_i0 ;
wire i_t_i3 ;
wire i_t_i8 ;


// instruction immediate values
wire [rd_width-1:0] Rn ; // Source and destination register
wire [1:0] condition ;
wire [7:0] immediate_i8 ;
wire [2:0] immediate_i3 ;
wire [fieldp_width-1:0] fieldp_next ;
wire [opcode_i8_width-1:0] opcode_i8 ;
wire [opcode_i3_width-1:0] opcode_i3 ;
wire [opcode_i0_width-1:0] opcode_i0 ;
wire field_op ; // 0 := ACC op ; 1 := field op

//   [22:20]   [19:14]     [14:13]    [12]     [11:8]      [7:0]
assign {Rn, fieldp_next, condition, field_op, opcode_i8, immediate_i8} = instruction_1 ;

assign opcode_i3 = instruction_3[7:4] ; // TODO: parameterise. Must not overlap with i0 opcode space
assign opcode_i0 = instruction_3[3:0] ;
assign immediate_i3 = instruction_1[2:0] ;

// determine the type of the operation
assign i_t_i8 = (opcode_i8 != 4'b1111) ;
assign i_t_i3 = ((opcode_i8 == 4'b1111) && (opcode_i3 != 4'b1111)) ;
assign i_t_i0 = (!i_t_i8 && !i_t_i3) ;

// i8 operations
wire op_ori, op_orr, op_andi, op_andr, op_addi, op_addr ;
wire op_subi, op_subr, op_ldi, op_setsp, op_bf, op_call ;

assign op_ori =	(opcode_i8 == 4'b0000) && i_t_i8 ;
assign op_orr =  (opcode_i8 == 4'b0001) && i_t_i8 ;
assign op_andi =  (opcode_i8 == 4'b0010) && i_t_i8 ;
assign op_andr =  (opcode_i8 == 4'b0011) && i_t_i8 ;
assign op_addi =  (opcode_i8 == 4'b0100) && i_t_i8 ;
assign op_addr =  (opcode_i8 == 4'b0101) && i_t_i8 ;
assign op_subi =  (opcode_i8 == 4'b0110) && i_t_i8 ;
assign op_subr =  (opcode_i8 == 4'b0111) && i_t_i8 ;
assign op_ldi = (opcode_i8 == 4'b1000) && i_t_i8 ;
assign op_setsp = (opcode_i8 == 4'b1100) && i_t_i8 ;
assign op_bf = (opcode_i8 == 4'b1101) && i_t_i8 ;
assign op_call =(opcode_i8 == 4'b1110) && i_t_i8 ;
// 4'b1111 is i3 prefix


// i3 operations
wire op_shlzi, op_shlzr, op_shloi, op_shlor, op_shrzi, op_shrzr ;
wire op_shroi, op_shror, op_in, op_out, op_setb ;

assign op_shlzi = (opcode_i3 == 4'b0000) && i_t_i3 ;
assign op_shlzr =(opcode_i3 == 4'b0001) && i_t_i3 ;
assign op_shloi =(opcode_i3 == 4'b0010) && i_t_i3 ;
assign op_shlor = (opcode_i3 == 4'b0011) && i_t_i3 ;
assign op_shrzi = (opcode_i3 == 4'b0100) && i_t_i3 ;
assign op_shrzr = (opcode_i3 == 4'b0101) && i_t_i3 ;
assign op_shroi = (opcode_i3 == 4'b0110) && i_t_i3 ;
assign op_shror = (opcode_i3 == 4'b0111) && i_t_i3 ;
assign op_in = (opcode_i3 == 4'b1000) && i_t_i3 ;
assign op_out = (opcode_i3 == 4'b1011) && i_t_i3 ;
assign op_setb =(opcode_i3 == 4'b1100) && i_t_i3 ;
// 4'b1111 is i0 prefix

// i0 operations
wire op_not, op_test, op_return, op_nop ;

assign op_not = (opcode_i0 == 4'b0000) && i_t_i0 ;
assign op_test = (opcode_i0 == 4'b0010) && i_t_i0 ;
assign op_return = (opcode_i0 == 4'b0011) && i_t_i0 ;
assign op_nop = (opcode_i0 == 4'b0101) && i_t_i0 ;

// operation type selection
wire source_field, source_imm, source_in ;
wire dest_reg, dest_field, dest_pc, dest_out, dest_null ;

assign source_field = field_op ;
assign source_imm = (i_t_i8 && (opcode_i8[0] == 0)) | (i_t_i3 && (opcode_i3[0] == 0)) ;
assign source_in = op_in ;


// Which ops are committed to a register (Reg or Field_Out)
assign dest_out = op_out ;
assign dest_null = op_setb | op_test | op_nop ;
assign dest_pc = op_bf | op_call | op_return ;
assign dest_field = field_op && !(dest_out | dest_null | dest_pc) ;
assign dest_reg = !field_op && !(dest_out | dest_null | dest_pc) ;

reg [3:0] immediate_bufp_regd ;
reg [d_width-1:0] immediate_all_regd ;
reg [7:0] immediate_i8_regd ;
reg [7:0] immediate_pc ;
reg [3:0] condition_decoded ;
reg [d_width-1:0] immediate_value ;
reg [d_width-1:0] immediate_value_2 ;
reg [d_width-1:0] immediate_value_3 ;
reg [d_width-1:0] source1_value ;
reg [d_width-1:0] source1_value_2 ;
reg [d_width-1:0] source1_value_3 ;
reg [d_width-1:0] source2_value ;
reg [d_width-1:0] source2_value_2 ;
reg [d_width-1:0] source2_value_3 ;
reg source_immediate ;
wire [d_width-1:0] field_value_muxd ;

wire [d_width-1:0] immediate_i_all ;
assign immediate_i_all = (i_t_i8) ? immediate_i8 : {{5{1'b0}}, immediate_i3} ;

function [7:0] selectInput ;
	input [d_width-1:0] inputs [3] ;
	input [2:0] immediate_i3 ;
	begin
	case (immediate_i3)
		3'b001: selectInput = inputs[0] ;
		3'b010: selectInput = inputs[1] ;
		3'b100: selectInput = inputs[2] ;
	default: selectInput = inputs[0] ;
	endcase
end
endfunction

reg [2:0] bubbles ;
reg jumping ;
reg jump_forward ;
reg jump_return ;
`define NOPIPELINEBUBBLES 4

`define COND_Z 0 // zero
`define COND_NZ 1 // not-zero
`define COND_N 2 // negative
`define COND_AL 3 // always

reg execute_next ;
task precompute_condition ;
    input [1:0] condition ;
    begin
        case (condition)
            `COND_Z: execute_next <= z & ~jumping;
            `COND_NZ: execute_next <= ~z & ~jumping;
            `COND_N: execute_next <= n & ~jumping;
            `COND_AL: execute_next <= ~jumping ;
        endcase
    end
endtask

assign field_value_muxd = (low_high_buffer) ?  field_in_high : field_in_low ;
wire [d_width-1:0] data_in ;
task reg_instr ;
	begin
		immediate_bufp_regd <= immediate_i8[3:0] ; // Duplicated to aid fan-out. DC will merge if more optimal
		immediate_i8_regd <= immediate_i8 ;
		immediate_pc <= immediate_i8_regd ; // delay a further cycle for PC
		immediate_all_regd <= immediate_i_all ;
		// condition flags: {N, Z, AL}
		case (condition)
			0: condition_decoded <= 4'b0001 ;
			1: condition_decoded <= 4'b0010 ;
			2: condition_decoded <= 4'b0100 ;
			3: condition_decoded <= 4'b1000 ;
		endcase

		immediate_value <= immediate_i_all ;
		immediate_value_2 <= immediate_i_all ;
		immediate_value_3 <= immediate_i_all ;
		source1_value <= (op_ldi) ? 8'h00 : (field_op) ? field_value_muxd : (source_in) ? selectInput(inputs, immediate_i3) : data_in ; // order important - op_ldi applies to field too
		source1_value_2 <= (op_ldi) ? 8'h00 : (field_op) ? field_value_muxd : (source_in) ? selectInput(inputs, immediate_i3) : data_in ; // order important - op_ldi applies to field too
		source1_value_3 <= (op_ldi) ? 8'h00 : (field_op) ? field_value_muxd : (source_in) ? selectInput(inputs, immediate_i3) : data_in ; // order important - op_ldi applies to field too
		source2_value <= (source_imm) ? immediate_i_all : data_in ;
		source2_value_2 <= (source_imm) ? immediate_i_all : data_in ;
		source2_value_3 <= (source_imm) ? immediate_i_all : data_in ;
	end
endtask

reg field_op_regd ;
reg [rd_width-1:0] Rd_1 ;
reg [rd_width-1:0] Rd_2 ;

reg op_or_regd, op_and_regd, op_add_regd, op_addsub_regd ;
reg op_sub_regd,  op_ldi_regd, op_setsp_regd, op_bf_regd, op_call_regd ;
reg op_shlz_regd, op_shlo_regd, op_shrz_regd ;
reg op_shro_regd, op_in_regd, op_out_regd, op_setb_regd ;
reg op_not_regd, op_test_regd, op_return_regd, op_nop_regd ;




task reg_ops ;
	begin
		Rd_1 <= Rn ;
	        Rd_2 <= Rd_1 ;
		field_op_regd <= field_op ;
		op_or_regd <= op_ori | op_orr | op_ldi ; // ldi is OR with 0
		op_and_regd <= op_andi | op_andr ;
		op_add_regd <= op_addi | op_addr ;
		op_sub_regd <= op_subi | op_subr ;
	        op_addsub_regd <= op_addi | op_addr | op_subi | op_subr ;
		op_ldi_regd <= op_ldi ;
		op_setsp_regd <= op_setsp ;
		op_bf_regd <= op_bf ;
		op_call_regd <= op_call ;
		op_shlz_regd <= op_shlzi | op_shlzr ;
		op_shlo_regd <= op_shloi | op_shlor ;
		op_shrz_regd <= op_shrzi | op_shrzr ;
		op_shro_regd <= op_shroi | op_shror;
		op_in_regd <= op_in ;
		op_out_regd <= op_out ;
		op_setb_regd <= op_setb ;
		op_not_regd <= op_not ;
		op_test_regd <= op_test ;
		op_return_regd <= op_return ;
		op_nop_regd <= op_nop ;
	end
endtask


reg dest_reg_regd  ;
reg dest_field_regd ;
reg dest_pc_regd ;
reg dest_out_regd ;

task reg_srcdest ;
	begin
		source_immediate <= source_imm | source_in | source_field ;
		dest_reg_regd <= dest_reg ;
		dest_pc_regd <= dest_pc ;
		dest_field_regd <= dest_field ;
		dest_out_regd <= dest_out ;
	end
endtask


// **** Data memory ****
wire [d_adr_width-1:0] data_read_adr ;
reg [d_adr_width-1:0] data_write_adr ;
reg data_write ;
reg [d_width-1:0] data_regd ;
reg [d_width-1:0] data_regd_2 ;

assign data_read_adr = Rn ;
assign data_write_adr = Rd_2 ;

data_mem dmem(clk, data_read_adr, data_write_adr, data_write, data_out, data_in) ;

// * End data memory *


// **** Program counter ****

wire [d_width-1:0] pc_immediate ;
wire [i_adr_width-1:0] return_address ;

program_counter thePC(clk, reset, pc, immediate_pc, jump_forward, jump_return, op_call_regd) ;

// * End program counter *

// =====================================================================
// ================== PIPELINE STAGE 2: ALU and commit  ================
// =====================================================================

// instantiate two ALUs to speed up by preventing input MUX
wire [d_width-1:0] reg_alu_a ;
wire [d_width-1:0] reg_alu_a_2 ;
wire [d_width-1:0] reg_alu_a_3 ;
wire [d_width-1:0] reg_alu_b ;
wire [d_width-1:0] reg_alu_b_2 ;
wire [d_width-1:0] reg_alu_b_3 ;
wire [d_width-1:0] reg_alu_y ;

wire [d_width-1:0] imm_alu_a ;
wire [d_width-1:0] imm_alu_a_2 ;
wire [d_width-1:0] imm_alu_a_3 ;
wire [d_width-1:0] imm_alu_b ;
wire [d_width-1:0] imm_alu_b_2 ;
wire [d_width-1:0] imm_alu_b_3 ;
wire [d_width-1:0] imm_alu_y ;

wire [d_width-1:0] result ;

reg dest_field_regd_2 ;

assign reg_alu_a = data_out ;
assign reg_alu_b = source2_value ; // allows shift by Rd

assign imm_alu_b = immediate_value ; // immediates for shift must come in on b
assign imm_alu_a = source1_value ;

assign result = source_immediate ? imm_alu_y : reg_alu_y ;

alu accALU(reg_alu_a, reg_alu_b, reg_alu_y, op_or_regd, op_and_regd, op_not_regd, op_add_regd, op_sub_regd, op_addsub_regd, op_shlz_regd, op_shlo_regd, op_shrz_regd, op_shro_regd) ;

alu immALU(imm_alu_a, imm_alu_b, imm_alu_y, op_or_regd, op_and_regd, op_not_regd, op_add_regd, op_sub_regd, op_addsub_regd, op_shlz_regd, op_shlo_regd, op_shrz_regd, op_shro_regd) ;


// END ALUS





task updateFieldp() ;
	begin
		fieldp <= fieldp_next ;
	end
endtask

task updateFieldwp() ;
	begin
		integer i ;
		fieldp_history[0] <= fieldp ;
		fieldwp <= fieldp_history[field_latency-1] ;

		for (i = 1 ; i < (field_latency) ; i++)
		begin
			fieldp_history[i] <= fieldp_history[i-1] ;
		end
	end
endtask

task getData() ;
	begin
		data_regd <= data_in ;
		data_regd_2 <= data_in ;
	end
endtask

task updateFlags() ;
    if (!reset)    begin
        if (field_op_regd)
        begin
            z <= (field_value_muxd == 0) ;
            n <= (field_value_muxd[d_width-1] == 1) ;
        end
        else
        begin
            z <= (data_out == 0) ;
            n <= (data_out[d_width-1] == 1) ;
        end
    end
endtask


function checkCondition ;
	input [3:0] cond_decoded ;
	input z ;
	input n ;
	begin
	checkCondition = cond_decoded[`COND_AL] |
	       	(cond_decoded[`COND_N] && n) |
	       	(cond_decoded[`COND_NZ] && ~n) |
		(cond_decoded[`COND_Z] && z) ;
	end
endfunction


task registerOutput ;
	begin
		// TODO: Replace the case statement
		// when multiple outputs are connected up.
			outputs[0] <= data_out ;
		//endcase
	end
endtask


assign jump = jump_forward | jump_return ;
always @(posedge clk)
begin
    instruction_1 <= instruction_in ;
    instruction_3 <= instruction_in ;
    instruction_4 <= instruction_in ;
    reg_instr() ;
    reg_ops() ;
    reg_srcdest() ;
    precompute_condition(condition) ;
    updateFieldp() ;
    updateFieldwp() ;
    getData() ;

    // define asynchronous reset signals
    // in H18 lib, asynchronous reset dominates, so no need to use else
    // over
    if (reset)
    begin
        jumping <= 1'b1 ;
        jump_forward <= 1'b0 ;
        jump_return <= 1'b0 ;
        bubbles <= `NOPIPELINEBUBBLES ;
        data_write <= 1'b0 ;
        bufp <= 0 ;
        low_high_buffer <= 1'b0 ;
        field_write_en_low <= 1'b0 ;
        field_write_en_high <= 1'b0 ;
        field_out <= 8'b0 ;
	    data_out <= 8'b0 ;
        z <= 1'b1 ;
        n <= 1'b0 ;
    end
    else begin
        if (bubbles > 0) begin
	   		bubbles <= bubbles - 1 ;
	   		jump_forward <= 1'b0 ;
	 		jump_return <= 1'b0 ;
        end

        if (bubbles == 0) begin
            jumping <= 1'b0 ;
        end


    if (!execute_next) data_write <= 1'b0 ;
    if (execute_next)
	begin
        // commit the result
        if (!reset)
        begin
         data_out <= result ;

		if (dest_pc_regd) begin
			if (op_return_regd) begin
				jump_return <= 1'b1 ;
				jumping <= 1'b1 ;
				bubbles <= `NOPIPELINEBUBBLES ;
			end
			else begin
				jump_forward <= 1'b1 ;
				jumping <= 1'b1 ;
				bubbles <= `NOPIPELINEBUBBLES ;
			end
		end
        end

		// field_out is an extra pipeline stage, to speed up ALU operations by ~80ps
		dest_field_regd_2 <= dest_field_regd ;
		if (dest_field_regd_2 && !reset) begin
			field_out <= data_out ;
			if (low_high_buffer) field_write_en_high <= 1'b1 ;
			else field_write_en_low <= 1'b1 ;
		end
		else begin
			field_write_en_high <= 1'b0 ;
			field_write_en_low <= 1'b0 ;
		end

		if (dest_reg_regd && !reset) begin
		data_write <= 1'b1 ;
		end
		else data_write <= 1'b0 ;

		if (op_test) updateFlags() ;

		if (dest_out_regd)
		begin
			registerOutput() ;
		end

		if (op_setb_regd && !reset)
		begin
			bufp <= immediate_bufp_regd[2:0] ;
			low_high_buffer <= immediate_bufp_regd[3] ;
		end

	end

	end
end


endmodule


module program_counter(clk, reset, pc_out, jump_offset, jump_forward, jump_return, call) ;
parameter i_adr_width = 10 ;
`define PC_CALL_ADJUST 4 // how many instructions ahead of next instruction to be executed the PC is
input clk, reset ;
input [7:0] jump_offset ;
input jump_forward ;
input jump_return ;
input call ;

output [i_adr_width-1:0] pc_out ;
reg [i_adr_width-1:0] pc ; // program counter
reg [i_adr_width-1:0] pc_out ; // program counter copy to drive memory
reg [i_adr_width-1:0] lr ;

wire [i_adr_width-1:0] pcInc ;
wire [i_adr_width-1:0] pcAdd ;
wire [i_adr_width-1:0] pcSub ;

pc_inc pcIncr(pc, pcInc) ;
//pc_add pcAddr(pc, immediate_i8, pcAdd) ;
//pc_sub pcSubr(pc, immediate_i8, pcSub) ;
pc_add_signed pcAddrSigned(pc, jump_offset, pcAdd) ;

always @(posedge clk)
	begin
		if (reset) begin
             pc <= 0 ;
             pc_out <= 0 ;
         end
		else
		begin
			if (call) lr <= pc - `PC_CALL_ADJUST ; // TODO: Check value of call adjust
		        if (jump_forward) begin
			       pc <= pcAdd ;
			       pc_out <= pcAdd ;
		        end
			else if (jump_return) begin
				pc <= lr ;
				pc_out <= lr ;
			end
			else begin
				pc <= pcInc ;
				pc_out <= pcInc ;
			end
		end
	end


endmodule



module pc_inc(pc, pc_next) ;

parameter i_adr_width = 10 ;
input [i_adr_width-1:0] pc ;
output [i_adr_width-1:0] pc_next ;

assign pc_next = pc + 1 ;
endmodule

module pc_add(pc, offset, pc_next) ;
parameter i_adr_width = 10 ;
parameter d_width = 32 ;
input [i_adr_width-1:0] pc ;
input [d_width-1:0] offset ;
output [i_adr_width-1:0] pc_next ;

assign pc_next = pc + offset ;
endmodule

module pc_sub(pc, offset, pc_next) ;
parameter i_adr_width = 10 ;
parameter d_width = 32 ;
input [i_adr_width-1:0] pc ;
input [d_width-1:0] offset ;
output [i_adr_width-1:0] pc_next ;

assign pc_next = pc - offset ;
endmodule

module pc_add_signed(pc, offset, pc_next) ;
parameter i_adr_width = 10 ;
parameter d_width = 32 ;

input [i_adr_width-1:0] pc ;
input [d_width-1:0] offset ;
output [i_adr_width-1:0] pc_next ;

wire [i_adr_width-1:0] offset_extended ;

assign offset_extended = {{i_adr_width-d_width{offset[d_width-1]}}, offset} ;

assign pc_next = pc + offset_extended ;

endmodule

module shifter(a, b, y, op_shl, op_shlo, op_shr, op_shro) ;

parameter d_width = 32 ;

input [d_width-1:0] a ;
input [1:0] b ;
input op_shl, op_shlo, op_shr, op_shro ;

output [d_width-1:0] y ;

wire [d_width-1:0] shl ;
wire [d_width-1:0] shlo ;
wire [d_width-1:0] shr ;
wire [d_width-1:0] shro ;
//wire [d_width-1:0] asr ;

// Shift by 1--4
assign shl = a << (b+1) ;
assign shr = a >> (b+1) ;
//assign asr = a >>> (b+1) ;

assign shlo =
//	(b == 0) ? (a << 0) :
	(b == 0) ? (a << 1) | {1{1'b1}} :
	(b == 1) ? (a << 2) | {2{1'b1}} :
	(b == 2) ? (a << 3) | {3{1'b1}} :
	(a << 4) | {4{1'b1}} ;
//	(b == 5) ? (a << 5) | {5{1'b1}} :
//	(b == 6) ? (a << 6) | {6{1'b1}} :
//	(a << 7) | {7{1'b1}} ; // b == 7 case


assign shro =
	(b == 0) ? 8'b10000000 | (a >> 1) :
	(b == 1) ? 8'b11000000 | (a >> 2) :
	(b == 2) ? 8'b11100000 | (a >> 3) :
	           8'b11110000 | (a >> 4) ;

assign y = op_shl ? shl :
	   op_shr ? shr :
	   op_shlo ? shlo :
		shro ;

endmodule




module subtractor(a, b, y) ;
parameter d_width = 32 ;
input [d_width-1:0] a ;
input [d_width-1:0] b ;
output [d_width-1:0] y ;

assign y = a - b ;

endmodule

module adder(a, b, y) ;
parameter d_width = 32 ;
input [d_width-1:0] a ;
input [d_width-1:0] b ;
output [d_width-1:0] y ;

assign y = a + b ;

endmodule

module orer(a, b, y) ;
parameter d_width = 32 ;
input [d_width-1:0] a ;
input [d_width-1:0] b ;
output [d_width-1:0] y ;

assign y = a | b ;
endmodule

module ander(a, b, y) ;
parameter d_width = 32 ;
input [d_width-1:0] a ;
input [d_width-1:0] b ;
output [d_width-1:0] y ;

assign y = a & b ;
endmodule

module negator(a, y) ;
parameter d_width = 32 ;
input [d_width-1:0] a ;
output [d_width-1:0] y ;

assign y = ~a ;

endmodule

module alu(a, b, y, op_or, op_and, op_not, op_add, op_sub, op_addsub, op_shl, op_shlo, op_shr, op_shro) ;

parameter d_width = 32 ;

input  [d_width-1:0] a ;
input [d_width-1:0] b ;
input op_or, op_and, op_not ;
input op_add, op_sub, op_addsub ;
input op_shl, op_shlo, op_shr, op_shro ;

output [d_width-1:0] y ;

wire [d_width-1:0] shift_out ;
wire [d_width-1:0] add_out ;
wire [d_width-1:0] sub_out ;
wire [d_width-1:0] neg_out ;
wire [d_width-1:0] and_out ;
wire [d_width-1:0] or_out ;

shifter theShifter(a, b[1:0], shift_out, op_shl, op_shlo, op_shr, op_shro) ;
adder theAdder(a, b, add_out) ;
subtractor theSub(a, b, sub_out) ;
orer theOR(a, b, or_out) ;
ander theAND(a, b, and_out) ;
negator theNeg(a, neg_out) ;

// enhancement from Introduction to Logic Synthesis Using Verilog HDL
// By Robert Bryan Reese, Mitchell Aaron Thornton
// seems to be quicker than my solution //TODO: see if still true
wire [d_width-1:0] addsubi ;
wire [d_width-1:0] addsubout ;
assign addsubi = op_sub ? ~b : b ;
assign addsubout = a + addsubi + {{d_width-1{1'b0}}, op_sub} ;

//assign y = op_or ? or_out :
//or_out   op_and ? and_out :
//and_out   op_not ? neg_out :
//neg_out   op_add ? add_out :
//add_out   op_sub ? sub_out :
////sub_out   op_addsub ? addsubout :
//addsubout   shift_out ; // any of the three shifts

assign y =
	   op_and ? and_out :
	   op_or  ? or_out :
	   op_not ? neg_out :
//	   op_addsub ? addsubout :
	   op_add ? add_out :
	   op_sub ? sub_out : shift_out ;

//assign y = op_addsub ? addsubout :
//            op_or ? a | b :
//            op_and ? a & b :
//            op_not ? ~a :
//            shift_out ;



endmodule

module data_mem(clk, data_read_adr, data_write_adr, data_write, data_in, data_out) ;
parameter d_adr_width = 3 ; // data address space size
parameter d_width = 32 ; // data width
parameter dmemsize = 8 ;

input clk ;
input [d_adr_width-1:0] data_read_adr ;
input [d_adr_width-1:0] data_write_adr ;
input [d_width-1:0] data_in ;
input data_write ;

output [d_width-1:0] data_out ;

reg [d_width-1:0] dmem [dmemsize] ;


assign data_out = dmem[data_read_adr] ;
always @(posedge clk) begin
	if (data_write)
		dmem[data_write_adr] <= data_in ;
	end


// read decoder
/*genvar i,j ;
wire [d_width-1:0] read_bus [dmemsize] ;

for (i = 0 ; i < dmemsize ; i++)
begin
	assign read_bus[i] = (data_read_adr == i) ? dmem[i] : {d_width{1'b0}} ;
end

wire [dmemsize-1:0] read_bus_transformed [d_width] ;

for (i = 0 ; i < d_width ; i++)
begin
	for (j = 0 ; j < dmemsize ; j++)
	begin
		assign read_bus_transformed[i][j] = read_bus[j][i] ;
	end
	assign data_out[i] = | read_bus_transformed[i] ;
end
*/

/*
// write
always @(data_write or data_write_adr or data_in)
begin
	if (data_write) begin
	dmem[data_write_adr] <= data_in ;
	end
end
*/
/*
wire write_enable [dmemsize] ;
 write decoder
for (i = 0 ; i < dmemsize ; i++)
begin
	assign write_enable[i] = (data_write && data_write_adr == i)  ;
end


for (i = 0 ; i < dmemsize ; i++)
begin
always @(posedge clk)
	if (write_enable[i]) dmem[i] <= data_in ;
end
*/




endmodule

// Level sensitive write signal; not registered
module inst_mem (imem_read_adr, imem_write_adr, imem_write, imem_in, imem_out) ;

parameter i_buffer_size = 2 ;
parameter i_mem_size = 512 ;
parameter i_mem_lines =  256 ; //imem_size / i_buffer_size ;
parameter i_adr_width = 10 ; // instruction address space size
parameter i_width = 23 ; // instruction width

input [i_adr_width-1:0] imem_read_adr ;
input [i_adr_width-1:0] imem_write_adr ;
input imem_write ;
input [(i_buffer_size*i_width)-1:0] imem_in ;

output [(i_buffer_size*i_width)-1:0] imem_out ;

reg [(i_buffer_size*i_width)-1:0] imem [i_mem_lines] ;

assign imem_out = imem[imem_read_adr] ;

always @(imem_write or imem_write_adr or imem_in)
begin
	if (imem_write) imem[imem_write_adr] <= imem_in ;
end
/*
genvar i,j ;
read decoder
tri [i_adr_width-1:0] imem_out ;
for (i = 0 ; i < i_mem_size ; i++)
begin
	assign imem_out = (imem_read_adr == i) ? imem[i] : {i_width{1'bz}} ;
end
*/
/*
wire [i_mems_size-1:0] read_bus_transformed [i_width] ;

for (i = 0 ; i < i_width ; i++)
begin
	for (j = 0 ; j < i_mem_size ; j++)
	begin
		assign read_bus_transformed[i][j] = read_bus[j][i] ;
	end
	assign imem_out[i] = | read_bus_transformed[i] ;
end
*/


endmodule

module instruction_buffer(clk, reset, instruction_address, instruction_out, imem_write_adr, imem_write, imem_in, jump) ;

parameter i_buffer_size = 2 ;
parameter i_mem_adr_start_bit = 1 ; // first address bit of significance for imem
parameter i_adr_width = 10 ;
parameter i_width = 23 ; // instruction width


input clk, reset ;
input [i_adr_width-1:0] instruction_address ;
input [i_adr_width-1:0] imem_write_adr ;
input imem_write ;
input [(i_buffer_size*i_width)-1:0] imem_in ;
input jump ;

output [i_width-1:0] instruction_out ;
reg [i_width-1:0] instruction_out ;


reg [i_adr_width-1:0] imem_read_adr ;
wire [(i_buffer_size*i_width)-1:0] imem_out ;

reg [i_width-1:0] i_buffer [i_buffer_size] ;
reg [1:0] jump_bubble ;

inst_mem iMem(imem_read_adr, imem_write_adr, imem_write, imem_in, imem_out) ;

assign imem_read_adr = instruction_address[i_adr_width-1:i_mem_adr_start_bit] ;

//wire jump_int ;
//assign jump_int = (instruction_out[11:8] == 4'b1000) ;

/* Mechanism
/  If the PC shows an even number, go and fetch that instruction line from memory.
/  Then, load both into the instruction buffer
/  and MUX the next instruction out of this.
*/
always @(posedge clk)
begin
	if (reset)
	begin
		i_buffer[0] <= `INSTR_NOP ;
		i_buffer[1] <= `INSTR_NOP ;
		instruction_out <= `INSTR_NOP ;
		jump_bubble <= 1 ;
	end

	else if (jump)
	begin
		instruction_out <= `INSTR_NOP ;
		jump_bubble <= 2 ;
	end

	else if (jump_bubble > 0)
	begin
		instruction_out <= `INSTR_NOP ;
		jump_bubble <= jump_bubble - 1 ;
	end

	else
	begin
		instruction_out <= instruction_address[0] ?
			i_buffer[0] : i_buffer[1] ;
	end

	if (instruction_address[0] == 0)
	begin
		i_buffer[0] <=  imem_out[(i_width-1):0] ;
		i_buffer[1] <= 	imem_out[((i_width*2)-1):i_width] ;
	end
end

endmodule
