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


// IP VLNV: xilinx.com:module_ref:MM_TOP:1.0
// IP Revision: 1

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_MM_TOP_0_0 (
  clk,
  arst_n,
  BRAM_FM32_addr,
  BRAM_FM32_clk,
  BRAM_FM32_wrdata,
  BRAM_FM32_rddata,
  BRAM_FM32_en,
  BRAM_FM32_rst,
  BRAM_FM32_we,
  BRAM_WM32_addr,
  BRAM_WM32_clk,
  BRAM_WM32_wrdata,
  BRAM_WM32_rddata,
  BRAM_WM32_en,
  BRAM_WM32_rst,
  BRAM_WM32_we,
  BRAM_CTRL_addr,
  BRAM_CTRL_clk,
  BRAM_CTRL_wrdata,
  BRAM_CTRL_rddata,
  BRAM_CTRL_en,
  BRAM_CTRL_rst,
  BRAM_CTRL_we,
  BRAM_OUT_addr,
  BRAM_OUT_clk,
  BRAM_OUT_wrdata,
  BRAM_OUT_rddata,
  BRAM_OUT_en,
  BRAM_OUT_rst,
  BRAM_OUT_we
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
input wire arst_n;
output wire [31 : 0] BRAM_FM32_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_FM32_clk, ASSOCIATED_RESET BRAM_FM32_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_MM_TOP_0_0_BRAM_FM32_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 BRAM_FM32_clk CLK" *)
output wire BRAM_FM32_clk;
output wire [31 : 0] BRAM_FM32_wrdata;
input wire [31 : 0] BRAM_FM32_rddata;
output wire BRAM_FM32_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_FM32_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 BRAM_FM32_rst RST" *)
output wire BRAM_FM32_rst;
output wire [3 : 0] BRAM_FM32_we;
output wire [31 : 0] BRAM_WM32_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_WM32_clk, ASSOCIATED_RESET BRAM_WM32_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_MM_TOP_0_0_BRAM_WM32_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 BRAM_WM32_clk CLK" *)
output wire BRAM_WM32_clk;
output wire [31 : 0] BRAM_WM32_wrdata;
input wire [31 : 0] BRAM_WM32_rddata;
output wire BRAM_WM32_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_WM32_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 BRAM_WM32_rst RST" *)
output wire BRAM_WM32_rst;
output wire [3 : 0] BRAM_WM32_we;
output wire [31 : 0] BRAM_CTRL_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_CTRL_clk, ASSOCIATED_RESET BRAM_CTRL_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_MM_TOP_0_0_BRAM_CTRL_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 BRAM_CTRL_clk CLK" *)
output wire BRAM_CTRL_clk;
output wire [31 : 0] BRAM_CTRL_wrdata;
input wire [31 : 0] BRAM_CTRL_rddata;
output wire BRAM_CTRL_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_CTRL_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 BRAM_CTRL_rst RST" *)
output wire BRAM_CTRL_rst;
output wire [3 : 0] BRAM_CTRL_we;
output wire [31 : 0] BRAM_OUT_addr;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_OUT_clk, ASSOCIATED_RESET BRAM_OUT_rst, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN design_1_MM_TOP_0_0_BRAM_OUT_clk, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 BRAM_OUT_clk CLK" *)
output wire BRAM_OUT_clk;
output wire [31 : 0] BRAM_OUT_wrdata;
input wire [31 : 0] BRAM_OUT_rddata;
output wire BRAM_OUT_en;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME BRAM_OUT_rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 BRAM_OUT_rst RST" *)
output wire BRAM_OUT_rst;
output wire [3 : 0] BRAM_OUT_we;

  MM_TOP inst (
    .clk(clk),
    .arst_n(arst_n),
    .BRAM_FM32_addr(BRAM_FM32_addr),
    .BRAM_FM32_clk(BRAM_FM32_clk),
    .BRAM_FM32_wrdata(BRAM_FM32_wrdata),
    .BRAM_FM32_rddata(BRAM_FM32_rddata),
    .BRAM_FM32_en(BRAM_FM32_en),
    .BRAM_FM32_rst(BRAM_FM32_rst),
    .BRAM_FM32_we(BRAM_FM32_we),
    .BRAM_WM32_addr(BRAM_WM32_addr),
    .BRAM_WM32_clk(BRAM_WM32_clk),
    .BRAM_WM32_wrdata(BRAM_WM32_wrdata),
    .BRAM_WM32_rddata(BRAM_WM32_rddata),
    .BRAM_WM32_en(BRAM_WM32_en),
    .BRAM_WM32_rst(BRAM_WM32_rst),
    .BRAM_WM32_we(BRAM_WM32_we),
    .BRAM_CTRL_addr(BRAM_CTRL_addr),
    .BRAM_CTRL_clk(BRAM_CTRL_clk),
    .BRAM_CTRL_wrdata(BRAM_CTRL_wrdata),
    .BRAM_CTRL_rddata(BRAM_CTRL_rddata),
    .BRAM_CTRL_en(BRAM_CTRL_en),
    .BRAM_CTRL_rst(BRAM_CTRL_rst),
    .BRAM_CTRL_we(BRAM_CTRL_we),
    .BRAM_OUT_addr(BRAM_OUT_addr),
    .BRAM_OUT_clk(BRAM_OUT_clk),
    .BRAM_OUT_wrdata(BRAM_OUT_wrdata),
    .BRAM_OUT_rddata(BRAM_OUT_rddata),
    .BRAM_OUT_en(BRAM_OUT_en),
    .BRAM_OUT_rst(BRAM_OUT_rst),
    .BRAM_OUT_we(BRAM_OUT_we)
  );
endmodule
