module  freq_meter
(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire            clk_test    ,

    output  wire            clk_out     ,
    output  wire            ds          ,
    output  wire            oe          ,
    output  wire            shcp        ,
    output  wire            stcp
);

wire    [31:0]  freq        ;

freq_meter_calc freq_meter_calc_inst
(
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    .clk_test    (clk_test),

    .freq        (freq)
);

clk_test    clk_test_inst
(
    .areset (~sys_rst_n),
    .inclk0 (sys_clk),
    .c0     (clk_out)
);

seg_595_dynamic seg_595_dynamic_inst
(
    .sys_clk     (sys_clk),
    .sys_rst_n   (sys_rst_n),
    .data        (freq/1000),
    .point       (6'b001_000),
    .sign        (1'b0),
    .seg_en      (1'b1),

    .ds          (ds  ),
    .oe          (oe  ),
    .shcp        (shcp),
    .stcp        (stcp)
);

endmodule