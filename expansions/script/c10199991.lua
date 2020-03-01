--Real Scl Version - Variable
local Version_Number=200119
local m=10199990
local vm=10199991
rsv={}  --"Base Function"
rscf={}   --"Card Function"
rsgf={}   --"Group Function"
rsef={}   --"Effect Function"
rszsf={}	 --"Zone Sequence Function"
rsof={}   --"Other Function"
rssf={}   --"Summon Function"
rscode={}   --"Code Function"
rsval={}	 --"Value Function"
rscon={}	 --"Condition Function"
rscost={}   --"Cost Function"
rstg={}   --"Target Function"
rsop={}   --"Operation Function"
rscate={}   --"Category Function"
rsflag={}   --"Property Function"
rsreset={}   --"Reset Function"
rshint={}   --"Hint Function"

--Info Variable
rsef.valinfo	={} --"Value for inside series, inside type etc."
rscost.costinfo ={} --"Cost information, for record cost value" 
rsef.targetlist ={} --"Target group list, for rstg.GetTargetAttribute"
rsef.attachinfo ={} --"Effect information for attach effects"

rscf.synchro_material_action={} --"Custom syn material's action"
rscf.xyz_material_action={} --"Custom xyz material's action" 
rscf.link_material_action={} --"Custom link material's action"  
rssf.synchro_material_group_check=nil -- "For material check syn proc"
--mt.rs_synchro_parameter={}  --"Record Synchro procedure materials"
--mt.rs_xyz_parameter={}  --"Record Xyz procedure materials"
--mt.rs_link_parameter={}  --"Record Link procedure materials"
--mt.rs_synchro_procudure=nil --"Record Synchro procedure"
--mt.rs_xyz_procudure=nil --"Record Xyz procedure"
--mt.rs_link_procudure=nil --"Record Link procedure"

rscf.Previous_Set_Code_List={} --"For Built-in Previous Set Code"
--mt.rs_synchro_level --"No level synchro monster's level"
--mt.rs_ritual_level --"No level ritual monster's level"


--Reset Variable
rsreset.est  =   RESET_EVENT+RESETS_STANDARD 
rsreset.est_d   =   RESET_EVENT+RESETS_STANDARD+RESET_DISABLE 
rsreset.pend	=   RESET_PHASE+PHASE_END  
rsreset.est_pend=   rsreset.est +  rsreset.pend
rsreset.ered	=   RESET_EVENT+RESETS_REDIRECT 

--Code Variable 
rscode.Extra_Effect   =   m+100   --"Attach Effect"
rscode.Extra_Effect_FORCE=   m+200   --"Attach Effect,Force"
rscode.Summon_Flag   =   m+300   --"Summon Flag for SummonBuff"
rscode.Extra_Synchro_Material=  m+400 --"Extra Synchro Material"
rscode.Extra_Xyz_Material   =   m+401 --"Extra Xyz Material" 
rscode.Utility_Xyz_Material =   m+500 --"Utility Xyz Material" 
rscode.Previous_Set_Code	=   m+600 --"Previous Set Code" 
rscode.Synchro_Material =   m+700  --"Record synchro proceudre target"

--Hint Message Variable
rshint.act=aux.Stringid(m,0) --"activate spell/trap"
rshint.dis=aux.Stringid(m,1) --"cards will be disable effects "
rshint.ad=aux.Stringid(m,2)  --"cards will be change Atk/Def"
rshint.rtg=aux.Stringid(48976825,0) --"return to grave"
rshint.spproc=aux.Stringid(m,4) --"SS by self produce"
rshint.negeffect=aux.Stringid(19502505,1) --"negate activation"
rshint.eq=aux.Stringid(68184115,0)  --"cards will equip"
rshint.te=aux.Stringid(24094258,3) --"add to extra deck"
rshint.xyz=HINTMSG_XMATERIAL   --"cards will be overlay cards"
rshint.diseffect=aux.Stringid(39185163,1) --"negate effect"
rshint.negsum=aux.Stringid(m+1,1) --"negate summon"
rshint.negsp=aux.Stringid(74892653,0) --"negate special summon"
rshint.darktuner=aux.Stringid(m,14) --"treat as dark tuner"
rshint.darksynchro=aux.Stringid(m,15) --"treat as dark synchro"
rshint.choose=aux.Stringid(23912837,1) --"choose 1 effect"

--Property Variable
rsflag.flaglist =   { EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG_PLAYER_TARGET,EFFECT_FLAG_DELAY,EFFECT_FLAG_DAMAGE_STEP,EFFECT_FLAG_DAMAGE_CAL,
EFFECT_FLAG_IGNORE_IMMUNE,EFFECT_FLAG_SET_AVAILABLE,EFFECT_FLAG_IGNORE_RANGE,EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG_BOTH_SIDE, 
EFFECT_FLAG_UNCOPYABLE,EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG_CANNOT_NEGATE,EFFECT_FLAG_CLIENT_HINT,EFFECT_FLAG_LIMIT_ZONE,
EFFECT_FLAG_ABSOLUTE_TARGET,EFFECT_FLAG_SPSUM_PARAM }
rsflag.tg_d  =   EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY 
rsflag.dsp_d	=   EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY 
rsflag.dsp_tg   =   EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET 
rsflag.dsp_dcal =   EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP 
rsflag.ign_set  =   EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE 

--Category Variable
rscate.catelist =   { CATEGORY_DESTROY,CATEGORY_RELEASE,CATEGORY_REMOVE,CATEGORY_TOHAND,CATEGORY_TODECK,
CATEGORY_TOGRAVE,CATEGORY_DECKDES,CATEGORY_HANDES,CATEGORY_SUMMON,CATEGORY_SPECIAL_SUMMON,
CATEGORY_TOKEN,CATEGORY_POSITION,CATEGORY_CONTROL,CATEGORY_DISABLE,CATEGORY_DISABLE_SUMMON,
CATEGORY_DRAW,CATEGORY_SEARCH,CATEGORY_EQUIP,CATEGORY_DAMAGE,CATEGORY_RECOVER,
CATEGORY_ATKCHANGE,CATEGORY_DEFCHANGE,CATEGORY_COUNTER,CATEGORY_COIN,CATEGORY_DICE, 
CATEGORY_LEAVE_GRAVE,CATEGORY_LVCHANGE,CATEGORY_NEGATE,CATEGORY_ANNOUNCE,CATEGORY_FUSION_SUMMON,
CATEGORY_TOEXTRA,CATEGORY_GRAVE_ACTION } 
rscate.se_th	=   CATEGORY_SEARCH+CATEGORY_TOHAND 
rscate.neg_des  =   CATEGORY_NEGATE+CATEGORY_DESTROY 

--Card Type Variable
rscf.typelist   =   { TYPE_MONSTER,TYPE_NORMAL,TYPE_EFFECT,TYPE_DUAL,TYPE_UNION,TYPE_TOON,TYPE_TUNER,TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_TOKEN,TYPE_PENDULUM,TYPE_SPSUMMON,TYPE_FLIP,TYPE_SPIRIT,
TYPE_SPELL,TYPE_EQUIP,TYPE_FIELD,TYPE_CONTINUOUS,TYPE_QUICKPLAY,
TYPE_TRAP,TYPE_COUNTER,TYPE_TRAPMONSTER }
rscf.extype  =   TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK 
rscf.extype_r   =   rscf.extype + TYPE_RITUAL 
rscf.extype_np  =   rscf.extype - TYPE_PENDULUM 
rscf.exlist  =   { TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK }

--Escape Old Functions
rsof.DefineCard  =   rscf.DefineCard
rsof.SendtoHand  =   rsop.SendtoHand
rsof.SendtoDeck  =   rsop.SendtoDeck
rsof.SendtoGrave =   rsop.SendtoGrave
rsof.Destroy	 =   rsop.Destroy
rsof.Remove   =   rsop.Remove
rsof.SelectHint  =   rshint.Select
rsof.SelectOption=   rsop.SelectOption
rsof.SelectOption_Page= rsop.SelectOption_Page
rsof.SelectNumber=   rsop.AnnounceNumber
rsof.SelectNumber_List= rsop.AnnounceNumber_List
rsof.IsSet   =   rscf.DefineSet


