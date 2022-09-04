vcs:com sim dve

com:
	vcs -full64 -sverilog -debug_all -timescale=1ns/10ps -f file.list -l com.log

sim:
	./simv -l sim.log

dve:
	dve -full64 -vpd vcdplus.vpd &

cl:
	rm -rf csrc *.log *.key *DVE* *simv* *.vpd 
	rm -rf work *.mti *.mpf *.wlf *w transcript *.log

#----------------------------------------------------------------
vsim: set_lib compile simulate 

set_lib:
	vlib work

compile:
	vlog -timescale=1ns/10ps -sv sync_fifo.v tb_sync_fifo.sv -l com.log

simulate:
	vsim -voptargs=+acc work.tb_sync_fifo 

	#add wave tb_sync_fifo/inst/*

