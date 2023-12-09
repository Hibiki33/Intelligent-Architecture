module arstn2rst (
    input clk,    // Clock
    input arst_n,  // Asynchronous reset active low
    output rst
);

wire temp_rst;

xpm_cdc_async_rst #(
  .DEST_SYNC_FF(4),    // DECIMAL; range: 2-10
  .INIT_SYNC_FF(0),    // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
  .RST_ACTIVE_HIGH(0)  // DECIMAL; 0=active low reset, 1=active high reset
)
xpm_cdc_async_rst_inst (
  .dest_arst(temp_rst), // 1-bit output: src_arst asynchronous reset signal synchronized to destination
                         // clock domain. This output is registered. NOTE: Signal asserts asynchronously
                         // but deasserts synchronously to dest_clk. Width of the reset signal is at least
                         // (DEST_SYNC_FF*dest_clk) period.

  .dest_clk(clk),   // 1-bit input: Destination clock.
  .src_arst(~arst_n)    // 1-bit input: Source asynchronous reset signal.
);

BUFG U_BUFG(
  .I(temp_rst),
  .O(rst)
  );

endmodule