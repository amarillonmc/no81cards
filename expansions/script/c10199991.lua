--Real Scl Version - Variable
local Version_Number = 20201030
local m = 10199990
local vm = 10199991
if rsv then return end
rsv = { }  --"Base Function"
rscf = { }   --"Card Function"
rsgf = { }   --"Group Function"
rsef = { }   --"Effect Function"
rszsf = { }  --"Zone Sequence Function"
rsof = { }   --"Other Function"
rssf = { }   --"Summon Function"
rscode = { }   --"Code Function"
rsval = { }  --"Value Function"
rscon = { }  --"Condition Function"
rscost = { }   --"Cost Function"
rstg = { }   --"Target Function"
rsop = { }   --"Operation Function"
rscate = { }   --"Category Function"
rsflag = { }   --"Property Function"
rsrst = { }   --"Reset Function"
rshint = { }   --"Hint Function"
rsloc = { } --"Location Function"

rsdv = "Divide_Variable"

--Info Variable
rsval.valinfo   = { } --"Value for inside series, inside type etc."
rscost.costinfo = { } --"Cost information, for record cost value" 
rsop.opinfo = { }  --"Operation information, for record something"
rsef.relationinfo = { } --"Field,Pendulum,Continous leave field"
rstg.targetlist = { } --"Target group list, for rstg.GetTargetAttribute"
rsef.attacheffect = { } --"Effect information for attach effects"
rsef.attacheffectf = { }
rsef.solveeffect ={ }
rsop.baseop = { }
rscf.ssproce = { }
rstg.tk_list = { }

rsef.effet_no_register = false 


rscf.synchro_material_action = { } --"Custom syn material's action"
rscf.xyz_material_action = { } --"Custom xyz material's action" 
rscf.link_material_action = { } --"Custom link material's action"  
rssf.synchro_material_group_check = nil -- "For material check syn proc"
--mt.rs_synchro_parameter = { }  --"Record Synchro procedure materials"
--mt.rs_xyz_parameter = { }  --"Record Xyz procedure materials"
--mt.rs_link_parameter = { }  --"Record Link procedure materials"
--mt.rs_synchro_procudure = nil --"Record Synchro procedure"
--mt.rs_xyz_procudure = nil --"Record Xyz procedure"
--mt.rs_link_procudure = nil --"Record Link procedure"

rscf.Previous_Set_Code_List = { } --"For Built-in Previous Set Code"
--mt.rs_synchro_level --"No level synchro monster's level"
--mt.rs_ritual_level --"No level ritual monster's level"

rsef.FC_Global_List = { } --"For rsef.GlobalEffects"

--Reset Variable
rsrst.ep  =   RESET_PHASE + PHASE_END  
rsrst.sp = RESET_PHASE + PHASE_STANDBY 
rsrst.bp = RESET_PHASE + PHASE_BATTLE 

rsrst.std  =   RESET_EVENT + RESETS_STANDARD 
rsrst.std_dis   =   RESET_EVENT + RESETS_STANDARD+RESET_DISABLE 
rsrst.std_ntf = rsrst.std - RESET_TOFIELD 
rsrst.std_ep =   rsrst.std +  rsrst.ep
rsrst.ret =   RESET_EVENT + RESETS_REDIRECT 

--Code Variable 
rscode.Extra_Effect_Activate   =   m + 100   --"Attach Effect"
rscode.Extra_Effect_BSolve   =   m + 101 
rscode.Extra_Effect_ASolve   =   m + 102 

rscode.Phase_Leave_Flag   =   m + 200   --"Summon Flag for SummonBuff"
rscode.Extra_Synchro_Material =  m + 300 --"Extra Synchro Material"
rscode.Extra_Xyz_Material   =   m + 301 --"Extra Xyz Material" 
rscode.Utility_Xyz_Material =   m + 400 --"Utility Xyz Material" 
rscode.Previous_Set_Code	=   m + 500 --"Previous Set Code" 
rscode.Synchro_Material =   m + 600  --"Record synchro proceudre target"
rscode.Pre_Complete_Proc = m + 700 --"Previous c:CompleteProcedure" 
rscode.Special_Procedure = m + 900
rscode.Summon_Count_Limit = m + 201 --"for rsop.SetSpecialSummonCount"

rscode.Set  =   m + 800   --"EVENT_SET"

--Hint Message Variable 

rshint.nohint = false
rshint.nohint_sel = false 

rshint.ce   = aux.Stringid(23912837,1)   --"choose 1 effect"

rshint.spproc = aux.Stringid(m,4) --"SS by self produce"
rshint.rstcp = aux.Stringid(43387895,1) --"reset copy effect"
rshint.epleave = aux.Stringid(m,3)  --"end phase leave field buff"

rshint.stgct = aux.Stringid(83531441,2) --"select send to the GY number"
rshint.sdrct = aux.Stringid(m,5)  --"select draw number"

rshint.darktuner = aux.Stringid(m,14)   --"treat as dark tuner"
rshint.darksynchro = aux.Stringid(m,15) --"treat as dark synchro"


--Property Variable
rsflag.flag_list =   { 
	
		["tg"] = EFFECT_FLAG_CARD_TARGET, ["ptg"] = EFFECT_FLAG_PLAYER_TARGET, ["de"] = EFFECT_FLAG_DELAY, ["dsp"] = EFFECT_FLAG_DAMAGE_STEP 
	  , ["dcal"] = EFFECT_FLAG_DAMAGE_CAL, ["ii"] = EFFECT_FLAG_IGNORE_IMMUNE, ["sa"] = EFFECT_FLAG_SET_AVAILABLE, ["ir"] = EFFECT_FLAG_IGNORE_RANGE 
	  , ["sr"] = EFFECT_FLAG_SINGLE_RANGE, ["bs"] = EFFECT_FLAG_BOTH_SIDE, ["uc"] = EFFECT_FLAG_UNCOPYABLE, ["cd"] = EFFECT_FLAG_CANNOT_DISABLE 
	  , ["cn"] = EFFECT_FLAG_CANNOT_NEGATE, ["ch"] = EFFECT_FLAG_CLIENT_HINT, ["lz"] = EFFECT_FLAG_LIMIT_ZONE, ["at"] = EFFECT_FLAG_ABSOLUTE_TARGET
	  , ["sp"] = EFFECT_FLAG_SPSUM_PARAM, ["ep"] = EFFECT_FLAG_EVENT_PLAYER, ["oa"] = EFFECT_FLAG_OATH 

} 

--Category Variable
-- [str] = { category, select_hint, effect_hint, would_hint, operation }
--operation for rsop.operationcard(selected_group, reason, e, tp, eg, ep, ev, re, r, rp)
function rsof.Get_Cate_Hint_Op_List()   
	rscate.cate_selhint_list =   {

		["des"] = { CATEGORY_DESTROY, HINTMSG_DESTROY, aux.Stringid(1571945,0), aux.Stringid(20590515,2), rsop.OperationDestroy() }
	  , ["rdes"] = { CATEGORY_DESTROY, HINTMSG_DESTROY, aux.Stringid(1571945,0), aux.Stringid(20590515,2), rsop.OperationDestroy(REASON_REPLACE) }

	  , ["res"] = { CATEGORY_RELEASE, HINTMSG_RELEASE, aux.Stringid(33779875,0), nil, rsop.OperationRelease }

	  , ["rm"] = { CATEGORY_REMOVE, HINTMSG_REMOVE, aux.Stringid(612115,0), aux.Stringid(93191801,2), rsop.OperationRemove(POS_FACEUP) }
	  , ["rmd"] = { CATEGORY_REMOVE, HINTMSG_REMOVE, aux.Stringid(612115,0), aux.Stringid(93191801,2), rsop.OperationRemove(POS_FACEDOWN) }

	  , ["se"] = { CATEGORY_SEARCH, 0 }
	  , ["th"] = { CATEGORY_TOHAND, HINTMSG_ATOHAND, aux.Stringid(1249315,0), aux.Stringid(26118970,1), rsop.OperationToHand }
	  , ["rth"] = { CATEGORY_TOHAND, HINTMSG_RTOHAND, aux.Stringid(13890468,0), aux.Stringid(9464441,2), rsop.OperationToHand }

	  , ["td"] = { CATEGORY_TODECK, HINTMSG_TODECK, aux.Stringid(4779823,1), aux.Stringid(m,6), rsop.OperationToDeck(2) }
	  , ["tdt"] = { CATEGORY_TODECK, HINTMSG_TODECK, aux.Stringid(55705473,1), aux.Stringid(m,6), rsop.OperationToDeck(0) }
	  , ["tdb"] = { CATEGORY_TODECK, HINTMSG_TODECK, aux.Stringid(55705473,2), aux.Stringid(m,6), rsop.OperationToDeck(1) }

	  , ["ptdt"] = { 0, aux.Stringid(45593826,3), aux.Stringid(15521027,3) }
	  , ["ptdb"] = { 0, 0, aux.Stringid(15521027,4) }

	  , ["te"] = { CATEGORY_TOEXTRA, HINTMSG_TODECK, aux.Stringid(4779823,1), aux.Stringid(m,6), rsop.OperationToDeck(2) }
	  , ["pte"] = { CATEGORY_TOEXTRA, aux.Stringid(24094258,3), aux.Stringid(18210764,0), nil, rsop.OperationPToDeck }

	  , ["tg"] = { CATEGORY_TOGRAVE, HINTMSG_TOGRAVE, aux.Stringid(1050186,0), aux.Stringid(62834295,2), rsop.OperationToGrave }
	  , ["rtg"] = { CATEGORY_TOGRAVE, aux.Stringid(48976825,0), aux.Stringid(28039390,1), rsop.OperationToGrave }

	  , ["disd"] = { CATEGORY_DECKDES, 0, aux.Stringid(13995824,0), nil, rsop.OperationDiscardDeck } 
	  , ["dd"] = { CATEGORY_DECKDES, 0, aux.Stringid(13995824,0), nil, rsop.OperationDiscardDeck } 

	  , ["dish"] = { CATEGORY_HANDES, HINTMSG_DISCARD, aux.Stringid(18407024,0), aux.Stringid(43332022,1), rsop.OperationDiscardHand }
	  , ["dh"] = { CATEGORY_HANDES, HINTMSG_DISCARD, aux.Stringid(18407024,0), aux.Stringid(43332022,1), rsop.OperationDiscardHand }
	  , ["dishf"] = { CATEGORY_HANDES, HINTMSG_DISCARD, aux.Stringid(18407024,0), aux.Stringid(43332022,1), rsop.OperationDiscardHand }
	  , ["dhf"] = { CATEGORY_HANDES, HINTMSG_DISCARD, aux.Stringid(18407024,0), aux.Stringid(43332022,1), rsop.OperationDiscardHand }

	  , ["dr"] = { CATEGORY_DRAW, 0, aux.Stringid(4732017,0), aux.Stringid(3679218,1) }

	  , ["dam"] = { CATEGORY_DAMAGE, 0, aux.Stringid(3775068,0), aux.Stringid(12541409,1) }
	  , ["rec"] = { CATEGORY_RECOVER, 0, aux.Stringid(16259549,0), aux.Stringid(54527349,0) }

	  , ["sum"] = { CATEGORY_SUMMON, HINTMSG_SUMMON, aux.Stringid(65247798,0), aux.Stringid(41139112,0) }
	  , ["sp"] = { CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, aux.Stringid(74892653,2), aux.Stringid(17535764,1) }
	  , ["tk"] = { CATEGORY_TOKEN, 0, aux.Stringid(9929398,0), aux.Stringid(2625939,0) }

	  , ["pos"] = { CATEGORY_POSITION, HINTMSG_POSCHANGE, aux.Stringid(3648368,0), aux.Stringid(m,2) }
	  , ["upa"] = { CATEGORY_POSITION, HINTMSG_POSCHANGE, aux.Stringid(359563,0), aux.Stringid(m,2), rsop.OperationPos(POS_FACEUP_ATTACK), Card.IsCanChangePosition }
	  , ["upd"] = { CATEGORY_POSITION, HINTMSG_POSCHANGE, aux.Stringid(52158283,1), aux.Stringid(m,2), rsop.OperationPos(POS_FACEUP_DEFENSE), Card.IsCanChangePosition }
	  , ["dpd"] = { CATEGORY_POSITION, HINTMSG_SET, aux.Stringid(359563,0), aux.Stringid(m,2), rsop.OperationPos(POS_FACEDOWN_DEFENSE), Card.IsCanTurnSet }
	  , ["dpd"] = { CATEGORY_POSITION, HINTMSG_SET, aux.Stringid(359563,0), aux.Stringid(m,2), rsop.OperationPos(POS_FACEDOWN_DEFENSE), Card.IsCanTurnSet }


	  , ["ctrl"] = { CATEGORY_CONTROL, HINTMSG_CONTROL, aux.Stringid(4941482,0) }
	  , ["sctrl"] = { CATEGORY_CONTROL, HINTMSG_CONTROL, aux.Stringid(36331074,0) }

	  , ["dis"] = { CATEGORY_DISABLE, HINTMSG_DISABLE, aux.Stringid(39185163,1), aux.Stringid(25166510,2) }
	  , ["diss"] = { CATEGORY_DISABLE_SUMMON, 0, aux.Stringid(m,1) }
	  , ["neg"] = { CATEGORY_NEGATE, 0, aux.Stringid(19502505,1) }

	  , ["eq"] = { CATEGORY_EQUIP, HINTMSG_EQUIP, aux.Stringid(68184115,0), aux.Stringid(35100834,0) }

	  , ["atk"] = { CATEGORY_ATKCHANGE, HINTMSG_FACEUP, aux.Stringid(7194917,0) }
	  , ["def"] = { CATEGORY_DEFCHANGE, HINTMSG_FACEUP, aux.Stringid(7194917,0) }

	  , ["ct"] = { CATEGORY_COUNTER, HINTMSG_COUNTER, aux.Stringid(3070049,0)  }
	  , ["pct"] = { CATEGORY_COUNTER, HINTMSG_COUNTER, aux.Stringid(3070049,0)  }
	  , ["rct"] = { CATEGORY_COUNTER, HINTMSG_COUNTER, aux.Stringid(67234805,0)  }

	  , ["coin"] = { CATEGORY_COIN, 0, aux.Stringid(17032740,1) } 
	  , ["dice"] = { CATEGORY_DICE, 0, aux.Stringid(42421606,0) }
	  , ["an"] = { CATEGORY_ANNOUNCE, 0 }

	  , ["lg"] = { CATEGORY_LEAVE_GRAVE, 0 }

	  , ["lv"] = { 0, HINTMSG_FACEUP, aux.Stringid(9583383,0) }

	  , ["fus"] = { CATEGORY_FUSION_SUMMON, 0 }
	  , ["ga"] = { CATEGORY_GRAVE_ACTION, 0 }
	  , ["gs"] = { CATEGORY_GRAVE_SPSUMMON, 0 }
	 
	  , ["cf"] = { 0, HINTMSG_CONFIRM, nil, nil, rsop.OperationConfirm }

	  , ["tf"] = { 0, HINTMSG_TOFIELD, aux.Stringid(m,7) }
	  , ["rf"] = { 0, aux.Stringid(80335817,0) }

	  , ["act"] = { 0, HINTMSG_RESOLVEEFFECT, aux.Stringid(m,0) } 

	  , ["set"] = { 0, HINTMSG_SET, aux.Stringid(2521011,0), aux.Stringid(30741503,1) }
	  , ["sset"] = { 0, HINTMSG_SET, aux.Stringid(2521011,0), aux.Stringid(30741503,1), rsop.OperationSSet}

	  , ["xyz"] = { 0, HINTMSG_XMATERIAL, aux.Stringid(55285840,0) }
	  , ["rmxyz"] = { 0, HINTMSG_REMOVEXYZ, aux.Stringid(55285840,1) }

	  , ["dum"] = { 0, HINTMSG_OPERATECARD }
	}
 
end


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


rscf.sum_list = {

		["sp"] = { SUMMON_TYPE_SPECIAL }, ["adv"] = { SUMMON_TYPE_ADVANCE }, ["rit"] = { SUMMON_TYPE_RITUAL, TYPE_RITUAL }
	  , ["fus"] = { SUMMON_TYPE_FUSION, TYPE_FUSION }, ["syn"] = { SUMMON_TYPE_SYNCHRO, TYPE_SYNCHRO }, ["xyz"] = { SUMMON_TYPE_XYZ, TYPE_XYZ }
	  , ["link"] = { SUMMON_TYPE_LINK, TYPE_LINK }, ["pen"] = { SUMMON_TYPE_PENDULUM }, ["sps"] = { SUMMON_TYPE_SPECIAL + SUMMON_VALUE_SELF }
	  , ["dual"] = { SUMMON_TYPE_DUAL }, ["flip"] = { SUMMON_TYPE_FLIP }, ["sum"] = { SUMMON_TYPE_NORMAL }

}



--Location Variable
rsloc.hd = LOCATION_HAND+LOCATION_DECK 
rsloc.ho = LOCATION_HAND+LOCATION_ONFIELD
rsloc.hg = LOCATION_HAND+LOCATION_GRAVE  
rsloc.dg = LOCATION_DECK+LOCATION_GRAVE 
rsloc.gr = LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.dgr = LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
rsloc.hdg = LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE 
rsloc.de = LOCATION_DECK+LOCATION_EXTRA 
rsloc.mg = LOCATION_MZONE+LOCATION_GRAVE 
rsloc.og = LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.hmg = LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE 
rsloc.hog = LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE 
rsloc.all = 0xff 


function rsef.Get_Value_Effect_Attribute_List()
	--[string] = { eff_code, eff_val, eff_ctlimit, extra_flag_for_singel, extra_flag_for_field, extra_reset }
	local code_list = {
		  ["atk"] = { EFFECT_SET_ATTACK }, ["def"] = { EFFECT_SET_DEFENSE }
		, ["batk"] = { EFFECT_SET_BASE_ATTACK }, ["bdef"] = { EFFECT_SET_BASE_DEFENSE }
		, ["fatk"] = { EFFECT_SET_ATTACK_FINAL }, ["fdef"] = { EFFECT_SET_DEFENSE_FINAL }
		, ["atkf"] = { EFFECT_SET_ATTACK_FINAL }, ["deff"] = { EFFECT_SET_DEFENSE_FINAL }

		, ["lv"] = { EFFECT_CHANGE_LEVEL }, ["rk"] = { EFFECT_CHANGE_RANK }, ["ls"] = { EFFECT_CHANGE_LSCALE }
		, ["rs"] = { EFFECT_CHANGE_RSCALE }, ["code"] = { EFFECT_CHANGE_CODE }, ["att"] = { EFFECT_CHANGE_ATTRIBUTE }
		, ["race"] = { EFFECT_CHANGE_RACE }, ["type"] = { EFFECT_CHANGE_TYPE }, ["fatt"] = { EFFECT_CHANGE_FUSION_ATTRIBUTE }


		, ["datk"] = { EFFECT_SET_BATTLE_ATTACK }, ["ddef"] = { EFFECT_SET_BATTLE_DEFENSE }


		, ["atk+"] = { EFFECT_UPDATE_ATTACK }, ["def+"] = { EFFECT_UPDATE_DEFENSE }, ["lv+"] = { EFFECT_UPDATE_LEVEL }
		, ["rk+"] = { EFFECT_UPDATE_RANK }, ["ls+"] = { EFFECT_UPDATE_LSCALE }, ["rs+"] = { EFFECT_UPDATE_RSCALE }
		, ["code+"] = { EFFECT_ADD_CODE }, ["att+"] = { EFFECT_ADD_ATTRIBUTE }, ["race+"] = { EFFECT_ADD_RACE }
		, ["set+"] = { EFFECT_ADD_SETCODE }, ["type+"] = { EFFECT_ADD_TYPE }, ["fatt+"] = { EFFECT_ADD_FUSION_ATTRIBUTE }
		, ["fcode+"] = { EFFECT_ADD_FUSION_CODE }, ["fset+"] = { EFFECT_ADD_FUSION_SETCODE }, ["latt+"] = { EFFECT_ADD_LINK_ATTRIBUTE }
		, ["lrace+"] = { EFFECT_ADD_LINK_RACE }, ["lcode+"] = { EFFECT_ADD_LINK_CODE }, ["lset+"] = { EFFECT_ADD_LINK_SETCODE }

		, ["type-"] = { EFFECT_REMOVE_TYPE }, ["race-"] = { EFFECT_REMOVE_RACE }, ["att-"] = { EFFECT_REMOVE_ATTRIBUTE }


		, ["indb"] = { EFFECT_INDESTRUCTABLE_BATTLE }, ["inde"] = { EFFECT_INDESTRUCTABLE_EFFECT }
		, ["indct"] = { EFFECT_INDESTRUCTABLE_COUNT, rsval.indct, nil, 1 }, ["ind"] = { EFFECT_INDESTRUCTABLE }


		, ["im"] = { EFFECT_IMMUNE_EFFECT, rsval.imes }


		, ["fmat~"] = { EFFECT_CANNOT_BE_FUSION_MATERIAL }, ["fsmat~"] = { EFFECT_CANNOT_BE_FUSION_MATERIAL, rsval.fusslimit }
		, ["smat~"] = { EFFECT_CANNOT_BE_SYNCHRO_MATERIAL }, ["ssmat~"] = { EFFECT_CANNOT_BE_SYNCHRO_MATERIAL }
		, ["xmat~"] = { EFFECT_CANNOT_BE_XYZ_MATERIAL }, ["xsmat~"] = { EFFECT_CANNOT_BE_XYZ_MATERIAL }
		, ["lmat~"] = { EFFECT_CANNOT_BE_LINK_MATERIAL }, ["lsmat~"] = { EFFECT_CANNOT_BE_LINK_MATERIAL }


		, ["tgb~"] = { EFFECT_CANNOT_BE_BATTLE_TARGET, aux.imval1, nil, nil, EFFECT_FLAG_IGNORE_IMMUNE }
		, ["tge~"] = { EFFECT_CANNOT_BE_EFFECT_TARGET, 1, nil, nil, EFFECT_FLAG_IGNORE_IMMUNE }


		, ["dis"] = { EFFECT_DISABLE }, ["dise"] = { EFFECT_DISABLE_EFFECT }, ["tri~"] = { EFFECT_CANNOT_TRIGGER }
		, ["atk~"] = { EFFECT_CANNOT_ATTACK }, ["atkan~"] = { EFFECT_CANNOT_ATTACK_ANNOUNCE }, ["atkd~"] = { EFFECT_CANNOT_DIRECT_ATTACK }
		, ["ress~"] = { EFFECT_UNRELEASABLE_SUM }, ["resns~"] = { EFFECT_UNRELEASABLE_NONSUM }, ["td~"] = { EFFECT_CANNOT_TO_DECK }
		, ["th~"] = { EFFECT_CANNOT_TO_HAND }, ["cost~"] = { EFFECT_CANNOT_USE_AS_COST }
		, ["pos~"] = { EFFECT_CANNOT_CHANGE_POSITION, nil, nil, EFFECT_FLAG_SET_AVAILABLE }
		, ["pose~"] = { EFFECT_CANNOT_CHANGE_POS_E, nil, nil, EFFECT_FLAG_SET_AVAILABLE }
		, ["rm~"] = { EFFECT_CANNOT_REMOVE }, ["ctrl~"] = { EFFECT_CANNOT_CHANGE_CONTROL }
		, ["distm"] = { EFFECT_DISABLE_TRAPMONSTER }


		, ["act~"] = { EFFECT_CANNOT_ACTIVATE }, ["sum~"] = { EFFECT_CANNOT_SUMMON }, ["sp~"] = { EFFECT_CANNOT_SPECIAL_SUMMON }
		, ["dr~"] = { EFFECT_CANNOT_DRAW }, ["tg~"] = { EFFECT_CANNOT_TO_GRAVE }, ["res~"] = { EFFECT_CANNOT_RELEASE }
		, ["sset~"] = { EFFECT_CANNOT_SSET }, ["mset~"] = { EFFECT_CANNOT_MSET }, ["dh~"] = { EFFECT_CANNOT_DISCARD_HAND }
		, ["dd~"] = { EFFECT_CANNOT_DISCARD_DECK }, ["fp~"] = { EFFECT_CANNOT_FLIP_SUMMON }, ["tgc~"] = { EFFECT_CANNOT_TO_GRAVE_AS_COST }


		, ["sbp"] = { EFFECT_SKIP_BP }, ["sm1"] = { EFFECT_SKIP_M1 }, ["sm2"] = { EFFECT_SKIP_M2 }
		, ["sdp"] = { EFFECT_SKIP_DP }, ["ssp"] = { EFFECT_SKIP_SP }

		, ["rtg"] = { EFFECT_TO_GRAVE_REDIRECT, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rtd"] = { EFFECT_TO_DECK_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rth"] = { EFFECT_TO_HAND_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rlve"] = { EFFECT_LEAVE_FIELD_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["leave"] = { EFFECT_LEAVE_FIELD_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }


		, ["qah"] = { EFFECT_QP_ACT_IN_NTPHAND }, ["qas"] = { EFFECT_QP_ACT_IN_SET_TURN,1, nil, EFFECT_FLAG_SET_AVAILABLE, EFFECT_FLAG_SET_AVAILABLE }
		, ["tah"] = { EFFECT_TRAP_ACT_IN_HAND }, ["tas"] = { EFFECT_TRAP_ACT_IN_SET_TURN, 1, nil, EFFECT_FLAG_SET_AVAILABLE, EFFECT_FLAG_SET_AVAILABLE }
		

		, ["atkex"] = { EFFECT_EXTRA_ATTACK }, ["atkexm"] = { EFFECT_EXTRA_ATTACK_MONSTER }, ["atka"] = { EFFECT_ATTACK_ALL }
		, ["pce"] = { EFFECT_PIERCE }, ["atkd"] = { EFFECT_DIRECT_ATTACK }
		, ["atkpd"] = { EFFECT_DEFENSE_ATTACK }

		, ["dis~"] = { EFFECT_CANNOT_DISABLE, 1, nil, EFFECT_FLAG_CANNOT_DISABLE }
		, ["dsum~"] = { EFFECT_CANNOT_DISABLE_SUMMON, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE }
		, ["dsp~"] = { EFFECT_CANNOT_DISABLE_SPSUMMON, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE }
		, ["dfp~"] = { EFFECT_CANNOT_DISABLE_FLIP_SUMMON, 1, nil, EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE, EFFECT_FLAG_SET_AVAILABLE }


		, ["dise~"] = { EFFECT_CANNOT_DISEFFECT }
		, ["neg~"] = { EFFECT_CANNOT_INACTIVATE }

		, ["mat"] = { EFFECT_MATERIAL_CHECK, 1, nil, nil, EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE }

		}


	local affect_self_list = { "atk", "def", "atkf", "deff", "batk", "bdef"
		, "lv", "rk", "ls", "rs", "code", "att", "race", "type", "fatt"

		, "im", "indb", "inde", "indct", "ind", "tgb~", "tge~"

		, "fcode", "fset", "latt", "lrace", "lcode", "lset" }

	local affect_self_list2 = { }
	for _, str in pairs(affect_self_list) do
		table.insert(affect_self_list2, str)
		table.insert(affect_self_list2, str.."+")
		table.insert(affect_self_list2, str.."-")
	end

	return code_list, affect_self_list
end

rsef.value_code_list, rsef.value_affect_self_srt_list = rsef.Get_Value_Effect_Attribute_List()

--Escape Old Functions
function rsof.Escape_Old_Functions()
	--//
	rsreset = rsrst 

	rsrst.est  =   rsrst.std
	rsrst.est_d   =   rsrst.std_dis
	rsrst.pend  =   rsrst.ep
	rsrst.est_pend =   rsrst.std_ep
	rsrst.ered  =   rsrst.ret 

	--//
	rsof.DefineCard  =   rscf.DefineCard
	rscf.FilterFaceUp =  rscf.fufilter
	rsof.SendtoHand  =   rsop.SendtoHand
	rsof.SendtoDeck  =   rsop.SendtoDeck
	rsof.SendtoGrave =   rsop.SendtoGrave
	rsof.Destroy	 =   rsop.Destroy
	rsof.Remove   =   rsop.Remove
	rsof.SelectHint  =   rshint.Select
	rsof.SelectOption =   rsop.SelectOption
	rsof.SelectOption_Page = rsop.SelectOption_Page
	rsof.SelectNumber =   rsop.AnnounceNumber
	rsof.SelectNumber_List = rsop.AnnounceNumber_List
	rsof.IsSet   =   rscf.DefineSet
	rscf.GetRelationThisCard = rscf.GetFaceUpSelf
	rsop.eqop = rsop.Equip

	rscon.sumtype = rscon.sumtypes

	rsop.SelectYesNo = rshint.SelectYesNo 
	rsop.SelectOption = rshint.SelectOption
	rsop.SelectOption_Page = rshint.SelectOption_Page
	rsop.AnnounceNumber = rshint.AnnounceNumber
	rsop.AnnounceNumber_List = rshint.AnnounceNumber_List
	rsop.AnnounceNumber_Default = rshint.AnnounceNumber_Default

	rsef.SV_UTILITY_XYZ_MATERIAL = rsef.SV_UtilityXyzMaterial
	rsef.SV_ACTIVATE_SPECIAL = rsef.SV_ActivateDirectly_Special
	rsef.SV_CANNOT_DISABLE_S = rsef.SV_CannotDisable_NoEffect
	rsef.SV_EXTRA_MATERIAL =   rsef.SV_ExtraMaterial
	rsef.FV_EXTRA_MATERIAL =   rsef.FV_ExtraMaterial
	rsef.FV_EXTRA_MATERIAL_SELF =   rsef.FV_ExtraMaterial_Self
	rsef.ACT_EQUIP  =   rsef.A_Equip
	rsef.STO_FLIP   =   rsef.STO_Flip
	rsef.STF_FLIP   =   rsef.STF_Flip
	rsef.QO_NEGATE  =   rsef.QO_Negate
	rsef.FC_PHASELEAVE = rsef.FC_PhaseLeave

	rsef.ACT = rsef.A 
	
	--//
	--some card use old SummonBuff's phase leave field parterment, must fix them in their luas
	rssf.SummonBuff = function(attlist,isdis,isdistig,selfleave,phaseleave)
		local bufflist = { }
		if attlist then 
			for index,par in pairs(attlist) do
				if par then 
					if index ==1 then att ="fatk" end
					if index ==2 then att ="fdef" end
					if index ==3 then att ="lv" end
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
			table.insert(bufflist,"tri~")
			table.insert(bufflist,true)
		end
		if selfleave then 
			table.insert(bufflist,"rlve")
			table.insert(bufflist,selfleave)
		end
		return bufflist
	end
	rsop.list = function(...)
		return {"opc", ...}
	end
	rstg.list = function(...)
		return {"tg", ...}
	end

	rscon.negcon = function(dn_filter, pl_fun)
		return function(...)
			local dn_list = { [0] = "s,t,m", [1] = "a,m", [2] = "m", [3] = "a", [4] = "s,t" }
			if type(dn_filter) == "number" then
				dn_filter = dn_list[dn_filter]
			end
			return rscon.disneg("neg", dn_filter, pl_fun and 1 or 0)(...)
		end
	end
	rscon.discon = function(dn_filter, pl_fun)
		return function(...)
			local dn_list = { [0] = "s,t,m", [1] = "a,m", [2] = "m", [3] = "a", [4] = "s,t" }
			if type(dn_filter) == "number" then
				dn_filter = dn_list[dn_filter]
			end
			return rscon.disneg("dis", dn_filter, pl_fun and 1 or 0)(...)
		end
	end
	rsef.QO_NEGATE = function(reg_list, dn_type, lim_list, dn_str, range, con, cost, desc_list, cate, flag, reset_list)
		return rsef.QO_Negate(reg_list, dn_type, dn_str, lim_list, range, con, cost, cate, flag, nil, nil, desc_list, reset_list)
	end

	rstg.negtg = rstg.neg
	rstg.distg = rstg.dis
	rsop.negop = rsop.neg
	rsop.negop = rsop.dis

	--//
	rscf.SetSpecialSummonProduce = function(reg_list,range,con,op,desc_list,lim_list,reset_list)
		return rscf.AddSpecialSummonProcdure(reg_list,range,con,nil,op,desc_list,lim_list,nil,reset_list)
	end
end



-- Old functions

-- Cannot destroed 
function rsef.INDESTRUCTABLE_List(inds_list)
	local inds_list2 = string.gsub(inds_list, "battle", "indb")
	inds_list2 = string.gsub(inds_list2, "effect", "inde")
	inds_list2 = string.gsub(inds_list2, "ct", "indct")
	inds_list2 = string.gsub(inds_list2, "all", "ind")
	return inds_list2
end
--Single Val Effect: Cannot destroed 
function rsef.SV_INDESTRUCTABLE(reg_list, inds_list, val_list, con, reset_list, flag, desc_list, lim_list)
	local inds_list2 = rsef.INDESTRUCTABLE_List(inds_list)
	return rsef.SV_Card(reg_list, inds_list2, val_list, nil, flag, con, reset_list, desc_list, lim_list)
end
--Field Val Effect: Cannot destroed 
function rsef.FV_INDESTRUCTABLE(reg_list, inds_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
	local inds_list2 = rsef.INDESTRUCTABLE_List(inds_list)
	return rsef.FV_Card(reg_list, inds_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list, lim_list)
end
--Single Val Effect: Immue effects
function rsef.SV_IMMUNE_EFFECT(reg_list, val, con, reset_list, flag, desc_list)
	return rsef.SV_Card(reg_list, "im", val, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Immue effects
function rsef.FV_IMMUNE_EFFECT(reg_list, val, tg, tg_range_list, con, reset_list, flag, desc_list)
	return rsef.FV_Card(reg_list, "im", val, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Directly set ATK & DEF 
function rsef.SV_SET(reg_list, set_list, val_list, con, reset_list, flag, desc_list)
	return rsef.SV_Card(reg_list, set_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.SV_CHANGE(reg_list, change_list, val_list, con, reset_list, flag, desc_list)
	return rsef.SV_Card(reg_list, change_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.FV_CHANGE(reg_list, change_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
	return rsef.FV_Card(reg_list, change_list, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Update attribute 
function rsef.SV_UPDATE(reg_list, up_list, val_list, con, reset_list, flag, desc_list)
	local str_list = rsof.String_Number_To_Table(up_list)
	local str_list2 = { }
	for _, string in pairs(str_list) do
		table.insert(str_list2, string.."+")
	end
	return rsef.SV_Card(reg_list, str_list2, val_list, flag, nil, con, reset_list, desc_list)
end 
--Field Val Effect: Updata some card attributes
function rsef.FV_UPDATE(reg_list, up_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
	local str_list = rsof.String_Number_To_Table(up_list)
	local str_list2 = { }
	for _, string in pairs(str_list) do
		table.insert(str_list2, string.."+")
	end
	return rsef.FV_Card(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Add attribute
function rsef.SV_ADD(reg_list, add_list, val_list, con, reset_list, flag, desc_list)
	return rsef.SV_UPDATE(reg_list, add_list, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Directly set other card attribute, except ATK & DEF
function rsef.FV_ADD(reg_list, add_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
	return rsef.FV_UPDATE(reg_list, add_list, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Single Val Effect: Material lim_
function rsef.SV_CANNOT_BE_MATERIAL(reg_list, mat_list, val_list, con, reset_list, flag, desc_list)
	local flag2 = rsef.GetRegisterProperty(flag)
	flag2 = flag2 | (EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE) 
	local str_list = rsof.String_Number_To_Table(mat_list)
	local str_list2 = { }
	local string2
	for _, string in pairs(str_list) do
		string2 = string.sub(string,1,1)
		table.insert(str_list2, string2.."mat~")
	end
	return rsef.SV_Card(reg_list, str_list2, val_list, flag2, nil, con, reset_list, desc_list)
end
--Single Val Effect: Cannot be battle or card effect target
function rsef.SV_CANNOT_BE_TARGET(reg_list, tg_list, val_list, con, reset_list, flag, desc_list)
	local tg_list2 = string.gsub(tg_list, "battle", "tgb~")
	tg_list2 = string.gsub(tg_list2, "effect", "tge~")
	return rsef.SV_Card(reg_list, tg_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Cannot be battle or card effect target
function rsef.FV_CANNOT_BE_TARGET(reg_list, tg_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list)
	local tg_list2 = string.gsub(tg_list, "battle", "tgb~")
	tg_list2 = string.gsub(tg_list2, "effect", "tge~")
	return rsef.FV_Card(reg_list, tg_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Cannot disable 
function rsef.CANNOT_DISABLE_List(dis_list)
	local dis_list2 = string.gsub(dis_list, "dis", "dis~")
	dis_list2 = string.gsub(dis_list2, "dise", "dise~")
	dis_list2 = string.gsub(dis_list2, "act", "neg~")
	dis_list2 = string.gsub(dis_list2, "sum", "dsum~")
	dis_list2 = string.gsub(dis_list2, "sp", "dsp~")
	dis_list2 = string.gsub(dis_list2, "fp", "dfp~")
	return dis_list2
end
--Single Val Effect: Cannot disable 
function rsef.SV_CANNOT_DISABLE(reg_list, dis_list, val_list, con, reset_list, flag, desc_list, range)
	local dis_list2 = rsef.CANNOT_DISABLE_List(dis_list)
	return rsef.SV_Card(reg_list, dis_list2, val_list, flag, range, con, reset_list, desc_list)
end
function rsef.SV_CANNOT_DISABLE_val(e, ct)
	local te = Duel.GetChainInfo(ct, CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler() == e:GetHandler()
end
--Field Val Effect: Cannot Disable 
function rsef.FV_CANNOT_DISABLE(reg_list, dis_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
	local dis_list2 = rsef.CANNOT_DISABLE_List(dis_list)
	return rsef.FV_Card(reg_list, dis_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Limit List 
function rsef.LIMIT_List(lim_list) 
	local str_list = rsof.String_Number_To_Table(lim_list)
	local str_list2 = { }
	for _, string in pairs(str_list) do
		if string ~= "dis" and string ~= "distm" and string ~= "dise"
			and  string ~= "sbp" and string ~= "sm1" and string ~= "sm2" 
				and string ~= "sdp" and  string ~= "ssp" then
			string = string.."~"
		end
		string = string.gsub(string, "datk~", "atkd~")
		table.insert(str_list2, string)
	end 
	return str_list2
end
--Single Val Effect: Other Limit
function rsef.SV_LIMIT(reg_list, lim_list, val_list, con, reset_list, flag, desc_list)
	local str_list2 = rsef.LIMIT_List(lim_list)
	return rsef.SV_Card(reg_list, str_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Other Limit
function rsef.FV_LIMIT(reg_list, lim_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
	local str_list2 = rsef.LIMIT_List(lim_list)
	return rsef.FV_Card(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Other Limit (affect Player)
function rsef.FV_LIMIT_PLAYER(reg_list, lim_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
	return rsef.FV_Player(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Leave field list
function rsef.REDIRECT_LIST(leave_list)
	local str_list = rsof.String_Number_To_Table(leave_list)
	local str_list2 = { }
	for _, string in pairs(str_list) do
		if string == "leave" then 
			table.insert(str_list2, "rlve")  
		else
			table.insert(str_list2, "r"..string)
		end
	end
	return str_list2
end
--Single Val Effect: Leave field redirect 
function rsef.SV_REDIRECT(reg_list, leave_list, val_list, con, reset_list, flag, desc_list) 
	local str_list2 = rsef.REDIRECT_LIST(leave_list)
	return rsef.SV_Card(reg_list, str_list2, val_list, flag, nil, con, reset_list, desc_list)
end
--Field Val Effect: Leave field redirect 
function rsef.FV_REDIRECT(reg_list, leave_list, val_list, tg, tg_range_list, con, reset_list, flag, desc_list) 
	local str_list2 = rsef.REDIRECT_LIST(leave_list)
	local flag2 = rsef.GetRegisterProperty(flag) | (EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE) 
	if tg_range_list and (tg_range_list[1] == 0xff and tg_range_list[2] == 0xff) then 
		flag2 = flag2 | EFFECT_FLAG_IGNORE_RANGE 
	end
	return rsef.FV_Card(reg_list, str_list2, val_list, tg, tg_range_list, flag2, nil, con, reset_list, desc_list)
end
--Single Val Effect: Activate Trap / Quick Spell immediately
function rsef.SV_ACTIVATE_IMMEDIATELY(reg_list, act_list, con, reset_list, flag, desc_list) 
	local act_list2 
	local reg_owner, reg_handler = rsef.GetRegisterCard(reg_list)
	if reg_handler:IsComplexType(TYPE_QUICKPLAY + TYPE_SPELL) then
		act_list2 = string.gsub(act_list, "hand", "qah")
		act_list2 = string.gsub(act_list2, "set", "qas")
	elseif reg_handler:IsComplexType(TYPE_TRAP) then
		act_list2 = string.gsub(act_list, "hand", "tah")
		act_list2 = string.gsub(act_list2, "set", "tas")
	end
	return rsef.SV_Card(reg_list, act_list2, flag, nil, con, reset_list, desc_list)
end
