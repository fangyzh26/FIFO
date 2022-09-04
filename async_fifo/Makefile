#---------------------------- vcs --------------------------------

vcs: com sim dve

com:
	#vcs -full64 -sverilog -debug_all -timescale=1ns/10ps ram.v tb_ram.v -l com.log
	vcs -full64 -sverilog -debug_all -timescale=1ns/10ps -f file.list -l com.log

sim:
	./simv -l sim.log

dve:
	dve -full64 -vpd vcdplus.vpd &

#---------------------------- vsim --------------------------------

vsim: set_lib compile  simulate

set_lib:
	vlib work

compile:
	vlog -timescale=1ns/10ps -sv -f file.list -l vcom.log

simulate:
	vsim -voptargs=+acc work.tb_top_async_fifo 

cl:
	rm -rf  csrc *.log *.key *simv* *.vpd *DVE*  #clean vcs files
	rm -rf work *.mti *.mpf *.wlf *w transcript *.log # clean vsim files
