//genesis
//
// Lamprey.g - distributed spinal locomotor CPG of lamprey
// with supraspinal control.

include config.g
include chan.g
include library.g
include tools.g
include turn.g

if({argc})
    get_options {argv}
end
if(simtime < tturn + dturn)
    echo error: simtime cannot be less than tturn + dturn ({simtime} given)
    quit
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
make_cell node.p /library/node

stage creating cells ...
create neutral /model
// ts (tectum symm)
create_volume /library/cell /model/ts {nteccells} \
    {xtec} {-tecwidth / 2} 0.0 {teclength} {tecwidth} {tecdepth}

// tl (tectum left)
create_volume /library/cell /model/tl {nteccells} \
    {xtec} {-tecwidth} 0.0 {teclength} {tecwidth} {tecdepth}

// tr (tectum right)
create_volume /library/cell /model/tr {nteccells} \
    {xtec} 0.0 0.0 {teclength} {tecwidth} {tecdepth}

// mm (mlr)
create_volume /library/cell /model/mm {nmlrcells} \
    {xmlr} {-mlrwidth / 2} 0.0 {mlrlength} {mlrwidth} {mlrdepth}

// rl (rs left)
create_volume /library/cell /model/rl {nrscells} \
    {xrs} {-rswidth} 0.0 {rslength} {rswidth} {rsdepth}

// rr (rs right)
create_volume /library/cell /model/rr {nrscells} \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// pl (rs phasic left)
create_volume /library/cell /model/pl {nrscells} \
    {xrs} {-rswidth} 0.0 {rslength} {rswidth} {rsdepth}

// pr (rs phasic right)
create_volume /library/cell /model/pr {nrscells} \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// el (exc left)
create_volume /library/cell /model/el {necells} \
    {xcord} {-cordwidth / 2} 0.0 {preplength} {cordwidth / 2} {corddepth}

// er (exc right)
create_volume /library/cell /model/er {necells} \
    {xcord} 0.0 0.0 {preplength} {cordwidth / 2} {corddepth}

// il (inh left)
create_volume /library/cell /model/il {nicells} \
    {xcord} {-cordwidth / 2} 0.0 {preplength} {cordwidth / 2} {corddepth}

// ir (inh right)
create_volume /library/cell /model/ir {nicells} \
    {xcord} 0.0 0.0 {preplength} {cordwidth / 2} {corddepth}

// ml (moto left)
create_volume /library/cell /model/ml {nmcells} \
    {xcord} {-cordwidth / 2} 0.0 {preplength} {cordwidth / 2} {corddepth}

// mr (moto right)
create_volume /library/cell /model/mr {nmcells} \
    {xcord} 0.0 0.0 {preplength} {cordwidth / 2} {corddepth}

stage setting parameters ...
modfield /model/##[TYPE=compartment] Rm -uniform 0.5 1.5
modfield /model/##[TYPE=compartment] Cm -uniform 0.5 1.5
modfield /model/## tau -uniform 0.5 1.5
modfield /model/##/KCaN Gbar -uniform 0.5 1.5
modfield /model/##/KNa_slow Gbar -uniform 0.5 1.5
if({NO_SFA})
    modfield /model/t#[]/##/CaLVA Gbar -fixed 0.0
    modfield /model/t#[]/##/KCaN Gbar -fixed 0.0
    modfield /model/t#[]/##/KNa_slow Gbar -fixed 0.0
else
    modfield /model/ts[]/##/CaLVA Gbar -fixed 0.0
    modfield /model/ts[]/##/KCaN Gbar -fixed 0.0
    modfield /model/ts[]/##/KNa_slow Gbar -fixed 0.0
    modfield /model/tl[]/##/KCaN Gbar -fixed 0.1
    modfield /model/tl[]/##/KNa_slow Gbar -fixed 0.1
    modfield /model/tr[]/##/KCaN Gbar -fixed 0.1
    modfield /model/tr[]/##/KNa_slow Gbar -fixed 0.1
end
modfield /model/p#[]/soma inject -add -1.00e-9 1.00e-9
modfield /model/t#[]/soma inject -add -0.10e-9 0.10e-9
setfield /model/ts[]/soma inject {inject} -empty_ok

stage connecting cells ...

// ts -> mm
volume_connect /model/ts[]/iseg/spike /model/mm[]/##/AMPA mm \
    -1 -1 -1 1 1 1 {synptm}
volume_connect /model/ts[]/iseg/spike /model/mm[]/##/NMDA mm \
    -1 -1 -1 1 1 1 {synptm}
volume_delay /model/ts[]/iseg/spike /model/mm[]/##/AMPA {evelocity}
volume_delay /model/ts[]/iseg/spike /model/mm[]/##/NMDA {evelocity}
volume_weight /model/ts[]/iseg/spike /model/mm[]/##/AMPA {synwtm}
volume_weight /model/ts[]/iseg/spike /model/mm[]/##/NMDA {synwtm}

// mm -> rl
volume_connect /model/mm[]/iseg/spike /model/rl[]/##/AMPA rl \
    -1 -1 -1 1 1 1 {synpmr}
volume_connect /model/mm[]/iseg/spike /model/rl[]/##/NMDA rl \
    -1 -1 -1 1 1 1 {synpmr}
volume_delay /model/mm[]/iseg/spike /model/rl[]/##/AMPA {evelocity}
volume_delay /model/mm[]/iseg/spike /model/rl[]/##/NMDA {evelocity}
volume_weight /model/mm[]/iseg/spike /model/rl[]/##/AMPA {synwmr}
volume_weight /model/mm[]/iseg/spike /model/rl[]/##/NMDA {synwmr}

// mm -> rr
volume_connect /model/mm[]/iseg/spike /model/rr[]/##/AMPA rr \
    -1 -1 -1 1 1 1 {synpmr}
volume_connect /model/mm[]/iseg/spike /model/rr[]/##/NMDA rr \
    -1 -1 -1 1 1 1 {synpmr}
volume_delay /model/mm[]/iseg/spike /model/rr[]/##/AMPA {evelocity}
volume_delay /model/mm[]/iseg/spike /model/rr[]/##/NMDA {evelocity}
volume_weight /model/mm[]/iseg/spike /model/rr[]/##/AMPA {synwmr}
volume_weight /model/mm[]/iseg/spike /model/rr[]/##/NMDA {synwmr}

// mm -> pl
volume_connect /model/mm[]/iseg/spike /model/pl[]/##/AMPA pl \
    -1 -1 -1 1 1 1 {synpmr}
volume_connect /model/mm[]/iseg/spike /model/pl[]/##/NMDA pl \
    -1 -1 -1 1 1 1 {synpmr}
volume_delay /model/mm[]/iseg/spike /model/pl[]/##/AMPA {evelocity}
volume_delay /model/mm[]/iseg/spike /model/pl[]/##/NMDA {evelocity}
volume_weight /model/mm[]/iseg/spike /model/pl[]/##/AMPA {synwmr}
volume_weight /model/mm[]/iseg/spike /model/pl[]/##/NMDA {synwmr}

// mm -> pr
volume_connect /model/mm[]/iseg/spike /model/pr[]/##/AMPA pr \
    -1 -1 -1 1 1 1 {synpmr}
volume_connect /model/mm[]/iseg/spike /model/pr[]/##/NMDA pr \
    -1 -1 -1 1 1 1 {synpmr}
volume_delay /model/mm[]/iseg/spike /model/pr[]/##/AMPA {evelocity}
volume_delay /model/mm[]/iseg/spike /model/pr[]/##/NMDA {evelocity}
volume_weight /model/mm[]/iseg/spike /model/pr[]/##/AMPA {synwmr}
volume_weight /model/mm[]/iseg/spike /model/pr[]/##/NMDA {synwmr}

// tl -> rr
volume_connect /model/tl[]/iseg/spike /model/rr[]/##/AMPA rr \
    -1 -1 -1 1 1 1 {synptr}
volume_connect /model/tl[]/iseg/spike /model/rr[]/##/NMDA rr \
    -1 -1 -1 1 1 1 {synptr}
volume_delay /model/tl[]/iseg/spike /model/rr[]/##/AMPA {evelocity}
volume_delay /model/tl[]/iseg/spike /model/rr[]/##/NMDA {evelocity}
volume_weight /model/tl[]/iseg/spike /model/rr[]/##/AMPA {synwtr *0.1}
volume_weight /model/tl[]/iseg/spike /model/rr[]/##/NMDA {synwtr *0.1}

// tl -> pr
volume_connect /model/tl[]/iseg/spike /model/pr[]/##/AMPA pr \
    -1 -1 -1 1 1 1 {synptr}
volume_connect /model/tl[]/iseg/spike /model/pr[]/##/NMDA pr \
    -1 -1 -1 1 1 1 {synptr}
volume_delay /model/tl[]/iseg/spike /model/pr[]/##/AMPA {evelocity}
volume_delay /model/tl[]/iseg/spike /model/pr[]/##/NMDA {evelocity}
volume_weight /model/tl[]/iseg/spike /model/pr[]/##/AMPA {synwtr *0.9}
volume_weight /model/tl[]/iseg/spike /model/pr[]/##/NMDA {synwtr *0.9}

// tr -> rl
volume_connect /model/tr[]/iseg/spike /model/rl[]/##/AMPA rl \
    -1 -1 -1 1 1 1 {synptr}
volume_connect /model/tr[]/iseg/spike /model/rl[]/##/NMDA rl \
    -1 -1 -1 1 1 1 {synptr}
volume_delay /model/tr[]/iseg/spike /model/rl[]/##/AMPA {evelocity}
volume_delay /model/tr[]/iseg/spike /model/rl[]/##/NMDA {evelocity}
volume_weight /model/tr[]/iseg/spike /model/rl[]/##/AMPA {synwtr *0.1}
volume_weight /model/tr[]/iseg/spike /model/rl[]/##/NMDA {synwtr *0.1}

// tr -> pl
volume_connect /model/tr[]/iseg/spike /model/pl[]/##/AMPA pl \
    -1 -1 -1 1 1 1 {synptr}
volume_connect /model/tr[]/iseg/spike /model/pl[]/##/NMDA pl \
    -1 -1 -1 1 1 1 {synptr}
volume_delay /model/tr[]/iseg/spike /model/pl[]/##/AMPA {evelocity}
volume_delay /model/tr[]/iseg/spike /model/pl[]/##/NMDA {evelocity}
volume_weight /model/tr[]/iseg/spike /model/pl[]/##/AMPA {synwtr *0.9}
volume_weight /model/tr[]/iseg/spike /model/pl[]/##/NMDA {synwtr *0.9}

// rl -> el
volume_connect /model/rl[]/iseg/spike /model/el[]/##/AMPA el \
    -1 -1 -1 1 1 1 {synpre}
volume_connect /model/rl[]/iseg/spike /model/el[]/##/NMDA el \
    -1 -1 -1 1 1 1 {synpre}
volume_delay /model/rl[]/iseg/spike /model/el[]/##/AMPA {evelocity}
volume_delay /model/rl[]/iseg/spike /model/el[]/##/NMDA {evelocity}
volume_weight /model/rl[]/iseg/spike /model/el[]/##/AMPA {synwre}
volume_weight /model/rl[]/iseg/spike /model/el[]/##/NMDA {synwre}

// pl -> el
volume_connect /model/pl[]/iseg/spike /model/el[]/##/AMPA el \
    -1 -1 -1 1 1 1 {synpre}
volume_connect /model/pl[]/iseg/spike /model/el[]/##/NMDA el \
    -1 -1 -1 1 1 1 {synpre}
volume_delay /model/pl[]/iseg/spike /model/el[]/##/AMPA {evelocity}
volume_delay /model/pl[]/iseg/spike /model/el[]/##/NMDA {evelocity}
volume_weight /model/pl[]/iseg/spike /model/el[]/##/AMPA {synwre *0.0} \
    -decay {1 / ecaud} {synwre * 0.10}
volume_weight /model/pl[]/iseg/spike /model/el[]/##/NMDA {synwre *0.0} \
    -decay {1 / ecaud} {synwre * 0.10}

// rr -> er
volume_connect /model/rr[]/iseg/spike /model/er[]/##/AMPA er \
    -1 -1 -1 1 1 1 {synpre}
volume_connect /model/rr[]/iseg/spike /model/er[]/##/NMDA er \
    -1 -1 -1 1 1 1 {synpre}
volume_delay /model/rr[]/iseg/spike /model/er[]/##/AMPA {evelocity}
volume_delay /model/rr[]/iseg/spike /model/er[]/##/NMDA {evelocity}
volume_weight /model/rr[]/iseg/spike /model/er[]/##/AMPA {synwre}
volume_weight /model/rr[]/iseg/spike /model/er[]/##/NMDA {synwre}

// pr -> er
volume_connect /model/pr[]/iseg/spike /model/er[]/##/AMPA er \
    -1 -1 -1 1 1 1 {synpre}
volume_connect /model/pr[]/iseg/spike /model/er[]/##/NMDA er \
    -1 -1 -1 1 1 1 {synpre}
volume_delay /model/pr[]/iseg/spike /model/er[]/##/AMPA {evelocity}
volume_delay /model/pr[]/iseg/spike /model/er[]/##/NMDA {evelocity}
volume_weight /model/pr[]/iseg/spike /model/er[]/##/AMPA {synwre *0.0} \
    -decay {1 / ecaud} {synwre * 0.10}
volume_weight /model/pr[]/iseg/spike /model/er[]/##/NMDA {synwre *0.0} \
    -decay {1 / ecaud} {synwre * 0.10}

// rl -> il
volume_connect /model/rl[]/iseg/spike /model/il[]/##/AMPA il \
    -1 -1 -1 1 1 1 {synpri}
volume_connect /model/rl[]/iseg/spike /model/il[]/##/NMDA il \
    -1 -1 -1 1 1 1 {synpri}
volume_delay /model/rl[]/iseg/spike /model/il[]/##/AMPA {evelocity}
volume_delay /model/rl[]/iseg/spike /model/il[]/##/NMDA {evelocity}
volume_weight /model/rl[]/iseg/spike /model/il[]/##/AMPA {synwri}
volume_weight /model/rl[]/iseg/spike /model/il[]/##/NMDA {synwri}

// pl -> il
volume_connect /model/pl[]/iseg/spike /model/il[]/##/AMPA il \
    -1 -1 -1 1 1 1 {synpri}
volume_connect /model/pl[]/iseg/spike /model/il[]/##/NMDA il \
    -1 -1 -1 1 1 1 {synpri}
volume_delay /model/pl[]/iseg/spike /model/il[]/##/AMPA {evelocity}
volume_delay /model/pl[]/iseg/spike /model/il[]/##/NMDA {evelocity}
volume_weight /model/pl[]/iseg/spike /model/il[]/##/AMPA {synwri *0.0} \
    -decay {1 / ecaud} {synwri * 0.10}
volume_weight /model/pl[]/iseg/spike /model/il[]/##/NMDA {synwri *0.0} \
    -decay {1 / ecaud} {synwri * 0.10}

// rr -> ir
volume_connect /model/rr[]/iseg/spike /model/ir[]/##/AMPA ir \
    -1 -1 -1 1 1 1 {synpri}
volume_connect /model/rr[]/iseg/spike /model/ir[]/##/NMDA ir \
    -1 -1 -1 1 1 1 {synpri}
volume_delay /model/rr[]/iseg/spike /model/ir[]/##/AMPA {evelocity}
volume_delay /model/rr[]/iseg/spike /model/ir[]/##/NMDA {evelocity}
volume_weight /model/rr[]/iseg/spike /model/ir[]/##/AMPA {synwri}
volume_weight /model/rr[]/iseg/spike /model/ir[]/##/NMDA {synwri}

// pr -> ir
volume_connect /model/pr[]/iseg/spike /model/ir[]/##/AMPA ir \
    -1 -1 -1 1 1 1 {synpri}
volume_connect /model/pr[]/iseg/spike /model/ir[]/##/NMDA ir \
    -1 -1 -1 1 1 1 {synpri}
volume_delay /model/pr[]/iseg/spike /model/ir[]/##/AMPA {evelocity}
volume_delay /model/pr[]/iseg/spike /model/ir[]/##/NMDA {evelocity}
volume_weight /model/pr[]/iseg/spike /model/ir[]/##/AMPA {synwri *0.0} \
    -decay {1 / ecaud} {synwri * 0.10}
volume_weight /model/pr[]/iseg/spike /model/ir[]/##/NMDA {synwri *0.0} \
    -decay {1 / ecaud} {synwri * 0.10}

// rl -> ml
volume_connect /model/rl[]/iseg/spike /model/ml[]/##/AMPA ml \
    -1 -1 -1 1 1 1 {synprm}
volume_connect /model/rl[]/iseg/spike /model/ml[]/##/NMDA ml \
    -1 -1 -1 1 1 1 {synprm}
volume_delay /model/rl[]/iseg/spike /model/ml[]/##/AMPA {evelocity}
volume_delay /model/rl[]/iseg/spike /model/ml[]/##/NMDA {evelocity}
volume_weight /model/rl[]/iseg/spike /model/ml[]/##/AMPA {synwrm}
volume_weight /model/rl[]/iseg/spike /model/ml[]/##/NMDA {synwrm}

// pl -> ml
volume_connect /model/pl[]/iseg/spike /model/ml[]/##/AMPA ml \
    -1 -1 -1 1 1 1 {synprm}
volume_connect /model/pl[]/iseg/spike /model/ml[]/##/NMDA ml \
    -1 -1 -1 1 1 1 {synprm}
volume_delay /model/pl[]/iseg/spike /model/ml[]/##/AMPA {evelocity}
volume_delay /model/pl[]/iseg/spike /model/ml[]/##/NMDA {evelocity}
volume_weight /model/pl[]/iseg/spike /model/ml[]/##/AMPA {synwrm *0.0} \
    -decay {1 / ecaud} {synwrm * 0.5}
volume_weight /model/pl[]/iseg/spike /model/ml[]/##/NMDA {synwrm *0.0} \
    -decay {1 / ecaud} {synwrm * 0.5}

// rr -> mr
volume_connect /model/rr[]/iseg/spike /model/mr[]/##/AMPA mr \
    -1 -1 -1 1 1 1 {synprm}
volume_connect /model/rr[]/iseg/spike /model/mr[]/##/NMDA mr \
    -1 -1 -1 1 1 1 {synprm}
volume_delay /model/rr[]/iseg/spike /model/mr[]/##/AMPA {evelocity}
volume_delay /model/rr[]/iseg/spike /model/mr[]/##/NMDA {evelocity}
volume_weight /model/rr[]/iseg/spike /model/mr[]/##/AMPA {synwrm}
volume_weight /model/rr[]/iseg/spike /model/mr[]/##/NMDA {synwrm}

// pr -> mr
volume_connect /model/pr[]/iseg/spike /model/mr[]/##/AMPA mr \
    -1 -1 -1 1 1 1 {synprm}
volume_connect /model/pr[]/iseg/spike /model/mr[]/##/NMDA mr \
    -1 -1 -1 1 1 1 {synprm}
volume_delay /model/pr[]/iseg/spike /model/mr[]/##/AMPA {evelocity}
volume_delay /model/pr[]/iseg/spike /model/mr[]/##/NMDA {evelocity}
volume_weight /model/pr[]/iseg/spike /model/mr[]/##/AMPA {synwrm *0.0} \
    -decay {1 / ecaud} {synwrm * 0.5}
volume_weight /model/pr[]/iseg/spike /model/mr[]/##/NMDA {synwrm *0.0} \
    -decay {1 / ecaud} {synwrm * 0.5}

// el -> el
volume_connect /model/el[]/iseg/spike /model/el[]/##/AMPA el \
    {-erost} -1 -1 {ecaud} 1 1 {synpee}
volume_connect /model/el[]/iseg/spike /model/el[]/##/NMDA el \
    {-erost} -1 -1 {ecaud} 1 1 {synpee}
volume_delay /model/el[]/iseg/spike /model/el[]/##/AMPA {evelocity}
volume_delay /model/el[]/iseg/spike /model/el[]/##/NMDA {evelocity}
volume_weight /model/el[]/iseg/spike /model/el[]/##/AMPA {synwee}
volume_weight /model/el[]/iseg/spike /model/el[]/##/NMDA {synwee}

// el -> il
volume_connect /model/el[]/iseg/spike /model/il[]/##/AMPA il \
    {-erost} -1 -1 {ecaud} 1 1 {synpei}
volume_connect /model/el[]/iseg/spike /model/il[]/##/NMDA il \
    {-erost} -1 -1 {ecaud} 1 1 {synpei}
volume_delay /model/el[]/iseg/spike /model/il[]/##/AMPA {evelocity}
volume_delay /model/el[]/iseg/spike /model/il[]/##/NMDA {evelocity}
volume_weight /model/el[]/iseg/spike /model/il[]/##/AMPA {synwei}
volume_weight /model/el[]/iseg/spike /model/il[]/##/NMDA {synwei}

// el -> pl
volume_connect /model/el[]/iseg/spike /model/pl[]/##/AMPA pl \
    {-erost} -1 -1 {ecaud} 1 1 {synper}
volume_connect /model/el[]/iseg/spike /model/pl[]/##/NMDA pl \
    {-erost} -1 -1 {ecaud} 1 1 {synper}
volume_delay /model/el[]/iseg/spike /model/pl[]/##/AMPA {evelocity}
volume_delay /model/el[]/iseg/spike /model/pl[]/##/NMDA {evelocity}
volume_weight /model/el[]/iseg/spike /model/pl[]/##/AMPA {synwer * RS_MOD}
volume_weight /model/el[]/iseg/spike /model/pl[]/##/NMDA {synwer * RS_MOD}

// el -> ml
volume_connect /model/el[]/iseg/spike /model/ml[]/##/AMPA ml \
    {-erost} -1 -1 {ecaud} 1 1 {synpem}
volume_connect /model/el[]/iseg/spike /model/ml[]/##/NMDA ml \
    {-erost} -1 -1 {ecaud} 1 1 {synpem}
volume_delay /model/el[]/iseg/spike /model/ml[]/##/AMPA {evelocity}
volume_delay /model/el[]/iseg/spike /model/ml[]/##/NMDA {evelocity}
volume_weight /model/el[]/iseg/spike /model/ml[]/##/AMPA {synwem}
volume_weight /model/el[]/iseg/spike /model/ml[]/##/NMDA {synwem}

// er -> er
volume_connect /model/er[]/iseg/spike /model/er[]/##/AMPA er \
    {-erost} -1 -1 {ecaud} 1 1 {synpee}
volume_connect /model/er[]/iseg/spike /model/er[]/##/NMDA er \
    {-erost} -1 -1 {ecaud} 1 1 {synpee}
volume_delay /model/er[]/iseg/spike /model/er[]/##/AMPA {evelocity}
volume_delay /model/er[]/iseg/spike /model/er[]/##/NMDA {evelocity}
volume_weight /model/er[]/iseg/spike /model/er[]/##/AMPA {synwee}
volume_weight /model/er[]/iseg/spike /model/er[]/##/NMDA {synwee}

// er -> ir
volume_connect /model/er[]/iseg/spike /model/ir[]/##/AMPA ir \
    {-erost} -1 -1 {ecaud} 1 1 {synpei}
volume_connect /model/er[]/iseg/spike /model/ir[]/##/NMDA ir \
    {-erost} -1 -1 {ecaud} 1 1 {synpei}
volume_delay /model/er[]/iseg/spike /model/ir[]/##/AMPA {evelocity}
volume_delay /model/er[]/iseg/spike /model/ir[]/##/NMDA {evelocity}
volume_weight /model/er[]/iseg/spike /model/ir[]/##/AMPA {synwei}
volume_weight /model/er[]/iseg/spike /model/ir[]/##/NMDA {synwei}

// er -> pr
volume_connect /model/er[]/iseg/spike /model/pr[]/##/AMPA pr \
    {-erost} -1 -1 {ecaud} 1 1 {synper}
volume_connect /model/er[]/iseg/spike /model/pr[]/##/NMDA pr \
    {-erost} -1 -1 {ecaud} 1 1 {synper}
volume_delay /model/er[]/iseg/spike /model/pr[]/##/AMPA {evelocity}
volume_delay /model/er[]/iseg/spike /model/pr[]/##/NMDA {evelocity}
volume_weight /model/er[]/iseg/spike /model/pr[]/##/AMPA {synwer * RS_MOD}
volume_weight /model/er[]/iseg/spike /model/pr[]/##/NMDA {synwer * RS_MOD}

// er -> mr
volume_connect /model/er[]/iseg/spike /model/mr[]/##/AMPA mr \
    {-erost} -1 -1 {ecaud} 1 1 {synpem}
volume_connect /model/er[]/iseg/spike /model/mr[]/##/NMDA mr \
    {-erost} -1 -1 {ecaud} 1 1 {synpem}
volume_delay /model/er[]/iseg/spike /model/mr[]/##/AMPA {evelocity}
volume_delay /model/er[]/iseg/spike /model/mr[]/##/NMDA {evelocity}
volume_weight /model/er[]/iseg/spike /model/mr[]/##/AMPA {synwem}
volume_weight /model/er[]/iseg/spike /model/mr[]/##/NMDA {synwem}

// il -> er
volume_connect /model/il[]/iseg/spike /model/er[]/##/Glyc er \
    {-irost} -1 -1 {icaud} 1 1 {synpie}
volume_delay /model/il[]/iseg/spike /model/er[]/##/Glyc {ivelocity}
volume_weight /model/il[]/iseg/spike /model/er[]/##/Glyc {synwie}

// il -> ir
volume_connect /model/il[]/iseg/spike /model/ir[]/##/Glyc ir \
    {-irost} -1 -1 {icaud} 1 1 {synpii}
volume_delay /model/il[]/iseg/spike /model/ir[]/##/Glyc {ivelocity}
volume_weight /model/il[]/iseg/spike /model/ir[]/##/Glyc {synwii}

// il -> pr
volume_connect /model/il[]/iseg/spike /model/pr[]/##/Glyc pr \
    {-irost} -1 -1 {icaud} 1 1 {synpir}
volume_delay /model/il[]/iseg/spike /model/pr[]/##/Glyc {ivelocity}
volume_weight /model/il[]/iseg/spike /model/pr[]/##/Glyc {synwir * RS_MOD}

// il -> mr
volume_connect /model/il[]/iseg/spike /model/mr[]/##/Glyc mr \
    {-irost} -1 -1 {icaud} 1 1 {synpim}
volume_delay /model/il[]/iseg/spike /model/mr[]/##/Glyc {ivelocity}
volume_weight /model/il[]/iseg/spike /model/mr[]/##/Glyc {synwim}

// ir -> el
volume_connect /model/ir[]/iseg/spike /model/el[]/##/Glyc el \
    {-irost} -1 -1 {icaud} 1 1 {synpie}
volume_delay /model/ir[]/iseg/spike /model/el[]/##/Glyc {ivelocity}
volume_weight /model/ir[]/iseg/spike /model/el[]/##/Glyc {synwie}

// ir -> il
volume_connect /model/ir[]/iseg/spike /model/il[]/##/Glyc il \
    {-irost} -1 -1 {icaud} 1 1 {synpii}
volume_delay /model/ir[]/iseg/spike /model/il[]/##/Glyc {ivelocity}
volume_weight /model/ir[]/iseg/spike /model/il[]/##/Glyc {synwii}

// ir -> pl
volume_connect /model/ir[]/iseg/spike /model/pl[]/##/Glyc pl \
    {-irost} -1 -1 {icaud} 1 1 {synpir}
volume_delay /model/ir[]/iseg/spike /model/pl[]/##/Glyc {ivelocity}
volume_weight /model/ir[]/iseg/spike /model/pl[]/##/Glyc {synwir * RS_MOD}

// ir -> ml
volume_connect /model/ir[]/iseg/spike /model/ml[]/##/Glyc ml \
    {-irost} -1 -1 {icaud} 1 1 {synpim}
volume_delay /model/ir[]/iseg/spike /model/ml[]/##/Glyc {ivelocity}
volume_weight /model/ir[]/iseg/spike /model/ml[]/##/Glyc {synwim}

stage creating output nodes ...

// oml (moto out left)
create_volume /library/node /model/oml {nocells} \
    {xcord} {-cordwidth / 2} 0.0 {preplength} 0.0 0.0

// omr (moto out right)
create_volume /library/node /model/omr {nocells} \
    {xcord} {cordwidth / 2} 0.0 {preplength} 0.0 0.0

// orl (out rs tonic left)
create_volume /library/node /model/orl 1 \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// opl (out rs phasic left)
create_volume /library/node /model/opl 1 \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// orr (out rs tonic right)
create_volume /library/node /model/orr 1 \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// opr (out rs phasic right)
create_volume /library/node /model/opr 1 \
    {xrs} 0.0 0.0 {rslength} {rswidth} {rsdepth}

// ots (out tect symmetric)
create_volume /library/node /model/ots 1 \
    {xtec} {-tecwidth} 0.0 {teclength} {tecwidth} {tecdepth}

// otl (out tect left)
create_volume /library/node /model/otl 1 \
    {xtec} {-tecwidth} 0.0 {teclength} {tecwidth} {tecdepth}

// otr (out tect right)
create_volume /library/node /model/otr 1 \
    {xtec} 0.0 0.0 {teclength} {tecwidth} {tecdepth}

// omm (out mlr)
create_volume /library/node /model/omm 1 \
    {xmlr} 0.0 0.0 {mlrlength} {mlrwidth} {mlrdepth}

stage connecting output nodes ...

// ml -> oml
volume_connect /model/ml[]/iseg/spike /model/oml[]/##/AMPA oml \
    {-mrost} -1 -1 {mcaud} 1 1 {synpmo}
volume_delay /model/ml[]/iseg/spike /model/oml[]/##/AMPA {evelocity}
volume_weight /model/ml[]/iseg/spike /model/oml[]/##/AMPA {synwmo}

// mr -> omr
volume_connect /model/mr[]/iseg/spike /model/omr[]/##/AMPA omr \
    {-mrost} -1 -1 {mcaud} 1 1 {synpmo}
volume_delay /model/mr[]/iseg/spike /model/omr[]/##/AMPA {evelocity}
volume_weight /model/mr[]/iseg/spike /model/omr[]/##/AMPA {synwmo}

// rl -> orl
volume_connect /model/rl[]/iseg/spike /model/orl[]/##/AMPA orl \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/rl[]/iseg/spike /model/orl[]/##/AMPA {evelocity}
volume_weight /model/rl[]/iseg/spike /model/orl[]/##/AMPA {synwmo}

// pl -> opl
volume_connect /model/pl[]/iseg/spike /model/opl[]/##/AMPA opl \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/pl[]/iseg/spike /model/opl[]/##/AMPA {evelocity}
volume_weight /model/pl[]/iseg/spike /model/opl[]/##/AMPA {synwmo}

// rr -> orr
volume_connect /model/rr[]/iseg/spike /model/orr[]/##/AMPA orr \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/rr[]/iseg/spike /model/orr[]/##/AMPA {evelocity}
volume_weight /model/rr[]/iseg/spike /model/orr[]/##/AMPA {synwmo}

// pr -> opr
volume_connect /model/pr[]/iseg/spike /model/opr[]/##/AMPA opr \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/pr[]/iseg/spike /model/opr[]/##/AMPA {evelocity}
volume_weight /model/pr[]/iseg/spike /model/opr[]/##/AMPA {synwmo}

// ts -> ots
volume_connect /model/ts[]/iseg/spike /model/ots[]/##/AMPA ots \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/ts[]/iseg/spike /model/ots[]/##/AMPA {evelocity}
volume_weight /model/ts[]/iseg/spike /model/ots[]/##/AMPA {synwmo}

// tl -> otl
volume_connect /model/tl[]/iseg/spike /model/otl[]/##/AMPA otl \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/tl[]/iseg/spike /model/otl[]/##/AMPA {evelocity}
volume_weight /model/tl[]/iseg/spike /model/otl[]/##/AMPA {synwmo}

// tr -> otr
volume_connect /model/tr[]/iseg/spike /model/otr[]/##/AMPA otr \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/tr[]/iseg/spike /model/otr[]/##/AMPA {evelocity}
volume_weight /model/tr[]/iseg/spike /model/otr[]/##/AMPA {synwmo}

// mm -> omm
volume_connect /model/mm[]/iseg/spike /model/omm[]/##/AMPA omm \
    -1 -1 -1 1 1 1 {synpmo}
volume_delay /model/mm[]/iseg/spike /model/omm[]/##/AMPA {evelocity}
volume_weight /model/mm[]/iseg/spike /model/omm[]/##/AMPA {synwmo}

stage creating data recorders ...
recspikes /model/ts[]/iseg/spike output/_spts spts
recspikes /model/tl[]/iseg/spike output/_sptl sptl
recspikes /model/tr[]/iseg/spike output/_sptr sptr
recspikes /model/mm[]/iseg/spike output/_spmm spmm
recspikes /model/rl[]/iseg/spike output/_sprl sprl
recspikes /model/rr[]/iseg/spike output/_sprr sprr
recspikes /model/pl[]/iseg/spike output/_sppl sppl
recspikes /model/pr[]/iseg/spike output/_sppr sppr
recspikes /model/el[]/iseg/spike output/_spel spel
recspikes /model/er[]/iseg/spike output/_sper sper
recspikes /model/il[]/iseg/spike output/_spil spil
recspikes /model/ir[]/iseg/spike output/_spir spir
recspikes /model/ml[]/iseg/spike output/_spml spml
recspikes /model/mr[]/iseg/spike output/_spmr spmr
recdata /model/oml[]/soma Vm /output/vmoml {simtime}
recdata /model/omr[]/soma Vm /output/vmomr {simtime}
recdata /model/orl[]/soma Vm /output/vmorl {simtime}
recdata /model/opl[]/soma Vm /output/vmopl {simtime}
recdata /model/orr[]/soma Vm /output/vmorr {simtime}
recdata /model/opr[]/soma Vm /output/vmopr {simtime}
recdata /model/ots[]/soma Vm /output/vmots {simtime}
recdata /model/otl[]/soma Vm /output/vmotl {simtime}
recdata /model/otr[]/soma Vm /output/vmotr {simtime}
recdata /model/omm[]/soma Vm /output/vmomm {simtime}

stage scheduling simulation ...
simschedule

stage simulating {simtime} sec ...

step {tturn} -time

stage turning right ...
setfield /model/tl[]/soma inject {aturn} -empty_ok
modfield /model/tl[]/soma inject -add -0.1e-9 0.1e-9
stage 
step {dturn} -time
stage
setfield /model/tl[]/soma inject 0.0 -empty_ok
stage
step {simtime - tturn - dturn} -time

stage all done, exiting ...
writedata /output/vmoml[] output/_vmoml
writedata /output/vmomr[] output/_vmomr
writedata /output/vmorl[] output/_vmorl
writedata /output/vmopl[] output/_vmopl
writedata /output/vmorr[] output/_vmorr
writedata /output/vmopr[] output/_vmopr
writedata /output/vmots[] output/_vmots
writedata /output/vmotl[] output/_vmotl
writedata /output/vmotr[] output/_vmotr
writedata /output/vmomm[] output/_vmomm
simfinish
quit

