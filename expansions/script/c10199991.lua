--Real Scl Version - Variable
local Version_Number=20200409
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
rsloc={}	--"Location Function"

rsdv="Divide_Variable"

--Info Variable
rsval.valinfo   ={} --"Value for inside series, inside type etc."
rscost.costinfo ={} --"Cost information, for record cost value" 
rsop.opinfo={}  --"Operation information, for record something"
rsef.relationinfo={} --"Field,Pendulum,Continous leave field"
rstg.targetlist ={} --"Target group list, for rstg.GetTargetAttribute"
rsef.attacheffect ={} --"Effect information for attach effects"
rsef.attacheffectf ={}
rsef.solveeffect ={}
rsop.baseop={}

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
rscode.Extra_Effect_Activate   =   m+100   --"Attach Effect"
rscode.Extra_Effect_BSolve   =   m+101 
rscode.Extra_Effect_ASolve   =   m+102 

rscode.Phase_Leave_Flag   =   m+200   --"Summon Flag for SummonBuff"
rscode.Extra_Synchro_Material=  m+300 --"Extra Synchro Material"
rscode.Extra_Xyz_Material   =   m+301 --"Extra Xyz Material" 
rscode.Utility_Xyz_Material =   m+400 --"Utility Xyz Material" 
rscode.Previous_Set_Code	=   m+500 --"Previous Set Code" 
rscode.Synchro_Material =   m+600  --"Record synchro proceudre target"
rscode.Pre_Complete_Proc = m+700 --"Previous c:CompleteProcedure" 

rscode.Set  =   m+800   --"EVENT_SET"

--Hint Message Variable
rshint.act=aux.Stringid(m,0) --"activate spell/trap"
rshint.dis=aux.Stringid(38265153,3) --"cards will be disable effects "
rshint.ad=aux.Stringid(m,2)  --"cards will be change Atk/Def"
rshint.rtg=aux.Stringid(48976825,0) --"return to grave"
rshint.spproc=aux.Stringid(m,4) --"SS by self produce"
rshint.negeffect=aux.Stringid(19502505,1) --"negate activation"
rshint.eq=aux.Stringid(68184115,0)  --"cards will equip"
rshint.te=aux.Stringid(24094258,3) --"add to extra deck"
rshint.xyz=HINTMSG_XMATERIAL   --"cards will become overlay cards"
rshint.diseffect=aux.Stringid(39185163,1) --"negate effect"
rshint.negsum=aux.Stringid(m+1,1) --"negate summon"
rshint.negsp=aux.Stringid(74892653,0) --"negate special summon"
rshint.darktuner=aux.Stringid(m,14) --"treat as dark tuner"
rshint.darksynchro=aux.Stringid(m,15) --"treat as dark synchro"
rshint.choose=aux.Stringid(23912837,1) --"choose 1 effect"
rshint.epleave=aux.Stringid(m,3)	--"end phase leave field"
rshint.finshcopy=aux.Stringid(43387895,1) --"reset copy effect"
rshint.act2=aux.Stringid(m,1)   --"select card to activate"
rshint.tgct=aux.Stringid(83531441,2) --"select send to the GY number"
rshint.drct=aux.Stringid(m,5) --"select draw number"

--[[
rshint.isss=aux.Stringid(17535764,1)	--"would you SS a monster?"
rshint.istg=aux.Stringid(62834295,2)	--"would you send to GY?"
rshint.isdes=aux.Stringid(20590515,2)   --"would you destroy?"
rshint.istd=aux.Stringid(m,1)	--"would you send to Deck?"
rshint.isrm=aux.Stringid(93191801,2)	--"would you reomve?"
rshint.isset=aux.Stringid(m,5)  --"would you set?"
rshint.istf=aux.Stringid(m,6)	--"would you place to field?"
rshint.isth=aux.Stringid(26118970,1)	--"would you send to hand?"
rshint.isrh=aux.Stringid(31102447,2)	--"would you return to hand"
rshint.isdr=aux.Stringid(3679218,1)  --"would you draw?"
--]]

--Property Variable
rsflag.flaglist =   { EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG_PLAYER_TARGET,EFFECT_FLAG_DELAY,EFFECT_FLAG_DAMAGE_STEP,EFFECT_FLAG_DAMAGE_CAL,
EFFECT_FLAG_IGNORE_IMMUNE,EFFECT_FLAG_SET_AVAILABLE,EFFECT_FLAG_IGNORE_RANGE,EFFECT_FLAG_SINGLE_RANGE,EFFECT_FLAG_BOTH_SIDE, 
EFFECT_FLAG_UNCOPYABLE,EFFECT_FLAG_CANNOT_DISABLE,EFFECT_FLAG_CANNOT_NEGATE,EFFECT_FLAG_CLIENT_HINT,EFFECT_FLAG_LIMIT_ZONE,
EFFECT_FLAG_ABSOLUTE_TARGET,EFFECT_FLAG_SPSUM_PARAM,
EFFECT_FLAG_EVENT_PLAYER }
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
rscf.extype  =   TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK 
rscf.extype_r   =   rscf.extype + TYPE_RITUAL 
rscf.extype_p  =   rscf.extype + TYPE_PENDULUM 
rscf.extype_rp  =  rscf.extype + TYPE_RITUAL + TYPE_PENDULUM 
rscf.exlist  =   { TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK }
rscf.exlist_r  =   { TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_RITUAL }
rscf.exlist_p  =   { TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_PENDULUM }
rscf.exlist_rp  =   { TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_PENDULUM,TYPE_RITUAL }

--Location Variable
rsloc.hd=LOCATION_HAND+LOCATION_DECK 
rsloc.ho=LOCATION_HAND+LOCATION_ONFIELD
rsloc.hg=LOCATION_HAND+LOCATION_GRAVE  
rsloc.dg=LOCATION_DECK+LOCATION_GRAVE 
rsloc.gr=LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.dgr=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.hdg=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE 
rsloc.de=LOCATION_DECK+LOCATION_EXTRA 
rsloc.mg=LOCATION_MZONE+LOCATION_GRAVE 
rsloc.og=LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.hmg=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE 
rsloc.hog=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.all=0xff 

--Escape Old Functions
function rsof.Escape_Old_Functions()
	rsof.DefineCard  =   rscf.DefineCard
	rscf.FilterFaceUp =  rscf.fufilter
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
	rscf.GetRelationThisCard = rscf.GetFaceUpSelf
	--some card use old SummonBuff's phase leave field parterment, must fix them in their luas
	rssf.SummonBuff=function(attlist,isdis,isdistig,selfleave,phaseleave)
		local bufflist={}
		if attlist then 
			for index,par in pairs(attlist) do
				if par then 
					if index==1 then att="atkf" end
					if index==2 then att="deff" end
					if index==3 then att="lv" end
					table.insert(bufflist,att)
					table.insert(bufflist,par)
				end
			end
		end
		if isdis then
			table.insert(bufflist,"dis,dise")
			table.insert(bufflist,true)
		end
		if isdistig then
			table.insert(bufflist,"tri")
			table.insert(bufflist,true)
		end
		if selfleave then 
			table.insert(bufflist,"leave")
			table.insert(bufflist,selfleave)
		end
		return bufflist
	end
end


