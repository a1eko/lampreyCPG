//genesis
//
// chan.g - definitions of the ionic chanels

function make_Na
    if({exists Na})
        return
    end
    str chanpath = "Na"
    float EREV = 0.050, XP = 3, YP = 1
    float singular = 0.1 * DIVV
    float Aam = 0.6e6,  Bam = -0.043 + singular, Cam = 0.001
    float Abm = 0.18e6, Bbm = -0.052 + singular, Cbm = 0.020
    float Aah = 75e3,   Bah = -0.046 + singular, Cah = 0.001
    float Abh = 6e3,    Bbh = -0.042,            Cbh = 0.002
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP} Ypower {YP}
    setupalpha {chanpath} X {Aam * Bam} {-(Aam)} -1 {-(Bam)} {-(Cam)} \
        {-(Abm * Bbm)} {Abm} -1 {-(Bbm)} {Cbm}
    setupalpha {chanpath} Y {-(Aah * Bah)} {Aah} -1 {-(Bah)} {Cah} \
        {Abh} 0 1 {-(Bbh)} {-(Cbh)}
end

function make_shNa
    if({exists shNa})
        return
    end
    str chanpath = "shNa"
    float EREV = 0.050, XP = 3, YP = 1
    float singular = 0.1 * DIVV
    float Aam = 2e6,   Bam = -0.053 + singular, Cam = 0.001
    float Abm = 0.6e6, Bbm = -0.062 + singular, Cbm = 0.020
    float Aah = 50e3,  Bah = -0.054 + singular, Cah = 0.001
    float Abh = 4e3,   Bbh = -0.050,            Cbh = 0.002
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP} Ypower {YP}
    setupalpha {chanpath} X {Aam * Bam} {-(Aam)} -1 {-(Bam)} {-(Cam)} \
        {-(Abm * Bbm)} {Abm} -1 {-(Bbm)} {Cbm}
    setupalpha {chanpath} Y {-(Aah * Bah)} {Aah} -1 {-(Bah)} {Cah} \
        {Abh} 0 1 {-(Bbh)} {-(Cbh)}
end

function make_Kt
    if({exists Kt})
        return
    end
    str chanpath = "Kt"
    float EREV = -0.085, XP = 3, YP = 1
    float singular = 0.1 * DIVV
    float Aam = 1.8e5,  Bam = 0.027 + singular, Cam = 0.014
    float Abm = 0.58e4, Bbm = 0.044 + singular, Cbm = 0.006
    float Aah = 3.33e3, Bah = 0.019 + singular, Cah = 0.006
    float Abh = 99.0,   Bbh = -0.0185,          Cbh = 0.0076
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP} Ypower {YP}
    setupalpha {chanpath} X {Aam * Bam} {-(Aam)} -1 {-(Bam)} {-(Cam)} \
        {-(Abm * Bbm)} {Abm} -1 {-(Bbm)} {Cbm}
    setupalpha {chanpath} Y {-(Aah * Bah)} {Aah} -1 {-(Bah)} {Cah} \
        {Abh} 0 1 {-(Bbh)} {-(Cbh)}
end

function make_Ks
    if({exists Ks})
        return
    end
    str chanpath = "Ks"
    float EREV = -0.085, XP = 1
    float singular = 0.1 * DIVV
    float Aan = 1.44e3, Ban = -0.03 + singular,  Can = 0.002
    float Abn = 1.1e3,  Bbn = 0.0474 + singular, Cbn = 0.002
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP}
    setupalpha {chanpath} X {Aan * Ban} {-(Aan)} -1 {-(Ban)} {-(Can)} \
        {-(Abn * Bbn)} {Abn} -1 {-(Bbn)} {Cbn}
end

function make_CaN
    if({exists CaN})
        return
    end
    str chanpath = "CaN"
    float EREV = 0.050, XP = 2, YP = 1
    float Am = 0.004, Bm = -0.015, Cm = -0.0055
    float Ah = 0.3,   Bh = -0.035, Ch = 0.005
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP} Ypower {YP}
    call {chanpath} TABCREATE X {NDIVS} {VMIN} {VMAX}
    call {chanpath} TABCREATE Y {NDIVS} {VMIN} {VMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float v = VMIN + i * DIVV
        setfield {chanpath} X_A->table[{i}] {Am}
        setfield {chanpath} X_B->table[{i}] {1 / (1 + {exp {(v - (Bm)) / (Cm)}})}
        setfield {chanpath} Y_A->table[{i}] {Ah}
        setfield {chanpath} Y_B->table[{i}] {1 / (1 + {exp {(v - (Bh)) / (Ch)}})}
    end
    tweaktau {chanpath} X
    tweaktau {chanpath} Y
end

function make_CaL
    if({exists CaL})
        return
    end
    str chanpath = "CaL"
    float EREV = 0.050, XP = 1
    float Aq = 0.003, Bq = -0.025, Cq = -0.005
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP}
    call {chanpath} TABCREATE X {NDIVS} {VMIN} {VMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float v = VMIN + i * DIVV
        setfield {chanpath} X_A->table[{i}] {Aq}
        setfield {chanpath} X_B->table[{i}] {1 / (1 + {exp {(v - (Bq)) / (Cq)}})}
    end
    tweaktau {chanpath} X
end

function make_CaLVA
    if({exists CaLVA})
        return
    end
    str chanpath = "CaLVA"
    float EREV = 0.050, XP = 3, YP = 1
    float singular = 0.1 * DIVV
    float Aam = 0.02e6, Bam = -0.058 + singular, Cam = 0.0045
    float Abm = 0.05e6, Bbm = -0.061 + singular, Cbm = 0.0045
    float Aah = 0.1,    Bah = -0.063 + singular, Cah = 0.078
    float Abh = 0.03e3, Bbh = -0.061,            Cbh = 0.0048
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Xpower {XP} Ypower {YP}
    setupalpha {chanpath} X {Aam * Bam} {-(Aam)} -1 {-(Bam)} {-(Cam)} \
        {-(Abm * Bbm)} {Abm} -1 {-(Bbm)} {Cbm}
    setupalpha {chanpath} Y {-(Aah * Bah)} {Aah} -1 {-(Bah)} {Cah} \
        {Abh} 0 1 {-(Bbh)} {-(Cbh)}
end

function make_CaN_pool
    if({exists CaN_pool})
        return
    end
    str poolpath = "CaN_pool"
    create Ca_concen {poolpath}
    setfield {poolpath} B 1.25e5 tau 0.030
    addfield {poolpath} addmsg1 
    setfield {poolpath} addmsg1 "../CaN . I_Ca Ik"
end

function make_Na_pool
    if({exists Na_pool})
        return
    end
    str poolpath = "Na_pool"
    create Ca_concen {poolpath}
    setfield {poolpath} B 5e11 tau 0.15e-3
    addfield {poolpath} addmsg1 
    setfield {poolpath} addmsg1 "../Na . I_Ca Ik"
end

function make_Na_slow_pool
    if({exists Na_slow_pool})
        return
    end
    str poolpath = "Na_slow_pool"
    create Ca_concen {poolpath}
    setfield {poolpath} B 3e9 tau 0.05
    addfield {poolpath} addmsg1 
    setfield {poolpath} addmsg1 "../Na . I_Ca Ik"
end

function make_KCaN
    if({exists KCaN})
        return
    end
    str chanpath = "KCaN"
    float EREV = -0.085, ZP = 1
    float Bz = 5e-7
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Zpower {ZP} instant {INSTANTZ}
    call {chanpath} TABCREATE Z {NDIVS} 0 {CMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float conc = i * DIVC
        setfield {chanpath} Z_A->table[{i}] {conc / (conc + Bz)}
        setfield {chanpath} Z_B->table[{i}] 1
    end
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 "../CaN_pool . CONCEN Ca"
end

function make_KNa
    if({exists KNa})
        return
    end
    str chanpath = "KNa"
    float EREV = -0.085, ZP = 1
    float Az = 6000.0, Bz = 0.1
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Zpower {ZP}
    call {chanpath} TABCREATE Z {NDIVS} 0 {NMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float conc = i * DIVN
        setfield {chanpath} Z_A->table[{i}] {Az * conc / (conc + Bz)}
        setfield {chanpath} Z_B->table[{i}] {Az}
    end
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 "../Na_pool . CONCEN Ca"
end

function make_KNa_slow
    if({exists KNa_slow})
        return
    end
    str chanpath = "KNa_slow"
    float EREV = -0.085, ZP = 1
    float Bz = 0.1
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Zpower {ZP} instant {INSTANTZ}
    call {chanpath} TABCREATE Z {NDIVS} 0 {NMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float conc = i * DIVN
        setfield {chanpath} Z_A->table[{i}] {conc / (conc + Bz)}
        setfield {chanpath} Z_B->table[{i}] 1
    end
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 "../Na_slow_pool . CONCEN Ca"
end

function make_Glyc
    if({exists Glyc})
        return
    end
    str chanpath = "Glyc"
    create synchan {chanpath}
    setfield {chanpath} Ek -0.085 tau1 1.0e-3 tau2 10.0e-3 gmax 1e-9
end

function make_AMPA
    if({exists AMPA})
        return
    end
    str chanpath = "AMPA"
    create synchan {chanpath}
    setfield {chanpath} Ek 0.0 tau1 1.0e-3 tau2 10.0e-3 gmax 1e-9
end

function make_NMDA
    if({exists NMDA})
        return
    end
    str chanpath = "NMDA"
    float Aa = 700
    float Ab = 5.6
    create synchan {chanpath}
    setfield {chanpath} Ek 0.0 tau1 25e-3 tau2 150e-3 gmax 0.5e-9
    create Mg_block {chanpath}/block
    setfield {chanpath}/block CMg 1.8 KMg_A {Aa / Ab} KMg_B {17e-3 / 2}
    addmsg {chanpath} {chanpath}/block CHANNEL Gk Ek
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 ".. ./block VOLTAGE Vm"
    addfield {chanpath} addmsg2
    setfield {chanpath} addmsg2 "./block .. CHANNEL Gk Ek"
end

function make_CaNMDA
    if({exists CaNMDA})
        return
    end
    str chanpath = "CaNMDA"
    float Aa = 700
    float Ab = 5.6
    create synchan {chanpath}
    setfield {chanpath} Ek 0.020 tau1 25e-3 tau2 150e-3 gmax 0.5e-9
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 ".. ../NMDA/block VOLTAGE Vm"
end

function make_CaNMDA_pool
    if({exists CaNMDA_pool})
        return
    end
    str poolpath = "CaNMDA_pool"
    create Ca_concen {poolpath}
    setfield {poolpath} B 1.25e5 tau 2.0
    addfield {poolpath} addmsg1
    setfield {poolpath} addmsg1 "../NMDA/block . I_Ca Ik"
    addfield {poolpath} addmsg2
    setfield {poolpath} addmsg2 "../CaNMDA . I_Ca Ik"
end

function make_KCaNMDA
    if({exists KCaNMDA})
        return
    end
    str chanpath = "KCaNMDA"
    float EREV = -0.085, ZP = 1
    float Bz = 5e-7
    int i
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EREV} Gbar 1 Zpower {ZP} instant {INSTANTZ}
    call {chanpath} TABCREATE Z {NDIVS} 0 {CMAX}
    for(i = 0; i <= NDIVS; i = i + 1)
        float conc = i * DIVC
        setfield {chanpath} Z_A->table[{i}] {conc / (conc + Bz)}
        setfield {chanpath} Z_B->table[{i}] 1
    end
    addfield {chanpath} addmsg1
    setfield {chanpath} addmsg1 "../CaNMDA_pool . CONCEN Ca"
end
