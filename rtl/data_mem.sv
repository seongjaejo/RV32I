`timescale 1ns / 1ps

`include "define.vh"

module data_mem(
	input  logic 		clk,
	input  logic 		dwe,
	input  logic [2:0]	mem_mode,
	input  logic [31:0] daddr,
	input  logic [31:0] dwdata,
	output logic [31:0] drdata
    );

	logic [31:0] data_ram[0:63];

	always_ff @(posedge clk) begin
		if (dwe) begin
			case(mem_mode)
				// SW
				`SW: begin
				data_ram[daddr[31:2]] <= dwdata; //4비트씩 증가하는게 1비트씩 증가하는걸로 바뀜
				end

	            // SH
                `SH: begin
                    case(daddr[1])
                        // lower 16bit
                        1'b0:
                            data_ram[daddr[31:2]][15:0]
                                <= dwdata[15:0];
                        // upper 16bit
                        1'b1:
                            data_ram[daddr[31:2]][31:16]
                                <= dwdata[15:0];
                    endcase
                end

                // SB
                `SB: begin
                    case(daddr[1:0])
                        2'b00:
                            data_ram[daddr[31:2]][7:0]
                                <= dwdata[7:0];
                        2'b01:
                            data_ram[daddr[31:2]][15:8]
                                <= dwdata[7:0];
                        2'b10:
                            data_ram[daddr[31:2]][23:16]
                                <= dwdata[7:0];
                        2'b11:
                            data_ram[daddr[31:2]][31:24]
                                <= dwdata[7:0];
                    endcase			
				end
			endcase
		end
	end

always_comb begin
    drdata = 32'd0;

    case(mem_mode)

        `LW: begin
            drdata = data_ram[daddr[31:2]];
        end

        `LB: begin //signed
            case(daddr[1:0])
                2'b00: drdata = {{24{data_ram[daddr[31:2]][7]}}, data_ram[daddr[31:2]][7:0]};
                2'b01: drdata = {{24{data_ram[daddr[31:2]][15]}}, data_ram[daddr[31:2]][15:8]};
				// 뒤에 data_ram[daddr[31:2]][15:8]로 data_ram에서 32bit 전체
				// 가져오고, 그중에 [15:8]만 나의 데이터가 됨 즉, [15:8]구간이
				// 8bit의 data이고, 맨 앞의 부호비트를 24번 확장시켜32bit로 만들어줌
                2'b10: drdata = {{24{data_ram[daddr[31:2]][23]}}, data_ram[daddr[31:2]][23:16]};
                2'b11: drdata = {{24{data_ram[daddr[31:2]][31]}}, data_ram[daddr[31:2]][31:24]};
            endcase
        end

        `LBU: begin // unsigned
            case(daddr[1:0])
                2'b00: drdata = {24'd0, data_ram[daddr[31:2]][7:0]};
                2'b01: drdata = {24'd0, data_ram[daddr[31:2]][15:8]};
                2'b10: drdata = {24'd0, data_ram[daddr[31:2]][23:16]};
                2'b11: drdata = {24'd0, data_ram[daddr[31:2]][31:24]};
            endcase
        end

        `LH: begin // signed
            case(daddr[1])
                1'b0: drdata = {{16{data_ram[daddr[31:2]][15]}}, data_ram[daddr[31:2]][15:0]};
                1'b1: drdata = {{16{data_ram[daddr[31:2]][31]}}, data_ram[daddr[31:2]][31:16]};
            endcase
        end

        `LHU: begin // unsigned
            case(daddr[1])
                1'b0: drdata = {16'd0, data_ram[daddr[31:2]][15:0]};
                1'b1: drdata = {16'd0, data_ram[daddr[31:2]][31:16]};
            endcase
        end

    endcase
end
///////////////////////////////////////
//initial begin
//    data_ram[1] = 32'h12345678;
//end

endmodule
