//genesis
//
// config.g - definition of the simulation constants

int NDIVS = 3000
float VMIN = -0.100
float VMAX = 0.050
float CMAX = 1e-4
float NMAX = 1.0
float DIVV = (VMAX - VMIN) / NDIVS
float DIVC = CMAX / NDIVS
float DIVN = NMAX / NDIVS
float FMAX = 300
float SIMDT = 50e-6
float IODT = 1e-4

int NO_SFA = 1
int RS_MOD = 1

int solver
int parallel
int nodes
int randinit
float lookahead
int control_node
int worker_node

float simtime = 1.0
float inject = 0.5e-9
str cellproto = "cell.p"
int nsegs = 100

float cordlength = 0.100
float cordwidth = 0.002
float corddepth = 0.00025
int cordsegs = 100
float lunit = cordlength / cordsegs
float preplength = nsegs * lunit

int nye = 30
int necells = nye * nsegs
int nyi = 20
int nicells = nyi * nsegs
int nym = 20
int nmcells = nym * nsegs
float xcord = 0.0
int nocells = (nsegs - 1) / 10 + 1

int nxrs = 2, nyrs = 200
int nrscells = nxrs * nyrs
float rslength = nxrs * lunit
float rswidth = cordwidth / 2
float rsdepth = corddepth
float xrs = xcord - rslength

int nxmlr = 1, nymlr = 1000
int nmlrcells = nxmlr * nymlr
float mlrlength = nxmlr * lunit
float mlrwidth = cordwidth
float mlrdepth = corddepth
float xmlr = xrs - mlrlength

int nxtec = 1, nytec = 1000
int nteccells = nxtec * nytec
float teclength = nxtec * lunit
float tecwidth = cordwidth
float tecdepth = corddepth
float xtec = xmlr - teclength

float evelocity = 0.7
float ivelocity = 1.0
float erost = 4 * lunit
float ecaud = 8 * lunit
float irost = 5 * lunit
float icaud = 15 * lunit
float mrost = 10 * lunit
float mcaud = 10 * lunit

float synptm, synwtm
float synptr, synwtr
float synpmr, synwmr
float synpre, synwre
float synpri, synwri
float synprm, synwrm
float synpee, synwee
float synpei, synwei
float synper, synwer
float synpem, synwem
float synpie, synwie
float synpii, synwii
float synpir, synwir
float synpim, synwim
float synpmo, synwmo

synptm = 0.1; synwtm = 0.2
synptr = 0.1; synwtr = 0.6
synpmr = 0.1; synwmr = 0.1
synpre = 0.1; synwre = 0.09
synpri = 0.1; synwri = 0.09
synprm = 0.1; synwrm = 0.09
synpee = 0.01; synwee = 0.6
synpei = 0.01; synwei = 1.0
synpem = 0.01; synwem = 0.5
synper = 1.00; synwer = 0.5
synpie = 0.01; synwie = 1.0
synpii = 0.01; synwii = 1.0
synpim = 0.01; synwim = 0.5
synpir = 1.0; synwir = 2.0
synpmo = 1.0; synwmo = 0.5
