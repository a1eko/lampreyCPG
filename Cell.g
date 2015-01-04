//genesis
//
// Cell.g - single neuron simulation

include config.g
include chan.g
include library.g
include tools.g

if({argc})
    get_options {argv}
end
siminit

stage making prototypes ...
create neutral /library
disable /library
pushe /library
    create compartment compartment
pope
make_channels /library
make_cell {cellproto} /library/cell

stage creating cell ...
create neutral /model
create_volume /library/cell /model/ts 1 0 0 0 0 0 0

stage setting parameters ...
setfield /model/ts[]/soma inject {inject}

stage creating data recorders ...
recspikes /model/ts[]/iseg/spike output/_spts spts
recdata /model/ts[]/soma Vm /output/vmts {simtime}

stage scheduling simulation ...
simschedule

stage simulating {simtime} sec ...
step {simtime} -time

stage all done, exiting ...
writedata /output/vmts output/_vmts
simfinish
quit
