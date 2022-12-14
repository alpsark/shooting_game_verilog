//----------------------------------------------------------------------------------
//-- Vertical and Horizontal Sync generator for vga output
//----------------------------------------------------------------------------------

module sync_generator(
input wire vga_clk,
input wire reset,
output reg disp_en,
output reg hsync,
output reg vsync,
output reg [31:0] column,
output reg [31:0] row
);

  localparam h_total = 800;  //total number of pixels
  localparam h_disp = 640;  //displayed interval
  localparam h_pw = 96;  //pulse width
  localparam h_fp = 16;  //fronth porch
  localparam h_bp = 48;  //back porch
  localparam v_total = 521;
  localparam v_disp = 480;
  localparam v_pw = 2;
  localparam v_fp = 10;
  localparam v_bp = 29;

  reg [31:0] h_count;
  reg [31:0] v_count;

  always @(posedge vga_clk or posedge reset) begin
    if(reset) begin
      h_count <= h_disp + h_fp;
      v_count <= v_disp + v_fp;
      hsync <= 1'b0;
      vsync <= 1'b0;
      column <=   h_disp + h_fp;
      row <= v_disp + v_fp;
      disp_en <=  1'b0;
    end else begin
      if(h_count < (h_total - 1)) begin
        h_count <= h_count + 1;
      end else begin
        h_count <= 0;
      end
      if(h_count == (h_disp + h_fp)) begin
        if((v_count < (v_total - 1))) begin
          v_count <= v_count + 1;
        end else begin
          v_count <= 0;
        end
      end
      if(h_count < (h_disp + h_fp) || h_count > (h_total - h_bp)) begin
        hsync <= 1'b1;
      end else begin
        hsync <= 1'b0;
      end
      if(v_count < (v_disp + v_fp) || v_count > (v_total - v_bp)) begin
        vsync <= 1'b1;
      end else begin
        vsync <= 1'b0;
      end
      //pixel coords
      if(h_count < h_disp) begin
        column <= h_count;
      end else begin
        column <= column;
      end
      if(v_count < v_disp) begin
        row <= v_count;
      end else begin
        row <= row;
      end
      if(h_count < h_disp && v_count < v_disp) begin
        disp_en <= 1'b1;
      end else begin
        disp_en <= 1'b0;
      end
    end
  end


endmodule
