`timescale 1ns/1ps
`include "E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/rtl/define.v"

module MM_top_tb();

reg                   clk                      ; 
reg                   rst                      ; 
reg                   arst_n                   ; 
// connect BRAM_FM64
wire    [  31:   0]   BRAM_FM64_addr           ; 
wire                  BRAM_FM64_clk            ; // clk
wire    [  63:   0]   BRAM_FM64_wrdata         ; // 'b0
wire    [  63:   0]   BRAM_FM64_rddata         ; 
wire                  BRAM_FM64_en             ; // 1'b1
wire                  BRAM_FM64_rst            ; // rst
wire    [   7:   0]   BRAM_FM64_we             ; // 'b0
// connect BRAM_WM128
wire    [  31:   0]   BRAM_WM128_addr          ; 
wire                  BRAM_WM128_clk           ; // clk
wire    [ 127:   0]   BRAM_WM128_wrdata        ; // 'b0
wire    [ 127:   0]   BRAM_WM128_rddata        ; 
wire                  BRAM_WM128_en            ; // 1'b1
wire                  BRAM_WM128_rst           ; // rst
wire    [  15:   0]   BRAM_WM128_we            ; // 'b0
// connect BRAM_CTRL
wire    [  31:   0]   BRAM_CTRL_addr           ; 
wire                  BRAM_CTRL_clk            ; // clk
wire    [  31:   0]   BRAM_CTRL_wrdata         ; 
wire    [  31:   0]   BRAM_CTRL_rddata         ; 
wire                  BRAM_CTRL_en             ; // 1'b1
wire                  BRAM_CTRL_rst            ; // rst
wire    [   3:   0]   BRAM_CTRL_we             ; 
// connect BRAM_OUT
wire    [  31:   0]   BRAM_OUT_addr            ; 
wire                  BRAM_OUT_clk             ; // clk
wire    [  31:   0]   BRAM_OUT_wrdata          ; 
wire    [  31:   0]   BRAM_OUT_rddata          ; 
wire                  BRAM_OUT_en              ; // 1'b1
wire                  BRAM_OUT_rst             ; // rst
wire    [   3:   0]   BRAM_OUT_we              ; 

reg                   arm_clk                  ; 
reg                   arm_work                 ; 
reg     [   7:   0]   arm_BRAM_FM64_wea        ; 
reg     [  31:   0]   arm_BRAM_FM64_addra      ; 
reg     [  63:   0]   arm_BRAM_FM64_dina       ; 
wire    [  63:   0]   arm_BRAM_FM64_douta      ; 
reg     [  15:   0]   arm_BRAM_WM128_wea       ; 
reg     [  31:   0]   arm_BRAM_WM128_addra     ; 
reg     [ 127:   0]   arm_BRAM_WM128_dina      ; 
wire    [ 127:   0]   arm_BRAM_WM128_douta     ; 
reg     [   3:   0]   arm_BRAM_CTRL_wea        ; 
reg     [  31:   0]   arm_BRAM_CTRL_addra      ; 
reg     [  31:   0]   arm_BRAM_CTRL_dina       ; 
wire    [  31:   0]   arm_BRAM_CTRL_douta      ; 
reg     [   3:   0]   arm_BRAM_OUT_wea         ; 
reg     [  31:   0]   arm_BRAM_OUT_addra       ; 
reg     [  31:   0]   arm_BRAM_OUT_dina        ; 
wire    [  31:   0]   arm_BRAM_OUT_douta       ; 

wire    [  31:   0]   BRAM_FM64_addr_change    ; 
wire    [  31:   0]   BRAM_WM128_addr_change   ; 
wire    [  31:   0]   BRAM_CTRL_addr_change    ; 
wire    [  31:   0]   BRAM_OUT_addr_change     ; 

integer file_FM;
integer file_WM;
integer file_para;

integer fp_w;

integer line_FM;
integer line_WM;
integer line_para;
integer line_MMout;

reg FM_reg_valid,WM_reg_valid;
reg [7:0] FM_reg0,FM_reg1,FM_reg2,FM_reg3,FM_reg4,FM_reg5,FM_reg6,FM_reg7;
reg [7:0] WM_reg0,WM_reg1,WM_reg2,WM_reg3,WM_reg4,WM_reg5,WM_reg6,WM_reg7,WM_reg8,WM_reg9,WM_reg10,WM_reg11,WM_reg12,WM_reg13,WM_reg14,WM_reg15;

reg [15:0] M,N,P;

reg [15:0] cnt;
reg [15:0] cnt_f1;

localparam IDLE       = 8'b0000_0001;
localparam WRITE_FM   = 8'b0000_0010;
localparam WRITE_WM   = 8'b0000_0100;
localparam WRITE_COM  = 8'b0000_1000;
localparam WRITE_FLAG = 8'b0001_0000;
localparam WAIT_FLAG  = 8'b0010_0000;
localparam READ_OUT   = 8'b0100_0000;
localparam FINISH     = 8'b1000_0000;

reg [7:0] c_state;
reg [7:0] c_state_f1;
reg [7:0] c_state_f2;
reg [7:0] c_state_f3;
reg [7:0] n_state;

always @(posedge arm_clk or posedge rst) begin
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
        if (arm_work)
            n_state = WRITE_FM;
        else
            n_state = c_state;
    end
    WRITE_FM: begin
        if (cnt == N*((M-1)/8+1) - 'b1)
            n_state = WRITE_WM;
        else
            n_state = c_state;
    end
    WRITE_WM: begin
        if (cnt == N*((P-1)/16+1) - 'b1)
            n_state = WRITE_COM;
        else
            n_state = c_state;
    end
    WRITE_COM: begin
        if (cnt == 'd1)
            n_state = WRITE_FLAG;
        else
            n_state = c_state;
    end
    WRITE_FLAG: begin
        n_state = WAIT_FLAG;
    end
    WAIT_FLAG: begin
        if (arm_BRAM_CTRL_douta==`FLAG_FINISH)
            n_state = READ_OUT;
        else
            n_state = c_state;
    end
    READ_OUT: begin
        if (cnt == M*P-1)
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

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        cnt_f1 <= 'b0;
        c_state_f1 <= IDLE;
        c_state_f2 <= IDLE;
        c_state_f3 <= IDLE;
    end
    else begin
        cnt_f1 <= cnt;
        c_state_f1 <= c_state;
        c_state_f2 <= c_state_f1;
        c_state_f3 <= c_state_f2;
    end
end

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        cnt <= 'b0;
    end
    else if (c_state==WRITE_FM) begin
        if (cnt == N*((M-1)/8+1) - 'b1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==WRITE_WM) begin
        if (cnt == N*((P-1)/16+1) - 'b1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==WRITE_COM) begin
        if (cnt == 'd1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else if (c_state==READ_OUT) begin
        if (cnt == M*P-1)
            cnt <= 'b0;
        else
            cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= cnt;
    end
end

initial begin
    while(1) begin
        file_FM = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test1/FM.txt","r");
        FM_reg_valid = 1'b0;
        FM_reg0 = 'b0;
        FM_reg1 = 'b0;
        FM_reg2 = 'b0;
        FM_reg3 = 'b0;
        FM_reg4 = 'b0;
        FM_reg5 = 'b0;
        FM_reg6 = 'b0;
        FM_reg7 = 'b0;
        wait(c_state==WRITE_FM);
        while(!$feof(file_FM)) begin
            @(posedge arm_clk)
            FM_reg_valid = 1'b1;
            line_FM = $fscanf(file_FM,"%d,%d,%d,%d,%d,%d,%d,%d,",FM_reg0,FM_reg1,FM_reg2,FM_reg3,FM_reg4,FM_reg5,FM_reg6,FM_reg7);
        end
        FM_reg_valid = 1'b0;
        FM_reg0 = 'b0;
        FM_reg1 = 'b0;
        FM_reg2 = 'b0;
        FM_reg3 = 'b0;
        FM_reg4 = 'b0;
        FM_reg5 = 'b0;
        FM_reg6 = 'b0;
        FM_reg7 = 'b0;
        file_FM = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test2/FM.txt","r");
        wait(c_state==WRITE_FM);
        while(!$feof(file_FM)) begin
            @(posedge arm_clk)
            FM_reg_valid = 1'b1;
            line_FM = $fscanf(file_FM,"%d,%d,%d,%d,%d,%d,%d,%d,",FM_reg0,FM_reg1,FM_reg2,FM_reg3,FM_reg4,FM_reg5,FM_reg6,FM_reg7);
        end
    end
end

initial begin
    while(1) begin
        file_WM = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test1/WM.txt","r");
        WM_reg_valid = 1'b0;
        WM_reg0 = 'b0;
        WM_reg1 = 'b0;
        WM_reg2 = 'b0;
        WM_reg3 = 'b0;
        WM_reg4 = 'b0;
        WM_reg5 = 'b0;
        WM_reg6 = 'b0;
        WM_reg7 = 'b0;
        WM_reg8 = 'b0;
        WM_reg9 = 'b0;
        WM_reg10 = 'b0;
        WM_reg11 = 'b0;
        WM_reg12 = 'b0;
        WM_reg13 = 'b0;
        WM_reg14 = 'b0;
        WM_reg15 = 'b0;
        wait(c_state==WRITE_WM);
        while(!$feof(file_WM)) begin
            @(posedge arm_clk)
            WM_reg_valid = 1'b1;
            line_WM = $fscanf(file_WM,"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,",WM_reg0,WM_reg1,WM_reg2,WM_reg3,WM_reg4,WM_reg5,WM_reg6,WM_reg7,WM_reg8,WM_reg9,WM_reg10,WM_reg11,WM_reg12,WM_reg13,WM_reg14,WM_reg15);
        end
        WM_reg_valid = 1'b0;
        WM_reg0 = 'b0;
        WM_reg1 = 'b0;
        WM_reg2 = 'b0;
        WM_reg3 = 'b0;
        WM_reg4 = 'b0;
        WM_reg5 = 'b0;
        WM_reg6 = 'b0;
        WM_reg7 = 'b0;
        WM_reg8 = 'b0;
        WM_reg9 = 'b0;
        WM_reg10 = 'b0;
        WM_reg11 = 'b0;
        WM_reg12 = 'b0;
        WM_reg13 = 'b0;
        WM_reg14 = 'b0;
        WM_reg15 = 'b0;
        file_WM = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test2/WM.txt","r");
        wait(c_state==WRITE_WM);
        while(!$feof(file_WM)) begin
            @(posedge arm_clk)
            WM_reg_valid = 1'b1;
            line_WM = $fscanf(file_WM,"%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,",WM_reg0,WM_reg1,WM_reg2,WM_reg3,WM_reg4,WM_reg5,WM_reg6,WM_reg7,WM_reg8,WM_reg9,WM_reg10,WM_reg11,WM_reg12,WM_reg13,WM_reg14,WM_reg15);
        end
    end
end

initial begin
    while(1) begin
        file_para = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test1/para.txt","r");
        wait(c_state==IDLE);
        while(!$feof(file_para)) begin
            line_para = $fscanf(file_para,"%d",M);
            line_para = $fscanf(file_para,"%d",N);
            line_para = $fscanf(file_para,"%d",P);
        end
        wait(c_state==FINISH);
        file_para = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/test2/para.txt","r");
        wait(c_state==IDLE);
        while(!$feof(file_para)) begin
            line_para = $fscanf(file_para,"%d",M);
            line_para = $fscanf(file_para,"%d",N);
            line_para = $fscanf(file_para,"%d",P);
        end
        wait(c_state==FINISH);
    end
end

initial begin
    fp_w = $fopen("E:/workspace/_Intelligent_Computing_Architectures2/lab5/lab5_proj_question4/tb/tb_MMout.txt","w");
end

initial begin
    clk = 1'b0;
    arm_clk = 1'b0;
    rst = 1'b1;
    arst_n = 1'b0;
    arm_work = 1'b0;
    # 100
    rst = 1'b0;
    arst_n = 1'b1;
    # 100
    arm_work = 1'b1;
end

always #5 clk = ~clk;
always #7.5 arm_clk = ~arm_clk;

assign BRAM_FM64_addr_change = (BRAM_FM64_addr - `SADDR_F_MEM)>>3;
assign BRAM_WM128_addr_change = (BRAM_WM128_addr - `SADDR_W_MEM)>>4;
assign BRAM_CTRL_addr_change = (BRAM_CTRL_addr - `ADDR_FLAG)>>2;
assign BRAM_OUT_addr_change = (BRAM_OUT_addr - `SADDR_O_MEM)>>2;

parameter SIMULATOR = "VivadoSimulator"; // "VivadoSimulator" | "ModelsimSimulator"
// parameter SIMULATOR = "ModelsimSimulator"; 
reg FM_reg_valid_sim,WM_reg_valid_sim;
reg [7:0] FM_reg7_sim,FM_reg6_sim,FM_reg5_sim,FM_reg4_sim,FM_reg3_sim,FM_reg2_sim,FM_reg1_sim,FM_reg0_sim;
reg [7:0] WM_reg15_sim,WM_reg14_sim,WM_reg13_sim,WM_reg12_sim,WM_reg11_sim,WM_reg10_sim,WM_reg9_sim,WM_reg8_sim,WM_reg7_sim,WM_reg6_sim,WM_reg5_sim,WM_reg4_sim,WM_reg3_sim,WM_reg2_sim,WM_reg1_sim,WM_reg0_sim;
generate
    if (SIMULATOR == "VivadoSimulator") begin
        always @(posedge arm_clk) begin
            {FM_reg_valid_sim,WM_reg_valid_sim} <= {FM_reg_valid,WM_reg_valid};
            {FM_reg7_sim,FM_reg6_sim,FM_reg5_sim,FM_reg4_sim,FM_reg3_sim,FM_reg2_sim,FM_reg1_sim,FM_reg0_sim} <= {FM_reg7,FM_reg6,FM_reg5,FM_reg4,FM_reg3,FM_reg2,FM_reg1,FM_reg0};
            {WM_reg15_sim,WM_reg14_sim,WM_reg13_sim,WM_reg12_sim,WM_reg11_sim,WM_reg10_sim,WM_reg9_sim,WM_reg8_sim,WM_reg7_sim,WM_reg6_sim,WM_reg5_sim,WM_reg4_sim,WM_reg3_sim,WM_reg2_sim,WM_reg1_sim,WM_reg0_sim} <= {WM_reg15,WM_reg14,WM_reg13,WM_reg12,WM_reg11,WM_reg10,WM_reg9,WM_reg8,WM_reg7,WM_reg6,WM_reg5,WM_reg4,WM_reg3,WM_reg2,WM_reg1,WM_reg0};
        end
    end
    else if (SIMULATOR == "ModelsimSimulator") begin
        always @(*) begin
            {FM_reg_valid_sim,WM_reg_valid_sim} = {FM_reg_valid,WM_reg_valid};
            {FM_reg7_sim,FM_reg6_sim,FM_reg5_sim,FM_reg4_sim,FM_reg3_sim,FM_reg2_sim,FM_reg1_sim,FM_reg0_sim} = {FM_reg7,FM_reg6,FM_reg5,FM_reg4,FM_reg3,FM_reg2,FM_reg1,FM_reg0};
            {WM_reg15_sim,WM_reg14_sim,WM_reg13_sim,WM_reg12_sim,WM_reg11_sim,WM_reg10_sim,WM_reg9_sim,WM_reg8_sim,WM_reg7_sim,WM_reg6_sim,WM_reg5_sim,WM_reg4_sim,WM_reg3_sim,WM_reg2_sim,WM_reg1_sim,WM_reg0_sim} = {WM_reg15,WM_reg14,WM_reg13,WM_reg12,WM_reg11,WM_reg10,WM_reg9,WM_reg8,WM_reg7,WM_reg6,WM_reg5,WM_reg4,WM_reg3,WM_reg2,WM_reg1,WM_reg0};
        end
    end
endgenerate

always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM64_wea <= 'b0;
    end
    else begin
        arm_BRAM_FM64_wea <= {8{FM_reg_valid_sim}};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM64_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_FM) begin
        arm_BRAM_FM64_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_FM64_dina <= 'b0;
    end
    else begin
        arm_BRAM_FM64_dina <= {FM_reg7_sim,FM_reg6_sim,FM_reg5_sim,FM_reg4_sim,FM_reg3_sim,FM_reg2_sim,FM_reg1_sim,FM_reg0_sim};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM128_wea <= 'b0;
    end
    else begin
        arm_BRAM_WM128_wea <= {16{WM_reg_valid_sim}};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM128_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_WM) begin
        arm_BRAM_WM128_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_WM128_dina <= 'b0;
    end
    else begin
        arm_BRAM_WM128_dina <= {WM_reg15_sim,WM_reg14_sim,WM_reg13_sim,WM_reg12_sim,WM_reg11_sim,WM_reg10_sim,WM_reg9_sim,WM_reg8_sim,WM_reg7_sim,WM_reg6_sim,WM_reg5_sim,WM_reg4_sim,WM_reg3_sim,WM_reg2_sim,WM_reg1_sim,WM_reg0_sim};
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_wea <= 'b0;
    end
    else if (c_state_f1==WRITE_COM||c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_wea <= {4{1'b1}};
    end
    else begin
        arm_BRAM_CTRL_wea <= 'b0;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_addra <= 'b0;
    end
    else if (c_state_f1==WRITE_COM) begin
        if (cnt_f1 == 'b0)
            arm_BRAM_CTRL_addra <= (`ADDR_COM1 - `ADDR_FLAG) >> 2;
        else if (cnt_f1 == 'b1)
            arm_BRAM_CTRL_addra <= (`ADDR_COM2 - `ADDR_FLAG) >> 2;
    end
    else if (c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_addra <= (`ADDR_FLAG - `ADDR_FLAG) >> 2;
    end
    else if (c_state==WAIT_FLAG) begin
        arm_BRAM_CTRL_addra <= (`ADDR_FLAG - `ADDR_FLAG) >> 2;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_CTRL_dina <= 'b0;
    end
    else if (c_state_f1==WRITE_COM) begin
        if (cnt_f1 == 'b0)
            arm_BRAM_CTRL_dina <= {P,M};
        else if (cnt_f1 == 'b1)
            arm_BRAM_CTRL_dina <= {16'b0,N};
    end
    else if (c_state_f1==WRITE_FLAG) begin
        arm_BRAM_CTRL_dina <= `FLAG_START;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_wea <= 'b0;
    end
    else begin
        arm_BRAM_OUT_wea <= 'b0;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_addra <= 'b0;
    end
    else if (c_state_f1==READ_OUT) begin
        arm_BRAM_OUT_addra <= cnt_f1;
    end
end
always @(posedge arm_clk or posedge rst) begin
    if (rst) begin
        arm_BRAM_OUT_dina <= 'b0;
    end
    else begin
        arm_BRAM_OUT_dina <= 'b0;
    end
end

always @(posedge arm_clk) begin
    if (c_state_f3==READ_OUT) begin
        $fwrite(fp_w,"%d\n",$signed(arm_BRAM_OUT_douta));
    end
end

tb_ram_FM64 BRAM_FM64(
    .clka                 (arm_clk                    ), // input wire clka
    .wea                  (arm_BRAM_FM64_wea          ), // input wire [7 : 0] wea
    .addra                (arm_BRAM_FM64_addra        ), // input wire [31 : 0] addra
    .dina                 (arm_BRAM_FM64_dina         ), // input wire [63 : 0] dina
    .douta                (arm_BRAM_FM64_douta        ), // output wire [63 : 0] douta
    .clkb                 (BRAM_FM64_clk              ), // input wire clkb
    .web                  (BRAM_FM64_we               ), // input wire [7 : 0] web
    .addrb                (BRAM_FM64_addr_change      ), // input wire [31 : 0] addrb
    .dinb                 (BRAM_FM64_wrdata           ), // input wire [63 : 0] dinb
    .doutb                (BRAM_FM64_rddata           )  // output wire [63 : 0] doutb
);

tb_ram_WM128 BRAM_WM128(
    .clka                 (arm_clk                     ), // input wire clka
    .wea                  (arm_BRAM_WM128_wea          ), // input wire [15 : 0] wea
    .addra                (arm_BRAM_WM128_addra        ), // input wire [31 : 0] addra
    .dina                 (arm_BRAM_WM128_dina         ), // input wire [127 : 0] dina
    .douta                (arm_BRAM_WM128_douta        ), // output wire [127 : 0] douta
    .clkb                 (BRAM_WM128_clk              ), // input wire clkb
    .web                  (BRAM_WM128_we               ), // input wire [15 : 0] web
    .addrb                (BRAM_WM128_addr_change      ), // input wire [31 : 0] addrb
    .dinb                 (BRAM_WM128_wrdata           ), // input wire [127 : 0] dinb
    .doutb                (BRAM_WM128_rddata           )  // output wire [127 : 0] doutb
);

tb_ram BRAM_CTRL(
    .clka                 (arm_clk                    ), // input wire clka
    .wea                  (arm_BRAM_CTRL_wea          ), // input wire [3 : 0] wea
    .addra                (arm_BRAM_CTRL_addra        ), // input wire [31 : 0] addra
    .dina                 (arm_BRAM_CTRL_dina         ), // input wire [31 : 0] dina
    .douta                (arm_BRAM_CTRL_douta        ), // output wire [31 : 0] douta
    .clkb                 (BRAM_CTRL_clk              ), // input wire clkb
    .web                  (BRAM_CTRL_we               ), // input wire [3 : 0] web
    .addrb                (BRAM_CTRL_addr_change      ), // input wire [31 : 0] addrb
    .dinb                 (BRAM_CTRL_wrdata           ), // input wire [31 : 0] dinb
    .doutb                (BRAM_CTRL_rddata           )  // output wire [31 : 0] doutb
);

tb_ram BRAM_OUT(
    .clka                 (arm_clk                   ), // input wire clka
    .wea                  (arm_BRAM_OUT_wea          ), // input wire [3 : 0] wea
    .addra                (arm_BRAM_OUT_addra        ), // input wire [31 : 0] addra
    .dina                 (arm_BRAM_OUT_dina         ), // input wire [31 : 0] dina
    .douta                (arm_BRAM_OUT_douta        ), // output wire [31 : 0] douta
    .clkb                 (BRAM_OUT_clk              ), // input wire clkb
    .web                  (BRAM_OUT_we               ), // input wire [3 : 0] web
    .addrb                (BRAM_OUT_addr_change      ), // input wire [31 : 0] addrb
    .dinb                 (BRAM_OUT_wrdata           ), // input wire [31 : 0] dinb
    .doutb                (BRAM_OUT_rddata           )  // output wire [31 : 0] doutb
);

MM_TOP U_MM_TOP(
    .clk                 (clk                ),
    .arst_n              (arst_n             ),
    .BRAM_FM64_addr      (BRAM_FM64_addr     ),
    .BRAM_FM64_clk       (BRAM_FM64_clk      ),
    .BRAM_FM64_wrdata    (BRAM_FM64_wrdata   ),
    .BRAM_FM64_rddata    (BRAM_FM64_rddata   ),
    .BRAM_FM64_en        (BRAM_FM64_en       ),
    .BRAM_FM64_rst       (BRAM_FM64_rst      ),
    .BRAM_FM64_we        (BRAM_FM64_we       ),
    .BRAM_WM128_addr     (BRAM_WM128_addr    ),
    .BRAM_WM128_clk      (BRAM_WM128_clk     ),
    .BRAM_WM128_wrdata   (BRAM_WM128_wrdata  ),
    .BRAM_WM128_rddata   (BRAM_WM128_rddata  ),
    .BRAM_WM128_en       (BRAM_WM128_en      ),
    .BRAM_WM128_rst      (BRAM_WM128_rst     ),
    .BRAM_WM128_we       (BRAM_WM128_we      ),
    .BRAM_CTRL_addr      (BRAM_CTRL_addr     ),
    .BRAM_CTRL_clk       (BRAM_CTRL_clk      ),
    .BRAM_CTRL_wrdata    (BRAM_CTRL_wrdata   ),
    .BRAM_CTRL_rddata    (BRAM_CTRL_rddata   ),
    .BRAM_CTRL_en        (BRAM_CTRL_en       ),
    .BRAM_CTRL_rst       (BRAM_CTRL_rst      ),
    .BRAM_CTRL_we        (BRAM_CTRL_we       ),
    .BRAM_OUT_addr       (BRAM_OUT_addr      ),
    .BRAM_OUT_clk        (BRAM_OUT_clk       ),
    .BRAM_OUT_wrdata     (BRAM_OUT_wrdata    ),
    .BRAM_OUT_rddata     (BRAM_OUT_rddata    ),
    .BRAM_OUT_en         (BRAM_OUT_en        ),
    .BRAM_OUT_rst        (BRAM_OUT_rst       ),
    .BRAM_OUT_we         (BRAM_OUT_we        )
);

endmodule
