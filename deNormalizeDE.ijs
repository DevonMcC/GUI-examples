NB.* denormalizeDE.ijs: denormalize Data Export output from
NB. 3-column date/SEDOL/value table to # dates by # SEDOLs matrix of values.

denormalize=: 3 : 0
   'inpfl outfl'=. y
   'r2ktit r2k'=. split <;._1&>TAB,&.><;._2 ] LF (] , [ #~ [ ~: [: {: ]) CR-.~fread inpfl
   udts=. ~.dts=. r2k{"1~r2ktit i. <'Date'
   used=. ~.seds=. r2k{"1~r2ktit i. <'$sedol'
   vals=. _1{"1 r2k
   vals=. (vals e. a:)}vals,:(<,'_')    NB. Replace missing w/"_"
   ixs=. (udts i. dts),&.>used i. seds
   used=. '''',&.>used                  NB. Prefix SEDOLs w/quote for Excel
   mat=. vals ixs}(<,'_')$~($udts),$used
   mat=. ((<'Dates/SEDOLs'),used),udts,.mat
   (;LF,~&.>}.&.>;&.> <"1 TAB,&.>mat) fwrite outfl
NB.EG denormalize 'R2kSectors.txt';'R2kSectorsDatesBySEDOLs.txt'
)

coclass 'Input'

ioForm=: 0 : 0
   bin h;
       bin v; minwh 60 20;
           cc inlbl static left;cn "Input file ";
           cc oulbl static left;cn "Output file";
           cc doneBtn button default; cn "Done";
       bin z;
       bin v; minwh 420 20;
           cc inpfl edit;
           cc outpfl edit;
           cc msgBox static center;set msgBox text;
       bin z;
   bin z;
   
)

iofiles_doneBtn_button=: 3 : 0
   inpfl_Input_=. inpfl_Input_-.LF
   if. '/'={:outpfl_Input_ do.
       wd 'set msgBox text Please set output file'
       wd 'set outpfl focus'
   else.
       if. fexist outpfl_Input_ do.
           wd 'set msgBox text Overwriting ',outpfl_Input_
       end.
       rc=. 1
       wd 'set msgBox text Starting at ',(":(6!:0)''),'...'
       wd 'set doneBtn focus'
       try. denormalize_base_ inpfl_Input_;outpfl_Input_
       catch. rc=. 0 [ wd 'set msgBox text Error' end.
       (6!:3) 2 [ wd 'set msgBox text Done at ',(":(6!:0)''),'...'
       if. rc do. wd 'set msgBox text Tabular output in "',outpfl_Input_,'"' end.
       smoutput (6!:0)''
       ioFiles_close ''
   end.
   ''
)

TimeCTR=: 0
sys_timer_z_=: 3 : 0
   TimeCTR_Input_=: >:TimeCTR_Input_
   if. TimeCTR_Input_<10 do. (6!:3) 1 [ smoutput qts''
   else. wd 'timer 0' end.
   ''
)
NB. load 'c:\amisc\Clarifi\SocGen\deNormalizeDE.ijs'

ioFiles=: 3 : 0
   wd 'pc iofiles;pn "Input/Output Files"'
   wd ioForm
   flnm=. setInputFile ''
   wd 'pshow'
   wd 'set inpfl text ',flnm
   wd 'set outpfl text ',(] {.~ [:>:'/' i:~ ]) flnm  NB. Same dir
   wd 'set outpfl focus'
)

ioFiles_close=: 3 : 0
   wd 'pclose'
)

setInputFile=: 3 : 0
   p=. 'Text (*.txt)|All Files (*.*)'
   if. -. (0:"_ <: [: 4!:0 <^:(L. = 0:)) 'BASEDSK' do. BASEDSK=. 'C:' end.
   wd 'mb open "Input File" "',BASEDSK,':/" "',p,'"'
)

ioFiles ''

coclass 'base'
