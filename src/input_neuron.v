`default_nettype none
`timescale 1ns/1ns

module input_neuron #(
    parameter ori_thr = 32,
    parameter decay_shift_cur = 2,
    parameter decay_shift_mem = 2,
    parameter decay_shift_thr = 2,
    parameter adp_thr = 2
)(
    input wire      clk,
    input wire      reset,
    input wire      syn,
    output reg      spk
);
    reg     [7:0] cur;
    reg     [7:0] mem;
    reg     [7:0] thr;
    wire    [7:0] cur_his;
    wire    [7:0] mem_his;
    wire    [7:0] thr_his;

    // TODO: weight in register array
    assign cur_his = syn + (cur - cur >> decay_shift_cur);
    assign mem_his = cur + (spk ? 0 : mem - mem >> decay_shift_mem);
    assign thr_his = thr + (spk ? adp_thr : 0) - (thr - ori_thr) >> decay_shift_thr;

    always @ (posedge clk) begin
 	    if (reset) begin
            cur <= 0;
            mem <= 0;
            spk <= 0;
            thr <= ori_thr;
        end else begin
            cur <= cur_his;
            mem <= mem_his;
            spk <= (mem >= thr);
            thr <= thr_his;
        end
    end

endmodule
