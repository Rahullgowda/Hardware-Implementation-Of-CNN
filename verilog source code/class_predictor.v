//==============================================================
// Project : Single Layer Hardware CNN
// Module  : Class Predictor
//
// Description :
//     Compares the three Fully Connected outputs and
//     determines the predicted class.
//
//     FC0 -> Class 0
//     FC1 -> Class 1
//     FC2 -> Class 2
//
//     predicted_class = index of maximum FC score
//
//==============================================================

module class_predictor
#(
    parameter DATA_WIDTH = 48
)
(
    input clk,
    input reset,

    //----------------------------------------------------------
    // Fully Connected Outputs
    //----------------------------------------------------------

    input signed [DATA_WIDTH-1:0] fc0,
    input signed [DATA_WIDTH-1:0] fc1,
    input signed [DATA_WIDTH-1:0] fc2,

    //----------------------------------------------------------
    // FC Valid
    //----------------------------------------------------------

    input fc_valid,

    //----------------------------------------------------------
    // Prediction Output
    //----------------------------------------------------------

    output reg [1:0] predicted_class,

    output reg prediction_valid

);


//==============================================================
// Sequential Logic
//==============================================================

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        predicted_class <= 2'd0;

        prediction_valid <= 1'b0;

    end

    else
    begin

        //------------------------------------------------------
        // Default
        //------------------------------------------------------

        prediction_valid <= 1'b0;


        //------------------------------------------------------
        // Make Prediction
        //------------------------------------------------------

        if(fc_valid)
        begin

            //--------------------------------------------------
            // Class 0 has highest score
            //--------------------------------------------------

            if((fc0 >= fc1) && (fc0 >= fc2))
            begin

                predicted_class <= 2'd0;

            end


            //--------------------------------------------------
            // Class 1 has highest score
            //--------------------------------------------------

            else if((fc1 >= fc0) && (fc1 >= fc2))
            begin

                predicted_class <= 2'd1;

            end


            //--------------------------------------------------
            // Class 2 has highest score
            //--------------------------------------------------

            else
            begin

                predicted_class <= 2'd2;

            end


            //--------------------------------------------------
            // Prediction is valid
            //--------------------------------------------------

            prediction_valid <= 1'b1;

        end

    end

end

endmodule
