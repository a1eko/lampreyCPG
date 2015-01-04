//genesis
//
// tools.g - collection of simulation tools

function stage
    if(parallel)
        barrier
        if(control_node)
            echo {getdate}: {argv} 
        end
    else
        echo {getdate}: {argv} 
    end
end

int try=0, arg1=1, arg2=2

function getopt
    str opt, optnam, optval="0"
    int i, optpos
    for(i = 1; i <= {argc}; i = i + 1)
        opt = {argv {i}}
        if(opt == "-opt")
            optnam = {argv {i + 1}}
            optpos = {argv {i + 2}}
            i = i + 2
        end
    end
    for(i = 1; i <= {argc}; i = i + 1)
        opt = {argv {i}}
        if(opt == {strcat "-" {optnam}})
            if(optpos != 0)
                optval = {argv {i + optpos}}
                i = i + optpos
            else
                optval = "1"
            end
        end
    end
    return {optval}
end

function get_options
    if({getopt {argv} -opt n {try}})
        nsegs = {getopt {argv} -opt n {arg1}}
        if(nsegs < 1)
            echo error: nsegs cannot be less than 1 ({nsegs} given)
            quit
        end
	preplength = nsegs * lunit
	necells = nye * nsegs
        nicells = nyi * nsegs
	nmcells = nym * nsegs
    end
    if({getopt {argv} -opt t {try}})
        simtime = {getopt {argv} -opt t {arg1}}
	if(simtime < 0)
	    echo error: simtime cannot be less than 0 ({simtime} given)
	    quit
	end
    end
    if({getopt {argv} -opt j {try}})
        inject = {getopt {argv} -opt j {arg1}}
    end
    if({getopt {argv} -opt p {try}})
        cellproto = {getopt {argv} -opt p {arg1}}
    end
    if({getopt {argv} -opt lookahead {try}})
        lookahead = {getopt {argv} -opt lookahead {arg1}}
	if(lookahead < 0)
	    echo error: lookahead must be greater than 0 ({lookahead} given)
	    quit
	end
    end
    if({getopt {argv} -opt h {try}})
        float timestep = {getopt {argv} -opt h {arg1}}
	if(timestep < 0)
	    echo error: timestep cannot be less than 0 ({timestep} given)
	    quit
	end
	SIMDT = timestep
    end
    randinit = {getopt {argv} -opt randinit {try}}
    solver = {getopt {argv} -opt hsolve {try}}
    if({getopt {argv} -opt parallel {try}})
        nodes = {getopt {argv} -opt parallel {arg1}}
	if(nodes < 2)
	    echo error: cannot run on less than 2 nodes ({nodes} given)
	    quit
	end
    end
end

function siminit
    setrand -sprng
    if(nodes > 1)
        paron -nodes {nodes} -parallel
        if(randinit)
            randseed {{mynode} + {randseed}}
	else
            randseed {mynode}
        end
        parallel = 1
	control_node = ({mynode} == 0)
	worker_node = !control_node
	if(worker_node)
	    create neutral /proto/map
	    addfield /proto/map nodelist
	    create neutral /map
	    disable /map
	end
    else
        if(randinit)
            randseed
        end
    end
end

function simschedule
    setclock 0 {SIMDT}
    setclock 1 {IODT}
    if(parallel)
        if(lookahead > 0.0)
            setfield /post sync_before_step 0
            setlookahead {lookahead}
        end
    end
    if(solver)
        if(parallel)
            if(worker_node)
                call /model/#[] SETUP
            end
        else
            call /model/#[] SETUP
        end
        setmethod 11
    end
    reset
end

function simfinish
    if(parallel)
        barrier
        paroff
    end
end

function create_volume(source, dest, ncells, x, y, z, dx, dy, dz)
    float x, y, z, dx, dy, dz
    str source, dest
    float xc, dc
    int ncells
    str cell, name, list
    int nslice, remainder, node, idx, i
    if(ncells > 1)
        dc = dx / (ncells - 1)
    end
    if(parallel)
        if(control_node)
	    xc = x
	    idx = 0
            nslice = ncells / (nodes - 1)
            remainder = ncells - nslice * (nodes - 1)
	    for(node = 1; node <= remainder; node = node + 1)
	        for(i = 1; i <= nslice + 1; i = i + 1)
                    copy@{node} {source} {dest}[{idx}]
                    position@{node} {dest}[{idx}] {xc} {rand {y} {y + dy}} \
		        {rand {z} {z + dz}}
                    idx = idx + 1
                    xc = xc + dc
		end
	        list = list @ "," @ {node}
	    end
	    if(nslice > 0)
	        for(node = remainder + 1; node < nodes; node = node + 1)
	            for(i = 1; i <= nslice; i = i + 1)
                        copy@{node} {source} {dest}[{idx}]
                        position@{node} {dest}[{idx}] {xc} {rand {y} {y + dy}} \
			    {rand {z} {z + dz}}
                        idx = idx + 1
                        xc = xc + dc
		    end
	            list = list @ "," @ {node}
	        end
	    end
	    list = {substring {list} 2}
	    name = {getpath {dest} -tail}
	    copy@other /proto/map /map/{name}
	    setfield@other /map/{name} nodelist {list}
	end
    else
	xc = x
	copy {source} {dest} -repeat {ncells}
        foreach cell ({el {dest}[]})
            position {cell} {xc} {rand {y} {y + dy}} {rand {z} {z + dz}}
            xc = xc + dc
        end
    end
end

function present(path)
    str path, c
    foreach c ({el {path}})
        return 1
    end
    return 0
end

function volume_connect(source, dest, destname, x1, y1, z1, x2, y2, z2, prob)
    str source, dest, destname
    float prob
    if(parallel)
        if(worker_node)
	    str node
	    str destnodes = {getfield /map/{destname} nodelist}
	    if({present {source}})
	        foreach node ({arglist {strsub {destnodes} "," " " -all}})
                    rvolumeconnect {source} {dest}@{node} -relative \
	                -sourcemask box -1 -1 -1 1 1 1 \
		        -destmask box {x1} {y1} {z1} {x2} {y2} {z2} \
		        -probability {prob}
		end
	    end
	    barrier
	else
	    barrier
	end
    else
        volumeconnect {source} {dest} -relative -sourcemask box -1 -1 -1 1 1 1 \
            -destmask box {x1} {y1} {z1} {x2} {y2} {z2} -probability {prob}
    end
end

function volume_delay(source, dest, velocity)
    str source, dest
    float velocity
    if(parallel)
        if(worker_node)
            rvolumedelay {source} {dest} -radial {velocity} -uniform 0.5 
	    barrier
            rvolumedelay {source} {dest} -add -fixed 0.001
	    barrier
	else
	    barrier
	    barrier
	end
    else
        volumedelay {source} {dest} -radial {velocity} -uniform 0.5
        volumedelay {source} {dest} -add -fixed 0.001
    end
end

function volume_weight(source, dest, weight)
    str source, dest
    float weight, w0, rate
    int decay = {getopt {argv} -opt decay {try}}
    if(decay)
        rate = {getopt {argv} -opt decay {arg1}}
        w0 = {getopt {argv} -opt decay {arg2}}
    end
    if(parallel)
        if(worker_node)
	    if(decay)
                rvolumeweight {source} {dest} -decay {rate} {w0} {weight} 
	    else
                rvolumeweight {source} {dest} -fixed {weight} 
	    end
	    barrier
	else
	    barrier
	end
    else
	if(decay)
            volumeweight {source} {dest} -decay {rate} {w0} {weight} 
	else
            volumeweight {source} {dest} -fixed {weight} 
        end
    end
end

function modfield(path, field)
    str path, field
    float value, factor, fac1, fac2
    str c
    if({getopt {argv} -opt fixed {try}})
        factor = {getopt {argv} -opt fixed {arg1}}
        foreach c ({el {path}})
	    if({exists {c} {field}})
	        value = {getfield {c} {field}}
                setfield {c} {field} {value * factor}
	    end
        end
    end
    if({getopt {argv} -opt uniform {try}})
        fac1 = {getopt {argv} -opt uniform {arg1}}
        fac2 = {getopt {argv} -opt uniform {arg2}}
        foreach c ({el {path}})
	    if({exists {c} {field}})
	        value = {getfield {c} {field}}
                factor = {rand {fac1} {fac2}}
                setfield {c} {field} {value * factor}
	    end
        end
    end
    if({getopt {argv} -opt add {try}})
        fac1 = {getopt {argv} -opt add {arg1}}
        fac2 = {getopt {argv} -opt add {arg2}}
        foreach c ({el {path}})
	    if({exists {c} {field}})
	        value = {getfield {c} {field}}
                factor = {rand {fac1} {fac2}}
                setfield {c} {field} {value + factor}
	    end
        end
    end
end

function recspikes(source, dest, tab)
    str source, dest, tab, spike
    create spikehistory {tab}
    if(parallel)
        setfield {tab} filename {dest}-{mynode}.out \
            ident_toggle 1 initialize 1 leave_open 1 flush 1
    else
        setfield {tab} filename {dest}.out \
            ident_toggle 1 initialize 1 leave_open 1 flush 1
    end
    foreach spike ({el {source}})
        addmsg {spike} {tab} SPIKESAVE
    end
end

function create_otable(tabname, length)
    str tabname
    float length
    create table {tabname}
    call {tabname} TABCREATE {length / IODT} 0 {length}
    setfield {tabname} step_mode 3
    useclock {tabname} 1
end

function create_ttable(tabname, length)
    str tabname
    float length
    create table {tabname}
    call {tabname} TABCREATE {length * FMAX} 0 {length}
    setfield {tabname} step_mode 4 stepsize -0.04
    useclock {tabname} 1
end

function write_table(tabname, file)
    str tabname, file
    tab2file {file} {tabname} table -overwrite
end

function recdata(src, field, out, simlength, spikes)
    str src, out, comp, field, spikes
    float simlength
    int i = 0
    foreach comp ({el {src}})
        if({spikes} == "-spikes")
            create_ttable {out}[{i}] {simlength}
	else
            create_otable {out}[{i}] {simlength}
        end
	addmsg {comp} {out}[{i}] INPUT {field}
        i = i + 1
    end
end

function writedata(src, dest)
    str src, dest, tab
    int i = 0
    if(parallel)
        foreach tab ({el {src}[]})
            tab2file {dest}-{i}-{mynode}.out {tab} table -overwrite
            i = i + 1
        end
    else
        foreach tab ({el {src}[]})
            tab2file {dest}-{i}.out {tab} table -overwrite
            i = i + 1
        end
    end
end
