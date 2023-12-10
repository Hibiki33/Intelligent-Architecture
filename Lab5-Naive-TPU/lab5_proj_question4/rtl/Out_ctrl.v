`include "define.v"

module Out_ctrl(
    input clk,
    input rst,
    // connect BRAM_OUT
    output reg [31:0] BRAM_OUT_addr,
    output BRAM_OUT_clk, // clk
    output reg [31:0] BRAM_OUT_wrdata,
    input [31:0] BRAM_OUT_rddata,
    output BRAM_OUT_en, // 1'b1
    output BRAM_OUT_rst, // rst
    output reg [3:0] BRAM_OUT_we,
    // connect CTRL
    input [15:0] P,
    input [15:0] Ma,
    input [15:0] Pa,
    input [7:0] sub_P, // 本次计算子矩阵结果的大小
    input [7:0] sub_M, // 本次计算子矩阵结果的大小
    input out_start,
    output reg out_finish, // 脉冲信号
    // connect Align_fifo
    output reg out_ctrl_ready1,
    output reg out_ctrl_ready2,
    input valid1,
    input [31:0] data1,
    input valid2,
    input [31:0] data2
    );

assign BRAM_OUT_clk = clk;
assign BRAM_OUT_en = 1'b1;
assign BRAM_OUT_rst = rst;

reg [7:0] cnt_P;
reg [7:0] cnt_M;
reg [31:0] offset_addr;
reg [31:0] BRAM_OUT_addr_pre;
reg [2:0] c_state_f1;

localparam IDLE   = 3'b001;
localparam WORK   = 3'b010;
localparam FINISH = 3'b100;

reg [2:0] c_state;
reg [2:0] n_state;

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
        if (out_start)
            n_state = WORK;
        else
            n_state = c_state;
    end
    WORK: begin
        if ((cnt_P==sub_P-1'b1)&&(cnt_M==sub_M-1'b1))
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
        cnt_P <= 'b0;
    end
    else if (c_state==WORK) begin
        if (cnt_P==sub_P-1'b1)
            cnt_P <= 'b0;
        else
            cnt_P <= cnt_P + 1'b1;
    end
    else begin
        cnt_P <= cnt_P;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        cnt_M <= 'b0;
    end
    else if (c_state==WORK) begin
        if ((cnt_P==sub_P-1'b1)&&(cnt_M==sub_M-1'b1))
            cnt_M <= 'b0;
        else if (cnt_P==sub_P-1'b1)
            cnt_M <= cnt_M + 1'b1;
        else
            cnt_M <= cnt_M;
    end
    else begin
        cnt_M <= cnt_M;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        offset_addr <= 'b0;
    end
    else if (c_state==WORK) begin
        offset_addr <= cnt_M*P + cnt_P;
    end
    else begin
        offset_addr <= offset_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_OUT_addr_pre <= 'b0;
    end
    else if (out_start) begin
        BRAM_OUT_addr_pre <= `SADDR_O_MEM + (Ma*P + Pa)*`O_MEM_INCR;
    end
    else if (c_state_f1==WORK) begin
        BRAM_OUT_addr_pre <= `SADDR_O_MEM + (Ma*P + Pa)*`O_MEM_INCR + offset_addr*`O_MEM_INCR;
    end
    else begin
        BRAM_OUT_addr_pre <= BRAM_OUT_addr_pre;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_OUT_addr <= 'b0;
    end
    else begin
        BRAM_OUT_addr <= BRAM_OUT_addr_pre;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_ctrl_ready1 <= 1'b0;
    end
    else if ((c_state==WORK)&&(cnt_P<'d8)) begin
        out_ctrl_ready1 <= 1'b1;
    end
    else begin
        out_ctrl_ready1 <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_ctrl_ready2 <= 1'b0;
    end
    else if ((c_state==WORK)&&(cnt_P>='d8)) begin
        out_ctrl_ready2 <= 1'b1;
    end
    else begin
        out_ctrl_ready2 <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_OUT_wrdata <= 'b0;
    end
    else if (valid1) begin
        BRAM_OUT_wrdata <= data1;
    end
    else if (valid2) begin
        BRAM_OUT_wrdata <= data2;
    end
    else begin
        BRAM_OUT_wrdata <= BRAM_OUT_wrdata;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_OUT_we <= 'b0;
    end
    else if (valid1|valid2) begin
        BRAM_OUT_we <= 4'hf;
    end
    else begin
        BRAM_OUT_we <= 'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_finish <= 1'b0;
    end
    else if (c_state==FINISH) begin
        out_finish <= 1'b1;
    end
    else begin
        out_finish <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        c_state_f1 <= IDLE;
    end
    else begin
        c_state_f1 <= c_state;
    end
end

endmodule