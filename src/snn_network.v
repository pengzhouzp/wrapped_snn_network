`default_nettype none
`timescale 1ns/1ns

module snn_network #(
    parameter NUM_IN = 16,
    parameter NUM_HIDDEN = 64,
    parameter NUM_OUT = 8
)(
`ifdef USE_POWER_PINS
	inout vccd1,	// User area 1 1.8V power
	input vssd1,	// User area 1 digital ground
`endif
    input   wire                    clk,
    input   wire                    reset,
    input   wire  [15        :0]    in_signal,
    output  wire  [NUM_OUT-1 :0]    out_spk,
    output  wire  [NUM_OUT-1 :0]    io_oeb
);

    assign io_oeb = {(NUM_OUT-1){1'b0}};

    wire [NUM_IN     -1:0]   inp_spk;
    wire [NUM_HIDDEN -1:0]   hid_spk;

    genvar i;
    generate
        for (i = 0; i < NUM_IN; i = i + 1) begin
            input_neuron #(
                .ori_thr(64),
                .decay_shift_cur(2),
                .decay_shift_mem(2),
                .decay_shift_thr(2),
                .adp_thr(2)) 
            in0 (.clk(clk), .reset(reset), .syn(in_signal[i]), .spk(inp_spk[i]));
        end

        for (i = NUM_IN; i < NUM_IN+NUM_HIDDEN; i = i + 1) begin
            hidden_neuron #(
                .NUM_FAN_IN(NUM_IN),
                .NUM_REC_IN(NUM_HIDDEN),
                .ori_thr(64),
                .decay_shift_cur(2),
                .decay_shift_mem(2),
                .decay_shift_thr(2),
                .adp_thr(2)) 
            hid0 (.clk(clk), .reset(reset), .fan_in(inp_spk), .rec_spk(hid_spk), .spk(hid_spk[i-NUM_IN]));
        end

        for (i = NUM_IN+NUM_HIDDEN; i < NUM_IN+NUM_HIDDEN+NUM_OUT; i = i + 1) begin
            output_neuron #(
                .NUM_FAN_IN(NUM_HIDDEN),
                .ori_thr(64),
                .decay_shift_cur(2),
                .decay_shift_mem(2),
                .decay_shift_thr(2),
                .adp_thr(2)) 
            out0 (.clk(clk), .reset(reset), .fan_in(hid_spk), .spk(out_spk[i-NUM_IN-NUM_HIDDEN]));
        end

    endgenerate

    // output_neuron #(S
    //     .NUM_FAN_IN(NUM_HIDDEN),
    //     .ori_thr(32),
    //     .decay_shift_cur(2),
    //     .decay_shift_mem(2),
    //     .decay_shift_thr(2),
    //     .adp_thr(2)) 
    // out0 (.clk(clk), .reset(reset), .fan_in(hid_spk), .spk(out_spk[0]));

    // output_neuron #(
    //     .NUM_FAN_IN(NUM_HIDDEN),
    //     .ori_thr(32),
    //     .decay_shift_cur(2),
    //     .decay_shift_mem(2),
    //     .decay_shift_thr(2),
    //     .adp_thr(2)) 
    // out1 (.clk(clk), .reset(reset), .fan_in(hid_spk), .spk(out_spk[1]));

endmodule
