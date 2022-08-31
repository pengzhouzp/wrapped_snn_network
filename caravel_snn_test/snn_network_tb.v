module snn_network_tb;

	initial begin
        $dumpfile ("snn_network.vcd");
        $dumpvars (0, snn_network_tb);
        #1;
    end		

	reg clk;
	reg RSTB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;
	// IO Pads
    
	// .state1(io_out[25:18]),
    // .io_oeb(io_oeb[25:16])

	///// convenience signals that match what the cocotb test modules are looking for
    // change to suit your project. Here's how we can make some nicer named signals for inputs & outputs

	wire [7  :0]  out_spk;
	wire [15 :0]  in_signal;
	wire reset;

	assign out_spk = mprj_io[31:24];

	assign mprj_io [23:8] = in_signal;
	assign mprj_io [32] = reset;

	//////
	//////

	wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;

    wire VDD3V3 = power1;
    wire VDD1V8 = power2;
    wire USER_VDD3V3 = power3;
    wire USER_VDD1V8 = power4;
    wire VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clk),  // ?
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("snn_network.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire