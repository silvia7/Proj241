

module draw_bg(begin_draw, clk, x, y, color, drawEn, done);

input begin_draw, clk;
output reg drawEn, done;
output reg [2:0] color;
output reg [7:0] x;
output reg [6:0] y;

//coding here
parameter A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011,
			 E = 3'b100, F = 3'b101, G = 3'b110;
			 
bg (address, clk, 3'b000, 1'b0, color_in);	

	reg [14:0] address; 
	reg writeEn;
	wire [2:0] color_in;

	initial begin 
	address = 15'b0;
	end
reg [2:0]state, n_state;

always @(*)
	begin
		case(state)
		A://initializing write elements
				if(begin_draw)
				n_state = C;
				else
				n_state = A;
				
		C://write only: increase address by 1
				n_state = D;
		D:	//write only: reading colour
				n_state = E; 
		E:	//x increment
			if(x < (8'd159)) begin
				n_state = C;
				end
			else
				n_state = F;
		F: //y increment
			if(y < (7'd119)) begin
				n_state = C;
			end
			else begin
				n_state = G;
			end
		G:
			if (!begin_draw)
				n_state = A; 
			else
				n_state = G;
		default: n_state = A;
		endcase
	end	

always@(posedge clk) begin
	state <= n_state;

	if(state == A) begin //initializing write
		//done <= 1'b0;
		x <= 8'b0;
		y <= 7'b0; 
		drawEn <= 1'b1;
		address <= 15'b0;
	end 
	
	else if (state ==  C)
		address <= address + 1;
	
	else if (state == D)
		color <= color_in;
		
	else if (state == E)begin
		x <= x + 1'b1;
		if(x == (8'd159))
		drawEn <= 1'b0;
		end
	else if (state == F) begin
		y <= y + 1'b1;
		x <= 8'b0;
		if (y == (7'd119)) begin
			drawEn <= 1'b0;
			done <= 1;
			end
		else
			drawEn <= 1'b1;
		end
		
	else//state 
		if (!begin_draw)
		done <= 1'b0;
end	
endmodule


