//genesis
//
// library.g - creating library of ionic chanels and a prototype cell

function make_channels(path)
    str path
    pushe {path}
        make_Na
        make_shNa
        make_Kt
        make_Ks
        make_CaN
        make_CaN_pool
        make_KCaN
        make_CaL
        make_CaLVA
        make_Na_pool
        make_KNa
        make_Na_slow_pool
        make_KNa_slow
        make_Glyc
        make_AMPA
        make_NMDA
        make_CaNMDA
        make_CaNMDA_pool
        make_KCaNMDA
    pope
end

function make_spiker
    if({exists spike})
        return
    end
    str chanpath = "spike"
    create spikegen {chanpath}
    setfield {chanpath} thresh -40e-3 abs_refract 1e-3 output_amp 1
    addmsg . {chanpath} INPUT Vm
end

function make_cell(filename, path)
    str filename, path
    str chan, comp
    if({solver})
        readcell {filename} {path} -hsolve
        setfield {path} chanmode 1
    else
        readcell {filename} {path}
    end
    if({exists {path}/iseg})
        pushe {path}/iseg
            make_spiker
        pope
    end
    foreach chan ({el {path}/#/NMDA})
        comp = {getpath {chan} -head}
        deletemsg {chan} 1 -outgoing
    end
    foreach chan ({el {path}/#/CaNMDA})
        comp = {getpath {chan} -head}
        deletemsg {chan} 0 -outgoing
    end
end
