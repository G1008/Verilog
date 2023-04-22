module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    
    wire	[99:0]	cc;
    bcd_fadd	inst0
    (
        .a			(a[3:0]),	
        .b			(b[3:0]),
        .cin		(cin),
        .sum		(sum[3:0]),
        .cout		(cc[0])
    );
    genvar	i;
    generate
        for(i = 1; i < 100; i = i +1)
            begin	: bcd_add
               bcd_fadd inst
                 (
                     .a			(a[4*(i+1)-1:4*i]		),
                     .b			(b[4*(i+1)-1:4*i]		),
                     .cin		(cc[i-1]				),
                     .sum		(sum[4*(i+1)-1:4*i]		),
                     .cout		(cc[i]					)
   				 );
            end
    endgenerate
    assign	cout = cc[99];
endmodule
