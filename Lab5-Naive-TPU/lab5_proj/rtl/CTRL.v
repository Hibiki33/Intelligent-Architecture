`include "define.v"

module CTRL(
    input clk, 
    (*mark_debug = "true"*) input rst, 
    // connect BRAM_CTRL
    (*mark_debug = "true"*) output reg [31:0] BRAM_CTRL_addr,
    output BRAM_CTRL_clk, // clk
    (*mark_debug = "true"*) output reg [31:0] BRAM_CTRL_wrdata,
    (*mark_debug = "true"*) input [31:0] BRAM_CTRL_rddata,
    (*mark_debug = "true"*) output BRAM_CTRL_en, // 1'b1
    (*mark_debug = "true"*) output BRAM_CTRL_rst, // rst
    (*mark_debug = "true"*) output reg [3:0] BRAM_CTRL_we,
    // connect FM_reshape&WM_reshape
    (*mark_debug = "true"*) output reg [15:0] M,
    (*mark_debug = "true"*) output reg [15:0] N,
    (*mark_debug = "true"*) output reg [15:0] P,
    (*mark_debug = "true"*) output reg reshape_start,
    (*mark_debug = "true"*) input FM_reshape_finish, // 电平信号
    (*mark_debug = "true"*) input WM_reshape_finish, // 电平信号
    // connect Multiply_ctrl
    (*mark_debug = "true"*) output reg [7:0] sub_P, // 本次计算子矩阵结果的大小
    (*mark_debug = "true"*) output reg [7:0] sub_M, // 本次计算子矩阵结果的大小
    (*mark_debug = "true"*) output reg [15:0] subFM_addr,
    (*mark_debug = "true"*) output reg [15:0] subFM_incr,
    (*mark_debug = "true"*) output reg [15:0] subWM_addr,
    (*mark_debug = "true"*) output reg [15:0] subWM_incr,
    (*mark_debug = "true"*) output reg submulti_start,
    (*mark_debug = "true"*) input submulti_finish, // 脉冲信号
    // connect Out_ctrl
    (*mark_debug = "true"*) output reg [15:0] Ma,
    (*mark_debug = "true"*) output reg [15:0] Pa,
    (*mark_debug = "true"*) output reg out_start,
    (*mark_debug = "true"*) input out_finish // 脉冲信号
);

assign BRAM_CTRL_clk = clk;
assign BRAM_CTRL_en = 1'b1;
assign BRAM_CTRL_rst = rst;

reg [15:0] subFM_addr_pre;
reg [15:0] subWM_addr_pre;

reg [15:0] sub_P_cnt;
reg [15:0] sub_M_cnt;
reg [31:0] BRAM_CTRL_addr_f1;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_CTRL_addr_f1 <= 32'b0;
    end
    else begin
        BRAM_CTRL_addr_f1 <= BRAM_CTRL_addr;
    end
end

localparam IDLE          = 12'b0000_0000_0001;
localparam GET_COMMAND1  = 12'b0000_0000_0010;
localparam GET_COMMAND2  = 12'b0000_0000_0100;
localparam INFO_RESHAPE  = 12'b0000_0000_1000;
localparam WAIT_RESHAPE  = 12'b0000_0001_0000;
localparam COM_SUBADDR   = 12'b0000_0010_0000;
localparam INFO_MULTIPLY = 12'b0000_0100_0000;
localparam WAIT_MULTIPLY = 12'b0000_1000_0000;
localparam INFO_OUT      = 12'b0001_0000_0000;
localparam WAIT_OUT      = 12'b0010_0000_0000;
localparam JUDGE_FINISH  = 12'b0100_0000_0000;
localparam FINISH        = 12'b1000_0000_0000;

reg [11:0] c_state;
reg [11:0] n_state;

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
        if (BRAM_CTRL_addr_f1==`ADDR_FLAG&&BRAM_CTRL_rddata==`FLAG_START)
            n_state = GET_COMMAND1;
        else
            n_state = c_state;
    end
    GET_COMMAND1: begin
        if (BRAM_CTRL_addr_f1==`ADDR_COM1&&(BRAM_CTRL_rddata[15:0]==16'b0||BRAM_CTRL_rddata[31:16]==16'b0))
            n_state = FINISH;
        else if (BRAM_CTRL_addr_f1==`ADDR_COM1)
            n_state = GET_COMMAND2;
        else
            n_state = c_state;
    end
    GET_COMMAND2: begin
        if (BRAM_CTRL_addr_f1==`ADDR_COM2&&BRAM_CTRL_rddata[15:0]==16'b0)
            n_state = FINISH;
        else if (BRAM_CTRL_addr_f1==`ADDR_COM2)
            n_state = INFO_RESHAPE;
        else
            n_state = c_state;
    end
    INFO_RESHAPE: begin
        n_state = WAIT_RESHAPE;
    end
    WAIT_RESHAPE: begin
        if (FM_reshape_finish&WM_reshape_finish)
            n_state = COM_SUBADDR;
        else
            n_state = c_state;
    end
    COM_SUBADDR: begin
        n_state = INFO_MULTIPLY;
    end
    INFO_MULTIPLY: begin
        n_state = WAIT_MULTIPLY;
    end
    WAIT_MULTIPLY: begin
        if (submulti_finish)
            n_state = INFO_OUT;
        else
            n_state = c_state;
    end
    INFO_OUT: begin
        n_state = WAIT_OUT;
    end
    WAIT_OUT: begin
        if (out_finish)
            n_state = JUDGE_FINISH;
        else
            n_state = c_state;
    end
    JUDGE_FINISH: begin
        if ((Ma + 'd8 >= M)&&(Pa + 'd16 >= P))
            n_state = FINISH;
        else
            n_state = COM_SUBADDR;
    end
    FINISH: begin
        n_state = IDLE;
    end
    default: n_state = IDLE;
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_CTRL_addr <= 'b0;
    end
    else if (n_state==IDLE) begin
        BRAM_CTRL_addr <= `ADDR_FLAG;
    end
    else if (n_state==GET_COMMAND1) begin
        BRAM_CTRL_addr <= `ADDR_COM1;
    end
    else if (n_state==GET_COMMAND2) begin
        BRAM_CTRL_addr <= `ADDR_COM2;
    end
    else if (n_state==FINISH) begin
        BRAM_CTRL_addr <= `ADDR_FLAG;
    end
    else begin
        BRAM_CTRL_addr <= BRAM_CTRL_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_CTRL_we <= 'b0;
        BRAM_CTRL_wrdata <= 'b0;
    end
    else if (n_state==FINISH) begin
        BRAM_CTRL_we <= 4'hf;
        BRAM_CTRL_wrdata <= `FLAG_FINISH;
    end
    else begin
        BRAM_CTRL_we <= 'b0;
        BRAM_CTRL_wrdata <= BRAM_CTRL_wrdata;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        M <= 'b0;
    end
    else if (c_state==GET_COMMAND1) begin
        M <= BRAM_CTRL_rddata[15:0];
    end
    else begin
        M <= M;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        P <= 'b0;
    end
    else if (c_state==GET_COMMAND1) begin
        P <= BRAM_CTRL_rddata[31:16];
    end
    else begin
        P <= P;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        N <= 'b0;
    end
    else if (c_state==GET_COMMAND2) begin
        N <= BRAM_CTRL_rddata[15:0];
    end
    else begin
        N <= N;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reshape_start <= 'b0;
    end
    else if (n_state==INFO_RESHAPE) begin
        reshape_start <= 1'b1;
    end
    else begin
        reshape_start <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sub_P_cnt <= 'b0;
    end
    else if (c_state==INFO_RESHAPE) begin
        sub_P_cnt <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if (sub_P_cnt + 'd16 < P)
            sub_P_cnt <= sub_P_cnt + 'd16;
        else
            sub_P_cnt <= 'b0;
    end
    else begin
        sub_P_cnt <= sub_P_cnt;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sub_M_cnt <= 'b0;
    end
    else if (c_state==INFO_RESHAPE) begin
        sub_M_cnt <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if ((sub_M_cnt + 'd8 < M)&&(sub_P_cnt + 'd16 >= P))
            sub_M_cnt <= sub_M_cnt + 'd8;
        else if ((sub_M_cnt + 'd8 >= M)&&(sub_P_cnt + 'd16 >= P))
            sub_M_cnt <= 'b0;
        else
            sub_M_cnt <= sub_M_cnt;
    end
    else begin
        sub_M_cnt <= sub_M_cnt;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sub_P <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if (sub_P_cnt + 'd16 < P)
            sub_P <= 'd16;
        else
            sub_P <= P - sub_P_cnt;
    end
    else begin
        sub_P <= sub_P;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sub_M <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if (sub_M_cnt + 'd8 < M)
            sub_M <= 'd8;
        else
            sub_M <= M - sub_M_cnt;
    end
    else begin
        sub_M <= sub_M;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subFM_addr_pre <= 'b0;
    end
    else if (c_state==INFO_RESHAPE) begin
        subFM_addr_pre <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if ((sub_M_cnt + 'd8 < M)&&(sub_P_cnt + 'd16 >= P))
            subFM_addr_pre <= subFM_addr_pre + 'd1;
        else if ((sub_M_cnt + 'd8 >= M)&&(sub_P_cnt + 'd16 >= P))
            subFM_addr_pre <= 'd0;
        else
            subFM_addr_pre <= subFM_addr_pre;
    end
    else begin
        subFM_addr_pre <= subFM_addr_pre;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subFM_addr <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        subFM_addr <= subFM_addr_pre;
    end
    else begin
        subFM_addr <= subFM_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subFM_incr <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        subFM_incr <= ((M-1)>>3)+1;
    end
    else begin
        subFM_incr <= subFM_incr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subWM_addr_pre <= 'b0;
    end
    else if (c_state==INFO_RESHAPE) begin
        subWM_addr_pre <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        if (sub_P_cnt + 'd16 < P)
            subWM_addr_pre <= subWM_addr_pre + 'd1;
        else
            subWM_addr_pre <= 'd0;
    end
    else begin
        subWM_addr_pre <= subWM_addr_pre;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subWM_addr <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        subWM_addr <= subWM_addr_pre;
    end
    else begin
        subWM_addr <= subWM_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        subWM_incr <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        subWM_incr <= ((P-1)>>4)+1;
    end
    else begin
        subWM_incr <= subWM_incr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        submulti_start <= 'b0;
    end
    else if (c_state==INFO_MULTIPLY) begin
        submulti_start <= 'b1;
    end
    else begin
        submulti_start <= 'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Ma <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        Ma <= sub_M_cnt;
    end
    else begin
        Ma <= Ma;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Pa <= 'b0;
    end
    else if (c_state==COM_SUBADDR) begin
        Pa <= sub_P_cnt;
    end
    else begin
        Pa <= Pa;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_start <= 'b0;
    end
    else if (c_state==INFO_OUT) begin
        out_start <= 'b1;
    end
    else begin
        out_start <= 'b0;
    end
end

// time count
(*mark_debug = "true"*) reg [63:0] time_FROM_BOOT;
(*mark_debug = "true"*) reg [63:0] time_IDLE;
(*mark_debug = "true"*) reg [63:0] time_GET_COMMAND1;
(*mark_debug = "true"*) reg [63:0] time_GET_COMMAND2;
(*mark_debug = "true"*) reg [63:0] time_INFO_RESHAPE;
(*mark_debug = "true"*) reg [63:0] time_WAIT_RESHAPE;
(*mark_debug = "true"*) reg [63:0] time_COM_SUBADDR;
(*mark_debug = "true"*) reg [63:0] time_INFO_MULTIPLY;
(*mark_debug = "true"*) reg [63:0] time_WAIT_MULTIPLY;
(*mark_debug = "true"*) reg [63:0] time_INFO_OUT;
(*mark_debug = "true"*) reg [63:0] time_WAIT_OUT;
(*mark_debug = "true"*) reg [63:0] time_JUDGE_FINISH;
(*mark_debug = "true"*) reg [63:0] time_FINISH;

always @(posedge clk or posedge rst) begin
    if (rst)
        time_FROM_BOOT <= 'b0;
    else
        time_FROM_BOOT <= time_FROM_BOOT + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_IDLE <= 'b0;
    else if (c_state==IDLE)
        time_IDLE <= time_IDLE + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_GET_COMMAND1 <= 'b0;
    else if (c_state==GET_COMMAND1)
        time_GET_COMMAND1 <= time_GET_COMMAND1 + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_GET_COMMAND2 <= 'b0;
    else if (c_state==GET_COMMAND2)
        time_GET_COMMAND2 <= time_GET_COMMAND2 + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_INFO_RESHAPE <= 'b0;
    else if (c_state==INFO_RESHAPE)
        time_INFO_RESHAPE <= time_INFO_RESHAPE + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_WAIT_RESHAPE <= 'b0;
    else if (c_state==WAIT_RESHAPE)
        time_WAIT_RESHAPE <= time_WAIT_RESHAPE + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_COM_SUBADDR <= 'b0;
    else if (c_state==COM_SUBADDR)
        time_COM_SUBADDR <= time_COM_SUBADDR + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_INFO_MULTIPLY <= 'b0;
    else if (c_state==INFO_MULTIPLY)
        time_INFO_MULTIPLY <= time_INFO_MULTIPLY + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_WAIT_MULTIPLY <= 'b0;
    else if (c_state==WAIT_MULTIPLY)
        time_WAIT_MULTIPLY <= time_WAIT_MULTIPLY + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_INFO_OUT <= 'b0;
    else if (c_state==INFO_OUT)
        time_INFO_OUT <= time_INFO_OUT + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_WAIT_OUT <= 'b0;
    else if (c_state==WAIT_OUT)
        time_WAIT_OUT <= time_WAIT_OUT + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_JUDGE_FINISH <= 'b0;
    else if (c_state==JUDGE_FINISH)
        time_JUDGE_FINISH <= time_JUDGE_FINISH + 'd1;
end
always @(posedge clk or posedge rst) begin
    if (rst)
        time_FINISH <= 'b0;
    else if (c_state==FINISH)
        time_FINISH <= time_FINISH + 'd1;
end

endmodule
