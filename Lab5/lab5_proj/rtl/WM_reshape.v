`include "define.v"

module WM_reshape(
    input clk,
    input rst,
    // connect BRAM_WM32
    output reg [31:0] BRAM_WM32_addr,
    output BRAM_WM32_clk, // clk
    output [31:0] BRAM_WM32_wrdata, // 'b0
    input [31:0] BRAM_WM32_rddata,
    output BRAM_WM32_en, // 1'b1
    output BRAM_WM32_rst, // rst
    output [3:0] BRAM_WM32_we, // 'b0
    // connect CTRL
    input [15:0] P,
    input [15:0] N,
    input reshape_start,
    output reg WM_reshape_finish, // 电平信号
    // connect BRAM_WM128
    output reg [15:0] BRAM_WM128_waddr,
    output reg [127:0] BRAM_WM128_wrdata,
    output reg BRAM_WM128_we
    );

reg [15:0] cycle1;
reg [15:0] cycle2;
reg [15:0] cycle1_cnt;
reg [15:0] cycle2_cnt;

assign BRAM_WM32_clk = clk;
assign BRAM_WM32_wrdata = 'b0;
assign BRAM_WM32_en = 1'b1;
assign BRAM_WM32_rst = rst;
assign BRAM_WM32_we = 'b0;

localparam IDLE   = 4'b0001;
localparam COM    = 4'b0010;
localparam WORK   = 4'b0100;
localparam FINISH = 4'b1000;

reg [3:0] c_state;
reg [3:0] n_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_state <= IDLE;
    end
    else begin
        c_state <= n_state;
    end
end

always @(*) begin
    case(c_state)
    IDLE: begin
        if (reshape_start)
            n_state = COM;
        else
            n_state = c_state;
    end
    COM: begin
        n_state = WORK;
    end
    WORK: begin
        if ((cycle1_cnt==cycle1-1'b1)&&(cycle2_cnt==cycle2-1'b1))
            n_state = FINISH;
        else
            n_state = c_state;
    end
    FINISH: begin
        n_state = IDLE;
    end
    default: n_state = IDLE;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cycle1 <= 'b0;
        cycle2 <= 'b0;
    end
    else if (c_state==COM) begin
        cycle1 <= ((P-1)>>2)+1;
        cycle2 <= N;
    end
    else begin
        cycle1 <= cycle1;
        cycle2 <= cycle2;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cycle1_cnt <= 'b0;
    end
    else if (c_state==COM) begin
        cycle1_cnt <= 'b0;
    end
    else if (c_state==WORK) begin
        if (cycle1_cnt==cycle1-1'b1)
            cycle1_cnt <= 'b0;
        else
            cycle1_cnt <= cycle1_cnt + 1'b1;
    end
    else begin
        cycle1_cnt <= cycle1_cnt;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cycle2_cnt <= 'b0;
    end
    else if (c_state==COM) begin
        cycle2_cnt <= 'b0;
    end
    else if (c_state==WORK) begin
        if (cycle1_cnt==cycle1-1'b1)
            cycle2_cnt <= cycle2_cnt + 1'b1;
        else
            cycle2_cnt <= cycle2_cnt;
    end
    else begin
        cycle2_cnt <= cycle2_cnt;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_WM32_addr <= 'b0;
    end
    else if (n_state==COM) begin
        BRAM_WM32_addr <= `SADDR_W_MEM;
    end
    else if (n_state==WORK) begin
        BRAM_WM32_addr <= BRAM_WM32_addr + `W_MEM_INCR;
    end
    else begin
        BRAM_WM32_addr <= BRAM_WM32_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_WM128_waddr <= 'b0;
    end
    else if (c_state==COM) begin
        BRAM_WM128_waddr <= 'b0 - 1'b1;
    end
    else if ((c_state==WORK)&&((cycle1_cnt==cycle1-1'b1)||(cycle1_cnt[1:0]==2'b11))) begin
        BRAM_WM128_waddr <= BRAM_WM128_waddr + 1'b1;
    end
    else begin
        BRAM_WM128_waddr <= BRAM_WM128_waddr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_WM128_wrdata <= 'b0;
    end
    else if (c_state==WORK) begin
        case(cycle1_cnt[1:0])
        2'b11: BRAM_WM128_wrdata <= {BRAM_WM32_rddata,BRAM_WM128_wrdata[95:0]};
        2'b10: BRAM_WM128_wrdata <= {32'b0,BRAM_WM32_rddata,BRAM_WM128_wrdata[63:0]};
        2'b01: BRAM_WM128_wrdata <= {64'b0,BRAM_WM32_rddata,BRAM_WM128_wrdata[31:0]};
        2'b00: BRAM_WM128_wrdata <= {96'b0,BRAM_WM32_rddata};
        default: BRAM_WM128_wrdata <= BRAM_WM128_wrdata;
        endcase
    end
    else begin
        BRAM_WM128_wrdata <= BRAM_WM128_wrdata;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_WM128_we <= 'b0;
    end
    else if ((c_state==WORK)&&((cycle1_cnt==cycle1-1'b1)||(cycle1_cnt[1:0]==2'b11))) begin
        BRAM_WM128_we <= 1'b1;
    end
    else begin
        BRAM_WM128_we <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        WM_reshape_finish <= 'b0;
    end
    else if (reshape_start) begin
        WM_reshape_finish <= 'b0;
    end
    else if (c_state==FINISH) begin
        WM_reshape_finish <= 1'b1;
    end
    else begin
        WM_reshape_finish <= WM_reshape_finish;
    end
end

endmodule