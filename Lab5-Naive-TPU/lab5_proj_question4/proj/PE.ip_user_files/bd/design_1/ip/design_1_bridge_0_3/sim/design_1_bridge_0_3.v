// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:bridge:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_bridge_0_3 (
  clk,
  arst_n,
  f0_addr,
  f0_clk,
  f0_wrdata,
  f0_rddata,
  f0_en,
  f0_rst,
  f0_we,
  f1_addr,
  f1_clk,
  f1_wrdata,
  f1_rddata,
  f1_en,
  f1_rst,
  f1_we,
  w0_addr,
  w0_clk,
  w0_wrdata,
  w0_rddata,
  w0_en,
  w0_rst,
  w0_we,
  w1_addr,
  w1_clk,
  w1_wrdata,
  w1_rddata,
  w1_en,
  w1_rst,
  w1_we,
  ot_addr,
  ot_clk,
  ot_wrdata,
  ot_rddata,
  ot_en,
  ot_rst,
  ot_we,
  com_addr,
  com_clk,
  com_wrdata,
  com_rddata,
  com_en,
  com_rst,
  com_we
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 1e+08, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
input wire arst_n;
output wire [31 : 0] f0_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME f0_clk, ASSOCIATED_RESET f0_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_f0_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 f0_clk CLK" *)
output wire f0_clk;
output wire [31 : 0] f0_wrdata;
input wire [31 : 0] f0_rddata;
output wire f0_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME f0_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 f0_rst RST" *)
output wire f0_rst;
output wire [3 : 0] f0_we;
output wire [31 : 0] f1_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME f1_clk, ASSOCIATED_RESET f1_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_f1_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 f1_clk CLK" *)
output wire f1_clk;
output wire [31 : 0] f1_wrdata;
input wire [31 : 0] f1_rddata;
output wire f1_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME f1_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 f1_rst RST" *)
output wire f1_rst;
output wire [3 : 0] f1_we;
output wire [31 : 0] w0_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME w0_clk, ASSOCIATED_RESET w0_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_w0_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 w0_clk CLK" *)
output wire w0_clk;
output wire [31 : 0] w0_wrdata;
input wire [31 : 0] w0_rddata;
output wire w0_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME w0_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 w0_rst RST" *)
output wire w0_rst;
output wire [3 : 0] w0_we;
output wire [31 : 0] w1_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME w1_clk, ASSOCIATED_RESET w1_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_w1_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 w1_clk CLK" *)
output wire w1_clk;
output wire [31 : 0] w1_wrdata;
input wire [31 : 0] w1_rddata;
output wire w1_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME w1_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 w1_rst RST" *)
output wire w1_rst;
output wire [3 : 0] w1_we;
output wire [31 : 0] ot_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ot_clk, ASSOCIATED_RESET ot_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_ot_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 ot_clk CLK" *)
output wire ot_clk;
output wire [31 : 0] ot_wrdata;
input wire [31 : 0] ot_rddata;
output wire ot_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME ot_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 ot_rst RST" *)
output wire ot_rst;
output wire [3 : 0] ot_we;
output wire [31 : 0] com_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME com_clk, ASSOCIATED_RESET com_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_bridge_0_3_com_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 com_clk CLK" *)
output wire com_clk;
output wire [31 : 0] com_wrdata;
input wire [31 : 0] com_rddata;
output wire com_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME com_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 com_rst RST" *)
output wire com_rst;
output wire [3 : 0] com_we;

  bridge inst (
    .clk(clk),
    .arst_n(arst_n),
    .f0_addr(f0_addr),
    .f0_clk(f0_clk),
    .f0_wrdata(f0_wrdata),
    .f0_rddata(f0_rddata),
    .f0_en(f0_en),
    .f0_rst(f0_rst),
    .f0_we(f0_we),
    .f1_addr(f1_addr),
    .f1_clk(f1_clk),
    .f1_wrdata(f1_wrdata),
    .f1_rddata(f1_rddata),
    .f1_en(f1_en),
    .f1_rst(f1_rst),
    .f1_we(f1_we),
    .w0_addr(w0_addr),
    .w0_clk(w0_clk),
    .w0_wrdata(w0_wrdata),
    .w0_rddata(w0_rddata),
    .w0_en(w0_en),
    .w0_rst(w0_rst),
    .w0_we(w0_we),
    .w1_addr(w1_addr),
    .w1_clk(w1_clk),
    .w1_wrdata(w1_wrdata),
    .w1_rddata(w1_rddata),
    .w1_en(w1_en),
    .w1_rst(w1_rst),
    .w1_we(w1_we),
    .ot_addr(ot_addr),
    .ot_clk(ot_clk),
    .ot_wrdata(ot_wrdata),
    .ot_rddata(ot_rddata),
    .ot_en(ot_en),
    .ot_rst(ot_rst),
    .ot_we(ot_we),
    .com_addr(com_addr),
    .com_clk(com_clk),
    .com_wrdata(com_wrdata),
    .com_rddata(com_rddata),
    .com_en(com_en),
    .com_rst(com_rst),
    .com_we(com_we)
  );
endmodule
