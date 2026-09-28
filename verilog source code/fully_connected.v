
//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Fully Connected Layer
// Description :
//     196-input Fully Connected Layer
//     3 output neurons
//
//     Input  : 196 flattened values
//     Output : 3 class scores
//
//     Fixed-point scale factor = 64
//==============================================================

module fully_connected
#(
    parameter DATA_WIDTH   = 32,
    parameter WEIGHT_WIDTH = 8,
    parameter INPUT_SIZE   = 196,
    parameter OUTPUT_SIZE  = 3,
    parameter ACC_WIDTH    = 48
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // Flatten Input
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] flat_data,
    input flat_valid,
    input [7:0] flat_index,

    //----------------------------------------------------------
    // FC Outputs
    //----------------------------------------------------------

    output reg signed [ACC_WIDTH-1:0] fc0,
    output reg signed [ACC_WIDTH-1:0] fc1,
    output reg signed [ACC_WIDTH-1:0] fc2,

    output reg fc_valid
);

//--------------------------------------------------------------
// Weight Memory
//
// 196 inputs × 3 outputs = 588 weights
//
// Ordering:
//
// input 0  -> weight 0,1,2
// input 1  -> weight 3,4,5
// ...
// input 195 -> weight 585,586,587
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] weight_mem
[0:INPUT_SIZE*OUTPUT_SIZE-1];

//--------------------------------------------------------------
// Bias Memory
//
// 3 output neurons = 3 biases
//--------------------------------------------------------------

reg signed [WEIGHT_WIDTH-1:0] bias_mem
[0:OUTPUT_SIZE-1];

//--------------------------------------------------------------
// Accumulators
//--------------------------------------------------------------

reg signed [ACC_WIDTH-1:0] acc0;
reg signed [ACC_WIDTH-1:0] acc1;
reg signed [ACC_WIDTH-1:0] acc2;

//--------------------------------------------------------------
// Multiplication Results
//
// 32-bit input × 8-bit weight = 40-bit result
//--------------------------------------------------------------

reg signed [DATA_WIDTH+WEIGHT_WIDTH-1:0] mult0;
reg signed [DATA_WIDTH+WEIGHT_WIDTH-1:0] mult1;
reg signed [DATA_WIDTH+WEIGHT_WIDTH-1:0] mult2;

//--------------------------------------------------------------
// Weight Memory Initialization
//--------------------------------------------------------------

initial
begin

    $readmemh(
        "D:/single layer hardware cnn project/hardware/memory/fc_weights.mem",
        weight_mem
    );

    $readmemh(
        "D:/single layer hardware cnn project/hardware/memory/fc_bias.mem",
        bias_mem
    );

end

//--------------------------------------------------------------
// Sequential Logic
//--------------------------------------------------------------

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        //------------------------------------------------------
        // Reset Outputs
        //------------------------------------------------------

        fc0 <= 0;
        fc1 <= 0;
        fc2 <= 0;

        fc_valid <= 1'b0;

        //------------------------------------------------------
        // Reset Accumulators
        //------------------------------------------------------

        acc0 <= 0;
        acc1 <= 0;
        acc2 <= 0;

    end

    else
    begin

        //------------------------------------------------------
        // Default
        //------------------------------------------------------

        fc_valid <= 1'b0;

        //------------------------------------------------------
        // Receive Flatten Data
        //------------------------------------------------------

        if(flat_valid)
        begin

            //--------------------------------------------------
            // Multiply current flattened value with
            // corresponding weights
            //
            // Weight ordering:
            //
            // flat_index * 3 + 0 → FC0 weight
            // flat_index * 3 + 1 → FC1 weight
            // flat_index * 3 + 2 → FC2 weight
            //--------------------------------------------------

            mult0 =
                flat_data *
                weight_mem[(flat_index * 3) + 0];

            mult1 =
                flat_data *
                weight_mem[(flat_index * 3) + 1];

            mult2 =
                flat_data *
                weight_mem[(flat_index * 3) + 2];

            //--------------------------------------------------
            // Accumulate
            //--------------------------------------------------

            acc0 <= acc0 + mult0;
            acc1 <= acc1 + mult1;
            acc2 <= acc2 + mult2;

            //--------------------------------------------------
            // Last flattened value
            //--------------------------------------------------

            if(flat_index == 8'd195)
            begin

                //------------------------------------------------
                // Product scale:
                //
                // 64 × 64 = 4096
                //
                // Shift right by 6:
                //
                // 4096 / 64 = 64
                //
                // This brings the result back to the
                // same fixed-point scale as the bias.
                //------------------------------------------------

                fc0 <=
                    ((acc0 + mult0) >>> 6)
                    + bias_mem[0];

                fc1 <=
                    ((acc1 + mult1) >>> 6)
                    + bias_mem[1];

                fc2 <=
                    ((acc2 + mult2) >>> 6)
                    + bias_mem[2];

                //------------------------------------------------
                // FC calculation completed
                //------------------------------------------------

                fc_valid <= 1'b1;

            end

        end

    end

end

endmodule
