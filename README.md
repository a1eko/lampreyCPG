lampreyCPG
==========

Model of the locomotor CPG of lamprey. Serial and parallel simulations using GENESIS and PGENESIS v2.3
-------------------------------------------------------------------------------------------------------

This is the model associated with the paper:

Kozlov A, Kardamakis A, Hellgren Kotaleski J, Grillner S (2014) Gating
of steering signals through phasic modulation of reticulospinal neurons
during locomotion. PNAS 111 (9):3591-3596, doi: 10.1073/pnas.1401459111.

The code is available at ModelDB, accession number 151338:
https://senselab.med.yale.edu/modeldb/ShowModel.asp?model=151338

Simulation of locomotor neuronal networks of lamprey [1] using
biologically detailed neuron model [2]. The simulation is based on the
segmental organisation of the spinal networks of lamprey [3] distributed
along the spinal cord to generate waves of left-right alternating activity
travelling from head to tail [4]. Supraspinal neural populations are added
to study propagation of steering commands, from tectum to locomotor CPG.

1. Grillner S (2003) The motor infrastructure: from ion channels to
   neuronal networks. Nat Rev Neurosci 4(7):573-586.

2.  Huss M, Lansner A, Wallen P, El Manira A, Grillner S, Kotaleski JH.
    Roles of ionic currents in lamprey CPG neurons: a modeling study.
    J Neurophysiol. 2007 Apr;97(4):2696-711. Epub 2007 Feb 7. ModelDB
    accession number 93319.

3.  Hellgren J, Grillner S, Lansner A (1992) Computer simulation of the
    segmental neural network generating locomotion in lamprey by using
    populations of network interneurons. Biol Cybern. 68(1):1-13.

4.  Kozlov A, Huss M, Lansner A, Kotaleski JH, Grillner S (2009) Simple
    cellular and network control principles govern complex patterns of motor
    behavior. Proc Natl Acad Sci USA 106(47):20027-20032.


User manual
-----------

<pre><code>
SYNOPSIS
	genesis  [GENESIS_FLAGS]  SCRIPT [OPTIONS]
	pgenesis [PGENESIS_FLAGS] SCRIPT [OPTIONS]

GENESIS_FLAGS
PGENESIS_FLAGS
	See GENESIS and PGENESIS documentation for available values.

OPTIONS
	-t SIMTIME	simulation time, in seconds
	-j INJECT	tectal stimulation, in nA
	-p PROTO	cell prototype file
	-h SIMDT	simulation time step, in seconds
	-randinit	randomize initial conditions
	-hsolve		use Hines solver
	-parallel NODES	number of nodes for parallel execution

FILES
	ouput		Empty directory for output data (must be created
			before running any script).

	Cell.g 		Example script to simulate single neuron. Output data
			is written to _spts.out (timing of the spike
			events, in seconds) and _vmts-0.out (soma membrane
			potential, in Volts).

	Pop.g 		Example script to simulate inhomogeneous population of
			neurons. Ouput data is in _spts.out (spikes)
			and _vmts-N.out (voltages, N is a cell number).

	Syn.g 		Example script to simulate two synapticaly coupled
			neuron populations.  Output data is in _spts.out
			(presynaptic spikes), _spmm.out (postsynaptic
			spikes), _vmts-N.out (presynaptic voltages)
			and _vmmm-M.out (postsynaptic voltages).

	Lamprey.g 	Main script to simulate activity of the locomotor
			CPG with supraspinal control.

EXAMPLES
	genesis Cell.g
	genesis Pop.g
	genesis Syn.g
	pgenesis -nox -nodes 768 -silent 3 Lamprey.g -hsolve -t 2.5 -j 0.55e-9 -parallel 768
</code></pre>


Alexander Kozlov <akozlov@nada.kth.se>  
Jan 2015, Stockholm
