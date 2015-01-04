//genesis
//
// cell.p - template neuron prototype
//
// Reduction of the original model by Huss M, Lansner A, Wallen P,
// El Manira A, Grillner S, Kotaleski JH.  Roles of ionic currents
// in lamprey CPG neurons: a modeling study. J Neurophysiol. 2007
// Apr;97(4):2696-711. Epub 2007 Feb 7 (ModelDB accession number 93319).
//
// The cell morphology is simplified in that the small adjacent membrane
// compartments are lumped together to make longer cylinders. Cell membrane
// of the simplified model contains 16 compartments: soma, axon initial
// segment, 2 primary, 4 secondary and 8 tertiary dendrites.

*relative
*cartesian
*asymmetric

*set_compt_param EREST_ACT -0.078
*set_compt_param ELEAK -0.078
   
*set_global RA 1 
*set_global RM 1
*set_global CM 0.01 

*start_cell /library/soma
 soma none 0 0 20 20 Na 320 Ks 40 Kt 50 CaN 80 CaN_pool -1.25e5 KCaN 60 CaL 4 Na_pool -5e11 Na_slow_pool -3e9 KNa 50 KNa_slow 5.2 Glyc -1e-9 AMPA -0.25e-9 NMDA -0.12e-9
*makeproto /library/soma

*start_cell /library/iseg
 iseg none 0 0 50 5 shNa 20000 Kt 6000 
*makeproto /library/iseg

*start_cell /library/prim_dend
 prim_dend none 90 0 0 5 Na 320 Ks 40 Kt 20 CaN 80 CaN_pool -1.25e5 KCaN 600 CaL 2 CaLVA 575 Na_pool -5e11 Na_slow_pool -3e9 KNa 150 KNa_slow 52 Glyc -1e-9 AMPA -0.25e-9 NMDA -0.12e-9
*makeproto /library/prim_dend

*start_cell /library/secn_dend
 secn_dend none 150 0 0 3 Na 320 Ks 40 Kt 20 CaN 80 CaN_pool -1.25e5 KCaN 600 CaL 2 CaLVA 575 Na_pool -5e11 Na_slow_pool -3e9 KNa 150 KNa_slow 52 AMPA -0.25e-9 NMDA -0.12e-9
*makeproto /library/secn_dend

*start_cell /library/tert_dend
 tert_dend none 240 0 0 2 Na 320 Ks 40 Kt 20 CaN 80 CaN_pool -1.25e5 KCaN 600 CaL 2 CaLVA 575 Na_pool -5e11 Na_slow_pool -3e9 KNa 150 KNa_slow 52 AMPA -0.25e-9 NMDA -0.12e-9
*makeproto /library/tert_dend

*start_cell
*compt /library/soma
 soma none 0 0 20 20

*compt /library/iseg
 iseg soma 0 0 50 5

*compt /library/prim_dend
 prox1 soma 90 0 0 5
 prox2 soma 90 0 0 5

*compt /library/secn_dend
 medi1 prox1 150 0 0 3
 medi2 prox1 150 0 0 3
 medi3 prox2 150 0 0 3
 medi4 prox2 150 0 0 3

*compt /library/tert_dend
 dist1 medi1 240 0 0 2
 dist2 medi1 240 0 0 2
 dist3 medi2 240 0 0 2
 dist4 medi2 240 0 0 2
 dist5 medi3 240 0 0 2
 dist6 medi3 240 0 0 2
 dist7 medi4 240 0 0 2
 dist8 medi4 240 0 0 2
