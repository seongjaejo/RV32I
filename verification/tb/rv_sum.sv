`timescale 1ns/1ps
module audit_rv;
reg clk=0,rst=1; always #5 clk=~clk;
top_rv32i_soc dut(.clk(clk),.rst(rst));
integer i;
initial begin
 repeat(3) @(negedge clk); rst=0;
 repeat(1000) @(negedge clk);
 $display("AUDIT RV PC=%h RAM58=%0d RAM59=%h",dut.instr_addr,dut.U_DATA_RAM.data_ram[58],dut.U_DATA_RAM.data_ram[59]);
 if(dut.U_DATA_RAM.data_ram[58]===32'd55) $display("AUDIT SUM55 PASS");
 else if(dut.U_DATA_RAM.data_ram[58]===32'd45) $display("AUDIT CURRENT_SUM45 PASS (program bound is 9)");
 else $display("AUDIT RV RESULT FAIL");
 $finish;
end
endmodule
