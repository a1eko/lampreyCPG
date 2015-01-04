//genesis
//
// Pop.g - inhomogeneous neuron population

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
// ts (tectum symm)
create_volume /library/cell /model/ts 10 \
    {xtec} {-tecwidth / 2} 0.0 {teclength} {tecwidth} {tecdepth}

stage setting parameters ...
modfield /model/##[TYPE=compartment] Rm -uniform 0.5 1.5
modfield /model/##[TYPE=compartment] Cm -uniform 0.5 1.5
modfield /model/## tau -uniform 0.5 1.5
modfield /model/##/KCaN Gbar -uniform 0.5 1.5
modfield /model/##/KNa_slow Gbar -uniform 0.5 1.5
modfield /model/t#[]/##/CaLVA Gbar -fixed 0.0
modfield /model/t#[]/##/KCaN Gbar -fixed 0.0
modfield /model/t#[]/##/KNa_slow Gbar -fixed 0.0
setfield /model/ts[]/soma inject {inject} -empty_ok

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

