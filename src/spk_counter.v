`default_nettype none
`timescale 1ns/1ns

module spk_counter #(
    parameter NUM = 8
)(
    input       [NUM-1 :0]    fan_in,
    output reg  [7     :0]    counter // TODO: why reg?
    );

    integer i;

    always @ (fan_in)
    begin
        counter = 0;  //initialize count variable.
        for(i = 0; i < NUM; i = i + 1)   //for all the bits.
            counter = counter + fan_in[i]; //Add the bit to the count.
    end

endmodule