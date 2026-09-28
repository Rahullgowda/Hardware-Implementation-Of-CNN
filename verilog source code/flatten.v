//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Flatten
//
// Description :
//     Store 4 feature maps of 7x7 and flatten them into
//     196 sequential values.
//
// Keras Flatten ordering:
//
//     (row0,col0,ch0)
//     (row0,col0,ch1)
//     (row0,col0,ch2)
//     (row0,col0,ch3)
//
//     (row0,col1,ch0)
//     (row0,col1,ch1)
//     (row0,col1,ch2)
//     (row0,col1,ch3)
//
//     ...
//
//     (row6,col6,ch0)
//     (row6,col6,ch1)
//     (row6,col6,ch2)
//     (row6,col6,ch3)
//
// Total:
//     7 × 7 × 4 = 196 values
//
// This ordering MUST match the Keras Dense layer.
//==============================================================

module flatten
#(
    parameter DATA_WIDTH  = 32,
    parameter FEATURE_SIZE = 7
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // MaxPool Inputs
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] pool0,
    input signed [DATA_WIDTH-1:0] pool1,
    input signed [DATA_WIDTH-1:0] pool2,
    input signed [DATA_WIDTH-1:0] pool3,

    input pool_valid,

    input [3:0] pool_row,
    input [3:0] pool_col,

    //----------------------------------------------------------
    // Flatten Output
    //----------------------------------------------------------

    output reg signed [DATA_WIDTH-1:0] flat_data,

    output reg flat_valid,

    output reg [7:0] flat_index
);


//==============================================================
// Feature Map Memories
//
// Each feature map is 7x7.
//
// feature_mem0 = ReLU/Pool output of filter 0
// feature_mem1 = ReLU/Pool output of filter 1
// feature_mem2 = ReLU/Pool output of filter 2
// feature_mem3 = ReLU/Pool output of filter 3
//==============================================================

reg signed [DATA_WIDTH-1:0] feature_mem0
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem1
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem2
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];

reg signed [DATA_WIDTH-1:0] feature_mem3
[0:FEATURE_SIZE-1][0:FEATURE_SIZE-1];


//==============================================================
// Flatten Control
//
// channel = 0,1,2,3
//
// Channel changes FIRST.
// Then column changes.
// Then row changes.
//
// This gives:
//
// index 0  = ch0,row0,col0
// index 1  = ch1,row0,col0
// index 2  = ch2,row0,col0
// index 3  = ch3,row0,col0
//
// index 4  = ch0,row0,col1
// ...
//==============================================================

reg [1:0] channel;

reg [3:0] read_row;

reg [3:0] read_col;

reg flattening;


//==============================================================
// Loop Variables
//==============================================================

integer i;
integer j;


//==============================================================
// Sequential Logic
//==============================================================

always @(posedge clk or posedge reset)
begin

    //----------------------------------------------------------
    // RESET
    //----------------------------------------------------------

    if(reset)
    begin

        //------------------------------------------------------
        // Flatten outputs
        //------------------------------------------------------

        flat_data  <= 0;

        flat_valid <= 1'b0;

        flat_index <= 0;


        //------------------------------------------------------
        // Flatten control
        //------------------------------------------------------

        channel    <= 0;

        read_row   <= 0;

        read_col   <= 0;

        flattening <= 1'b0;


        //------------------------------------------------------
        // Clear feature map memories
        //------------------------------------------------------

        for(i = 0; i < FEATURE_SIZE; i = i + 1)
        begin

            for(j = 0; j < FEATURE_SIZE; j = j + 1)
            begin

                feature_mem0[i][j] <= 0;

                feature_mem1[i][j] <= 0;

                feature_mem2[i][j] <= 0;

                feature_mem3[i][j] <= 0;

            end

        end

    end


    //----------------------------------------------------------
    // NORMAL OPERATION
    //----------------------------------------------------------

    else
    begin

        //------------------------------------------------------
        // Default
        //
        // flat_valid is HIGH for one clock for each
        // flattened value.
        //------------------------------------------------------

        flat_valid <= 1'b0;


        //------------------------------------------------------
        // STORE MAXPOOL OUTPUTS
        //------------------------------------------------------

        if(pool_valid)
        begin

            //--------------------------------------------------
            // Store current pooled values
            //--------------------------------------------------

            feature_mem0[pool_row][pool_col] <= pool0;

            feature_mem1[pool_row][pool_col] <= pool1;

            feature_mem2[pool_row][pool_col] <= pool2;

            feature_mem3[pool_row][pool_col] <= pool3;


            //--------------------------------------------------
            // Final pooled location
            //
            // Once (6,6) arrives, all 49 locations of all
            // four feature maps have been received.
            //--------------------------------------------------

            if((pool_row == 4'd6) &&
               (pool_col == 4'd6))
            begin

                //------------------------------------------------
                // Start flattening on NEXT clock.
                //
                // This is important because the memory writes
                // above use non-blocking assignments.
                //------------------------------------------------

                flattening <= 1'b1;

                channel  <= 2'd0;

                read_row <= 4'd0;

                read_col <= 4'd0;

                flat_index <= 8'd0;

            end

        end


        //------------------------------------------------------
        // FLATTEN OPERATION
        //------------------------------------------------------

        if(flattening)
        begin

            //--------------------------------------------------
            // Select channel
            //--------------------------------------------------

            case(channel)

                //------------------------------------------------
                // Channel 0
                //------------------------------------------------

                2'd0:
                begin

                    flat_data <=
                        feature_mem0[read_row][read_col];

                end


                //------------------------------------------------
                // Channel 1
                //------------------------------------------------

                2'd1:
                begin

                    flat_data <=
                        feature_mem1[read_row][read_col];

                end


                //------------------------------------------------
                // Channel 2
                //------------------------------------------------

                2'd2:
                begin

                    flat_data <=
                        feature_mem2[read_row][read_col];

                end


                //------------------------------------------------
                // Channel 3
                //------------------------------------------------

                2'd3:
                begin

                    flat_data <=
                        feature_mem3[read_row][read_col];

                end

            endcase


            //--------------------------------------------------
            // Current Flatten Index
            //
            // Keras ordering:
            //
            // index =
            //     ((row * 7) + col) * 4 + channel
            //
            //--------------------------------------------------

            flat_index <=
                ((read_row * 8'd7) + read_col) * 8'd4
                + channel;


            //--------------------------------------------------
            // Valid
            //--------------------------------------------------

            flat_valid <= 1'b1;


            //--------------------------------------------------
            // MOVE TO NEXT FLATTEN VALUE
            //
            // Channel changes fastest.
            //--------------------------------------------------

            if(channel == 2'd3)
            begin

                //------------------------------------------------
                // Finished four channels for this pixel
                //------------------------------------------------

                channel <= 2'd0;


                //------------------------------------------------
                // Move to next column
                //------------------------------------------------

                if(read_col == 4'd6)
                begin

                    read_col <= 4'd0;


                    //------------------------------------------------
                    // Move to next row
                    //------------------------------------------------

                    if(read_row == 4'd6)
                    begin

                        //------------------------------------------------
                        // All 196 values completed
                        //------------------------------------------------

                        read_row <= 4'd0;

                        flattening <= 1'b0;

                    end

                    else
                    begin

                        read_row <= read_row + 1'b1;

                    end

                end

                else
                begin

                    read_col <= read_col + 1'b1;

                end

            end

            else
            begin

                //------------------------------------------------
                // Move to next channel
                //------------------------------------------------

                channel <= channel + 1'b1;

            end

        end

    end

end

endmodule
