
vlib work

vlog -timescale=1ns/10ps -sv sync_fifo.v tb_sync_fifo.sv -l com.log

vsim -voptargs=+acc work.tb_sync_fifo

add wave tb_sync_fifo/inst/*

run 1us


