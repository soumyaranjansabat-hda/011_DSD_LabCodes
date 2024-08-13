onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /norgate/b
add wave -noupdate /norgate/a
add wave -noupdate /norgate/c
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {130323 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {40 ns} {840 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 0 -starttime 0ns -endtime 400ns sim:/norgate/b 
wave modify -driver freeze -pattern constant -value 1 -starttime 400ns -endtime 800ns Edit:/norgate/b 
wave create -driver freeze -pattern constant -value 1 -starttime 0ns -endtime 800ns sim:/norgate/a 
wave edit invert -start 101649ps -end 299498ps Edit:/norgate/a 
WaveCollapseAll -1
wave clipboard restore
