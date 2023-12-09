`include "define.v"

module FM_reshape(
    input clk,
    input rst,
    // connect BRAM_FM32
    output reg [31:0] BRAM_FM32_addr,
    output BRAM_FM32_clk, // clk
    output [31:0] BRAM_FM32_wrdata, // 'b0
    input [31:0] BRAM_FM32_rddata,
    output BRAM_FM32_en, // 1'b1
    output BRAM_FM32_rst, // rst
    output [3:0] BRAM_FM32_we, // 'b0
    // connect CTRL
    input [15:0] M,
    input [15:0] N,
    input reshape_start,
    output reg FM_reshape_finish, // 电平信号
    // connect BRAM_FM64
    output reg [15:0] BRAM_FM64_waddr,
    output reg [63:0] BRAM_FM64_wrdata,
    output reg BRAM_FM64_we
    );

reg [15:0] cycle1;
reg [15:0] cycle2;
reg [15:0] cycle1_cnt;
reg [15:0] cycle2_cnt;

assign BRAM_FM32_clk = clk;
assign BRAM_FM32_wrdata = 'b0;
assign BRAM_FM32_en = 1'b1;
assign BRAM_FM32_rst = rst;
assign BRAM_FM32_we = 'b0;

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
        cycle1 <= ((M-1)>>2)+1;
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
        BRAM_FM32_addr <= 'b0;
    end
    else if (n_state==COM) begin
        BRAM_FM32_addr <= `SADDR_F_MEM;
    end
    else if (n_state==WORK) begin
        BRAM_FM32_addr <= BRAM_FM32_addr + `F_MEM_INCR;
    end
    else begin
        BRAM_FM32_addr <= BRAM_FM32_addr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_FM64_waddr <= 'b0;
    end
    else if (c_state==COM) begin
        BRAM_FM64_waddr <= 'b0 - 1'b1;
    end
    else if ((c_state==WORK)&&((cycle1_cnt==cycle1-1'b1)||(cycle1_cnt[0]==1'b1))) begin
        BRAM_FM64_waddr <= BRAM_FM64_waddr + 1'b1;
    end
    else begin
        BRAM_FM64_waddr <= BRAM_FM64_waddr;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_FM64_wrdata <= 'b0;
    end
    else if ((c_state==WORK)&&(cycle1_cnt[0]==1'b1)) begin
        BRAM_FM64_wrdata <= {BRAM_FM32_rddata,BRAM_FM64_wrdata[31:0]};
    end
    else if (c_state==WORK) begin
        BRAM_FM64_wrdata <= {32'b0,BRAM_FM32_rddata};
    end
    else begin
        BRAM_FM64_wrdata <= BRAM_FM64_wrdata;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        BRAM_FM64_we <= 'b0;
    end
    else if ((c_state==WORK)&&((cycle1_cnt==cycle1-1'b1)||(cycle1_cnt[0]==1'b1))) begin
        BRAM_FM64_we <= 1'b1;
    end
    else begin
        BRAM_FM64_we <= 1'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        FM_reshape_finish <= 'b0;
    end
    else if (reshape_start) begin
        FM_reshape_finish <= 'b0;
    end
    else if (c_state==FINISH) begin
        FM_reshape_finish <= 1'b1;
    end
    else begin
        FM_reshape_finish <= FM_reshape_finish;
    end
end

endmodule