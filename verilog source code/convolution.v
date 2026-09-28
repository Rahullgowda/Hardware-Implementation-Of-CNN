
// Project : Single Layer Hardware CNN
// Module  : Convolution
// Description : 3x3 Convolution Layer - 4 Filters
//
// Fixed Point:
//     Input  : Q6
//     Weight : Q6
//     Bias   : Q6
//
//     Input x Weight = Q12
//     Q12 >>> 6 = Q6
//==============================================================

module convolution
#(
parameter DATA_WIDTH   = 8,
parameter WEIGHT_WIDTH = 8,
parameter OUT_WIDTH    = 32
)
(
input clk,
input reset,

//----------------------------------------------------------
// Window Valid
//----------------------------------------------------------

input window_valid,

//----------------------------------------------------------
// Window Coordinates
//----------------------------------------------------------

input [3:0] window_row,
input [3:0] window_col,

//----------------------------------------------------------
// 3x3 Window
//----------------------------------------------------------

input signed [DATA_WIDTH-1:0] w0,
input signed [DATA_WIDTH-1:0] w1,
input signed [DATA_WIDTH-1:0] w2,

input signed [DATA_WIDTH-1:0] w3,
input signed [DATA_WIDTH-1:0] w4,
input signed [DATA_WIDTH-1:0] w5,

input signed [DATA_WIDTH-1:0] w6,
input signed [DATA_WIDTH-1:0] w7,
input signed [DATA_WIDTH-1:0] w8,

//----------------------------------------------------------
// Four Convolution Outputs
//----------------------------------------------------------

output reg signed [OUT_WIDTH-1:0] conv0,
output reg signed [OUT_WIDTH-1:0] conv1,
output reg signed [OUT_WIDTH-1:0] conv2,
output reg signed [OUT_WIDTH-1:0] conv3,

output reg conv_valid,

//----------------------------------------------------------
// Convolution Result Coordinates
//----------------------------------------------------------

output reg [3:0] conv_row,
output reg [3:0] conv_col

);

//--------------------------------------------------------------
// Trained Weights
//
// 4 filters × 3 × 3 = 36 weights
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] weights [0:35];

//--------------------------------------------------------------
// Trained Biases
//
// 4 filters = 4 biases
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] bias [0:3];

//--------------------------------------------------------------
// Individual Multiplication Results
//
// 8-bit × 8-bit = 16-bit
//
// Keeping every multiplication in 16 bits prevents the
// multiplication result from being truncated before addition.
//--------------------------------------------------------------

reg signed [15:0] product0;
reg signed [15:0] product1;
reg signed [15:0] product2;
reg signed [15:0] product3;
reg signed [15:0] product4;
reg signed [15:0] product5;
reg signed [15:0] product6;
reg signed [15:0] product7;
reg signed [15:0] product8;

reg signed [15:0] product9;
reg signed [15:0] product10;
reg signed [15:0] product11;
reg signed [15:0] product12;
reg signed [15:0] product13;
reg signed [15:0] product14;
reg signed [15:0] product15;
reg signed [15:0] product16;
reg signed [15:0] product17;

reg signed [15:0] product18;
reg signed [15:0] product19;
reg signed [15:0] product20;
reg signed [15:0] product21;
reg signed [15:0] product22;
reg signed [15:0] product23;
reg signed [15:0] product24;
reg signed [15:0] product25;
reg signed [15:0] product26;

reg signed [15:0] product27;
reg signed [15:0] product28;
reg signed [15:0] product29;
reg signed [15:0] product30;
reg signed [15:0] product31;
reg signed [15:0] product32;
reg signed [15:0] product33;
reg signed [15:0] product34;
reg signed [15:0] product35;

//--------------------------------------------------------------
// 40-bit Accumulators
//
// 9 products are accumulated before shifting.
//
// 40 bits gives plenty of room for the sum.
//--------------------------------------------------------------

reg signed [39:0] sum0;
reg signed [39:0] sum1;
reg signed [39:0] sum2;
reg signed [39:0] sum3;

//--------------------------------------------------------------
// Load Weights and Biases
//--------------------------------------------------------------

initial
begin

$readmemh(
    "D:/single layer hardware cnn project/hardware/memory/conv_weights.mem",
    weights
);

$readmemh(
    "D:/single layer hardware cnn project/hardware/memory/conv_bias.mem",
    bias
);

end

//--------------------------------------------------------------
// Sequential Logic
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

if(reset)
begin

    conv0 <= 0;
    conv1 <= 0;
    conv2 <= 0;
    conv3 <= 0;

    conv_valid <= 1'b0;

    conv_row <= 0;
    conv_col <= 0;

end

else
begin

    //------------------------------------------------------
    // Default
    //------------------------------------------------------

    conv_valid <= 1'b0;


    //------------------------------------------------------
    // Perform Convolution
    //------------------------------------------------------

    if(window_valid)
    begin

        //--------------------------------------------------
        // FILTER 0
        //--------------------------------------------------

        product0 = w0 * weights[0];
        product1 = w1 * weights[1];
        product2 = w2 * weights[2];

        product3 = w3 * weights[3];
        product4 = w4 * weights[4];
        product5 = w5 * weights[5];

        product6 = w6 * weights[6];
        product7 = w7 * weights[7];
        product8 = w8 * weights[8];

        sum0 =
              {{24{product0[15]}}, product0}
            + {{24{product1[15]}}, product1}
            + {{24{product2[15]}}, product2}
            + {{24{product3[15]}}, product3}
            + {{24{product4[15]}}, product4}
            + {{24{product5[15]}}, product5}
            + {{24{product6[15]}}, product6}
            + {{24{product7[15]}}, product7}
            + {{24{product8[15]}}, product8};


        //--------------------------------------------------
        // FILTER 1
        //--------------------------------------------------

        product9  = w0 * weights[9];
        product10 = w1 * weights[10];
        product11 = w2 * weights[11];

        product12 = w3 * weights[12];
        product13 = w4 * weights[13];
        product14 = w5 * weights[14];

        product15 = w6 * weights[15];
        product16 = w7 * weights[16];
        product17 = w8 * weights[17];

        sum1 =
              {{24{product9[15]}}, product9}
            + {{24{product10[15]}}, product10}
            + {{24{product11[15]}}, product11}
            + {{24{product12[15]}}, product12}
            + {{24{product13[15]}}, product13}
            + {{24{product14[15]}}, product14}
            + {{24{product15[15]}}, product15}
            + {{24{product16[15]}}, product16}
            + {{24{product17[15]}}, product17};


        //--------------------------------------------------
        // FILTER 2
        //--------------------------------------------------

        product18 = w0 * weights[18];
        product19 = w1 * weights[19];
        product20 = w2 * weights[20];

        product21 = w3 * weights[21];
        product22 = w4 * weights[22];
        product23 = w5 * weights[23];

        product24 = w6 * weights[24];
        product25 = w7 * weights[25];
        product26 = w8 * weights[26];

        sum2 =
              {{24{product18[15]}}, product18}
            + {{24{product19[15]}}, product19}
            + {{24{product20[15]}}, product20}
            + {{24{product21[15]}}, product21}
            + {{24{product22[15]}}, product22}
            + {{24{product23[15]}}, product23}
            + {{24{product24[15]}}, product24}
            + {{24{product25[15]}}, product25}
            + {{24{product26[15]}}, product26};


        //--------------------------------------------------
        // FILTER 3
        //--------------------------------------------------

        product27 = w0 * weights[27];
        product28 = w1 * weights[28];
        product29 = w2 * weights[29];

        product30 = w3 * weights[30];
        product31 = w4 * weights[31];
        product32 = w5 * weights[32];

        product33 = w6 * weights[33];
        product34 = w7 * weights[34];
        product35 = w8 * weights[35];

        sum3 =
              {{24{product27[15]}}, product27}
            + {{24{product28[15]}}, product28}
            + {{24{product29[15]}}, product29}
            + {{24{product30[15]}}, product30}
            + {{24{product31[15]}}, product31}
            + {{24{product32[15]}}, product32}
            + {{24{product33[15]}}, product33}
            + {{24{product34[15]}}, product34}
            + {{24{product35[15]}}, product35};
            
            
            
                        //--------------------------------------------------
        // Convert Q12 back to Q6
        //
        // Q12 >>> 6 = Q6
        //
        // Then add Q6 bias.
        //--------------------------------------------------

        conv0 <= (sum0 >>> 6) + bias[0];

        conv1 <= (sum1 >>> 6) + bias[1];

        conv2 <= (sum2 >>> 6) + bias[2];

        conv3 <= (sum3 >>> 6) + bias[3];


        //--------------------------------------------------
        // Store Coordinates
        //--------------------------------------------------

        conv_row <= window_row;
        conv_col <= window_col;


        //--------------------------------------------------
        // Output Valid
        //--------------------------------------------------

        conv_valid <= 1'b1;

    end

end

end

endmodule
