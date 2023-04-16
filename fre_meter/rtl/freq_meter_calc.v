module  freq_meter_calc
(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            clk_test    ,

    output  reg     [31:0]  freq

);

parameter   CNT_GATE_S_MAX = 27'd74_999_999;
parameter   CNT_RISE_MAX   = 27'd12_499_999;
parameter   CNT_STAND_FREQ = 27'd100_000_000;

reg     [26:0]  cnt_gate_s      ;
reg             gate_s          ;
reg             gate_a          ;
reg     [47:0]  cnt_clk_test    ;
reg             gate_a_test_reg ;
reg     [47:0]  cnt_clk_test_reg;
reg     [47:0]  cnt_clk_stand   ;
reg             gate_a_stand_reg;
reg     [47:0]  cnt_clk_stand_reg;
reg             calc_flag       ;
reg     [63:0]  freq_reg        ;
reg             calc_flag_reg   ;

wire            gate_a_fall_t   ;
wire            clk_stand       ;
wire            gate_a_fall_s   ;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_gate_s  <=  27'd0;
    else    if(cnt_gate_s == CNT_GATE_S_MAX)
        cnt_gate_s  <=  27'd0;
    else
        cnt_gate_s  <=  cnt_gate_s + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_s  <=  1'b0;
    else    if(cnt_gate_s > CNT_RISE_MAX 
            && cnt_gate_s <= (CNT_GATE_S_MAX - CNT_RISE_MAX))
        gate_s  <=  1'b1;
    else
        gate_s  <=  1'b0;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a  <=  1'b0;
    else
        gate_a  <=  gate_s;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a == 1'b0)
        cnt_clk_test    <=  48'd0;
    else    if(gate_a == 1'b1)
        cnt_clk_test    <=  cnt_clk_test + 1'b1;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_test_reg <=  1'b0;
    else
        gate_a_test_reg <=  gate_a;

assign  gate_a_fall_t = ((gate_a_test_reg == 1'b1) && (gate_a == 1'b0))
        ? 1'b1 : 1'b0;

always@(posedge clk_test or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_test_reg    <=  48'd0;
    else    if(gate_a_fall_t == 1'b1)
        cnt_clk_test_reg    <=  cnt_clk_test;

always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a == 1'b0)
        cnt_clk_stand   <=  48'd0;
    else    if(gate_a == 1'b1)
        cnt_clk_stand   <=  cnt_clk_stand + 1'b1;

always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        gate_a_stand_reg    <=  1'b0;
    else
        gate_a_stand_reg    <=  gate_a;

assign  gate_a_fall_s = ((gate_a_test_reg == 1'b1) && (gate_a == 1'b0))
        ? 1'b1 : 1'b0;

always@(posedge clk_stand or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        cnt_clk_stand_reg   <=  48'd0;
    else    if(gate_a_fall_s == 1'b1)
        cnt_clk_stand_reg   <=  cnt_clk_stand;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag   <=  1'b0;
    else    if(cnt_gate_s == CNT_GATE_S_MAX)
        calc_flag   <=  1'b1;
    else
        calc_flag   <=  1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq_reg    <=  64'd0;
    else    if(calc_flag == 1'b1)
        freq_reg    <=  (CNT_STAND_FREQ * cnt_clk_test_reg / cnt_clk_stand_reg);

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        calc_flag_reg   <=  1'b0;
    else
        calc_flag_reg   <=  calc_flag;

always@(posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)
        freq    <=  32'd0;
    else    if(calc_flag == 1'b1)
        freq    <=  freq_reg[31:0];

clk_stand   clk_stand_inst
(
    .areset (~sys_rst_n),
    .inclk0 (sys_clk),
    .c0     (clk_stand)
);

endmodule