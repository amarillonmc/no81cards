--Real Scl Version - Variable
local Version_Number = 20210618
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
rsnv = "Nil_Variable"

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

rsop.chk = 1 --"rsop Check"
rsop.chk_e = nil
rsop.chk_p = 0

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


--Effect type Variable
rsef.type_list = {

	   ["s"] = { TYPE_SPELL }, ["t"] = { TYPE_TRAP }, ["m"] = { TYPE_MONSTER }
	  ,["a"] = { nil, EFFECT_TYPE_ACTIVATE }
	  ,["ta"] = { TYPE_TRAP, EFFECT_TYPE_ACTIVATE }, ["sa"] = { TYPE_SPELL, EFFECT_TYPE_ACTIVATE }

}

--Property Variable
rsflag.list =   { 
	
		["tg"] = EFFECT_FLAG_CARD_TARGET, ["ptg"] = EFFECT_FLAG_PLAYER_TARGET, ["de"] = EFFECT_FLAG_DELAY, ["dsp"] = EFFECT_FLAG_DAMAGE_STEP 
	  , ["dcal"] = EFFECT_FLAG_DAMAGE_CAL, ["ii"] = EFFECT_FLAG_IGNORE_IMMUNE, ["sa"] = EFFECT_FLAG_SET_AVAILABLE, ["ir"] = EFFECT_FLAG_IGNORE_RANGE 
	  , ["sr"] = EFFECT_FLAG_SINGLE_RANGE, ["bs"] = EFFECT_FLAG_BOTH_SIDE, ["uc"] = EFFECT_FLAG_UNCOPYABLE 
	  , ["ch"] = EFFECT_FLAG_CLIENT_HINT, ["lz"] = EFFECT_FLAG_LIMIT_ZONE, ["atg"] = EFFECT_FLAG_ABSOLUTE_TARGET 
	  , ["sp"] = EFFECT_FLAG_SPSUM_PARAM, ["ep"] = EFFECT_FLAG_EVENT_PLAYER, ["oa"] = EFFECT_FLAG_OATH , ["ntr"] = EFFECT_FLAG_NO_TURN_RESET 
	  , ["neg~"] = EFFECT_FLAG_CANNOT_INACTIVATE 
	  , ["cn"] = EFFECT_FLAG_CANNOT_NEGATE, ["dise~"] = EFFECT_FLAG_CANNOT_NEGATE 
	  , ["cd"] = EFFECT_FLAG_CANNOT_DISABLE , ["dis~"] = EFFECT_FLAG_CANNOT_DISABLE,

}   

--Category Variable
-- [str] = { description, category, select_hint, effect_hint, would_hint, operation(fun, total_parama_len, parama1, ...) }
--operation for rsop.operationcard(selected_group, reason, e, tp, eg, ep, ev, re, r, rp)
rsof.reason_fun = { }
function rsof.ExR(exr)
	local f = function(r)
		return r | exr
	end
	rsof.reason_fun[f] = true 
	return f
end
function rsof.Get_Cate_Hint_Op_List()  
	local sg = "solve_parama"
	local tp = "activate_player"
	local r = "reason"
	local e = "activate_effect"
	rscate.cate_selhint_list =   {

		["des"] = { "Destroy", CATEGORY_DESTROY, HINTMSG_DESTROY, { 1571945,0 }, { 20590515,2 }, { rsop.Destroy, 3, sg, r } }
	  , ["rdes"] = { "Destroy Replace", CATEGORY_DESTROY, HINTMSG_DESTROY, { 1571945,0 }, { 20590515,2 }, { rsop.Destroy, 3, sg, rsof.ExR(REASON_REPLACE) } }

	  , ["res"] = { "Release", CATEGORY_RELEASE, HINTMSG_RELEASE, { 33779875,0 }, nil, { rsop.Release, 2, sg, r } }

	  , ["rm"] = { "Remove Face-Up", CATEGORY_REMOVE, HINTMSG_REMOVE, { 612115,0 }, { 93191801,2 }, { rsop.Remove, 3, sg, POS_FACEUP, r } }
	  , ["rmd"] = { "Remove Face-Down", CATEGORY_REMOVE, HINTMSG_REMOVE, { 612115,0 }, { 93191801,2 }, { rsop.Remove, 3, sg, POS_FACEDOWN, r } }

	  , ["se"] = { "Search", CATEGORY_SEARCH, 0, { 135598,0 } }
	  , ["th"] = { "Add to Hand", CATEGORY_TOHAND, HINTMSG_ATOHAND, { 1249315,0 }, { 26118970,1 }, { rsop.SendtoHand, 4, sg, nil, r } }
	  , ["rth"] = { "Return to Hand", CATEGORY_TOHAND, HINTMSG_RTOHAND, { 13890468,0 }, { 9464441,2 }, { rsop.SendtoHand, 4, sg, nil, r } }

	  , ["td"] = { "Send to Deck", CATEGORY_TODECK, HINTMSG_TODECK, { 4779823,1 }, { m,6 }, { rsop.SendtoDeck, 4, sg, nil, 2, r} }
	  , ["tdt"] = { "Send to Deck-Top", CATEGORY_TODECK, HINTMSG_TODECK, { 55705473,1 }, { m,6 }, { rsop.SendtoDeck, 4, sg, nil, 2, r} }
	  , ["tdb"] = { "Send to Deck-Bottom", CATEGORY_TODECK, HINTMSG_TODECK, { 55705473,2 }, { m,6 }, { rsop.SendtoDeck, 4, sg, nil, 0, r} }

	  , ["ptdt"] = { "Place to Deck-Top", 0, { 45593826,3 }, { 15521027,3 } }
	  , ["ptdb"] = { "Place to Deck-Bottom",0, 0, { 15521027,4 } }

	  , ["te"] = { "Send to Extra", CATEGORY_TOEXTRA, HINTMSG_TODECK, { 4779823,1 }, { m,6 }, { rsop.SendtoExtra, 4, sg, nil, 2, r} }
	  , ["tde"] = { "Send to Main or Extra", CATEGORY_TODECK, HINTMSG_TODECK, { 4779823,1 }, { m,6 }, { rsop.SendtoMAndE, 4, sg, nil, 2, r} }
	  , ["pte"] = { "Pendulum to Extra", CATEGORY_TOEXTRA, { 24094258,3 }, { 18210764,0 }, nil, { rsop.SendtoExtraP, 3, sg, nil, r} }

	  , ["tg"] = { "Send to Grave", CATEGORY_TOGRAVE, HINTMSG_TOGRAVE, { 1050186,0 }, { 62834295,2 }, { rsop.SendtoGrave, 2, sg, r} }
	  , ["rtg"] = { "Return to Grave", CATEGORY_TOGRAVE, { 48976825,0 }, { 28039390,1 }, 0, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_RETURN)} }
	  , ["dtg"] = { "Discard to Grave", CATEGORY_HANDES + CATEGORY_TOGRAVE, HINTMSG_DISCARD, { 18407024,0 }, { 43332022,1 }, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_DISCARD)} }

	  , ["dish"] = { "Discard Hand", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024,0 }, { 43332022,1 }, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_DISCARD)} }
	  , ["dh"] = { "Discard Hand", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024,0 }, { 43332022,1 }, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_DISCARD)} }
	  , ["dishf"] = { "Discard Hand Function", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024,0 }, { 43332022,1 }, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_DISCARD)} }
	  , ["dhf"] = { "Discard Hand Function", CATEGORY_HANDES, HINTMSG_DISCARD, { 18407024,0 }, { 43332022,1 }, { rsop.SendtoGrave, 2, sg, rsof.ExR(REASON_DISCARD)} }

	  , ["disd"] = { "Discard Deck", CATEGORY_DECKDES, 0, { 13995824,0 }, nil, { rsop.DiscardDeck_Special, 2, sg, r } } 
	  , ["dd"] = { "Discard Deck", CATEGORY_DECKDES, 0, { 13995824,0 }, nil, { rsop.DiscardDeck_Special, 2, sg, r } } 

	  , ["dr"] = { "Draw", CATEGORY_DRAW, 0, { 4732017,0 }, { 3679218,1 } }

	  , ["dam"] = { "Damage", CATEGORY_DAMAGE, 0, { 3775068,0 }, { 12541409,1 } }
	  , ["rec"] = { "Recovery", CATEGORY_RECOVER, 0, { 16259549,0 }, { 54527349,0 } }

	  , ["sum"] = { "Normal Summon", CATEGORY_SUMMON, HINTMSG_SUMMON, { 65247798,0 }, { 41139112,0 } }
	  , ["tk"] = { "Token", CATEGORY_TOKEN, 0, { 9929398,0 }, { 2625939,0 } }
	  , ["sp"] = { "Special Summon", CATEGORY_SPECIAL_SUMMON, HINTMSG_SPSUMMON, { 74892653,2 }, { 17535764,1 }, { rssf.SpecialSummon, 10, sg, 0, tp, tp, false, false, POS_FACEUP  } }

	  , ["cp"] = { "Change Position", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 3648368,0 }, { m,2 }, { rsop.ChangePosition, 7, sg } }
	  , ["pos"] = { "Change Position", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 3648368,0 }, { m,2 }, { rsop.ChangePosition, 7, sg } }
	  , ["upa"] = { "Change to POS_FACEUP_ATTACK", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 359563,0 }, { m,2 }, { rsop.ChangePosition, 7, sg, POS_FACEUP_ATTACK } }
	  , ["upd"] = { "Change to POS_FACEUP_DEFENSE", CATEGORY_POSITION, HINTMSG_POSCHANGE, { 52158283,1 }, { m,2 }, { rsop.ChangePosition, 7, sg, POS_FACEUP_DEFENSE } }
	  , ["dpd"] = { "Change to POS_FACEDOWN_DEFENSE", CATEGORY_POSITION, HINTMSG_SET, { 359563,0 }, { m,2 }, { rsop.ChangePosition, 7, sg, POS_FACEDOWN_DEFENSE } }
	  , ["posd"] = { "Change to POS_DEFENSE", CATEGORY_POSITION, HINTMSG_SET, { 359563,0 }, { m,2 }, { rsop.ChangePosition, 7, sg, POS_DEFENSE } }

	  , ["ctrl"] = { "Get Control", CATEGORY_CONTROL, HINTMSG_CONTROL, { 4941482,0 }, nil, { rsop.GetControl, 5, sg, tp, 0, 0, 0xff  } }
	  , ["sctrl"] = { "Switch Control", CATEGORY_CONTROL, HINTMSG_CONTROL, { 36331074,0 } }

	  , ["dis"] = { "Disable Effect", CATEGORY_DISABLE, HINTMSG_DISABLE, { 39185163,1 }, { 25166510,2 } }
	  , ["diss"] = { "Disable Summon", CATEGORY_DISABLE_SUMMON, 0, { m,1 } }
	  , ["neg"] = { "Negate Activation", CATEGORY_NEGATE, 0, { 19502505,1 } }

	  , ["eq"] = { "Equip", CATEGORY_EQUIP, HINTMSG_EQUIP, { 68184115,0 }, { 35100834,0 } }

	  , ["atk"] = { "Change Attack", CATEGORY_ATKCHANGE, HINTMSG_FACEUP, { 7194917,0 } }
	  , ["def"] = { "Change Defense", CATEGORY_DEFCHANGE, HINTMSG_FACEUP, { 7194917,0 } }

	  , ["ct"] = { "Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 3070049,0 }  }
	  , ["pct"] = { "Place Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 3070049,0 }  }
	  , ["rct"] = { "Remove Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 67234805,0 }  }
	  , ["rmct"] = { "Remove Counter", CATEGORY_COUNTER, HINTMSG_COUNTER, { 67234805,0 }  }

	  , ["coin"] = { "Toss Coin", CATEGORY_COIN, 0, { 17032740,1 } } 
	  , ["dice"] = { "Toss Dice",CATEGORY_DICE, 0, { 42421606,0 } }
	  , ["an"] = { "Announce Card", CATEGORY_ANNOUNCE, 0 }

	  , ["lv"] = { "Change Level", 0, HINTMSG_FACEUP, { 9583383,0 } }

	  , ["fus"] = { "Fusion Summon", CATEGORY_FUSION_SUMMON, 0, { 7241272,1 } }

	  , ["ga"] = { "Grave Action", CATEGORY_GRAVE_ACTION, 0 }
	  , ["gsp"] = { "Grave Special Summon", CATEGORY_GRAVE_SPSUMMON, 0 }
	  , ["lg"] = { "Leave Grave", CATEGORY_LEAVE_GRAVE, 0 }

	  , ["cf"] = { "Confirm (can show public)", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { rsop.ConfirmCards, 1, sg } }
	  , ["rv"] = { "Reveal, (cannot show public)", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { rsop.RevealCards, 2, sg } }
	  , ["rvep"] = { "Reveal until End-Phase", 0, HINTMSG_CONFIRM, {51351302, 0}, nil, { rsop.RevealCards, 2, sg, rsrst.std_ep } }

	  , ["tf"] = { "Move to Field", 0, HINTMSG_TOFIELD, { m,7 }, nil, { rsop.MoveToField, 7, sg, tp } }
	  , ["act"] = { "Activate", 0, HINTMSG_RESOLVEEFFECT, { m,0 }, nil, { rsop.MoveToField_Activate, 7, sg, tp } } 
	  , ["rf"] = { "Return to Field", 0, { 80335817,0 }, nil, nil, { rsop.ReturnToField, 3, sg } }
	  , ["rtf"] = { "Return to Field", 0, { 80335817,0 }, nil, nil, { rsop.ReturnToField, 3, sg } }

	  , ["ae"] = { "Apply 1 Effect from Many", 0, HINTMSG_RESOLVEEFFECT, { 9560338,0 } }

	  , ["set"] = { "SSet", 0, HINTMSG_SET, { 2521011,0 }, { 30741503,1 } }
	  , ["sset"] = { "SSet", 0, HINTMSG_SET, { 2521011,0 }, { 30741503,1 }, { rsop.SSet, 4, sg, tp, tp }}

	  , ["xmat"] = { "Attach Xyz Material", 0, HINTMSG_XMATERIAL, { 55285840,0 } }
	  , ["axmat"] = { "Attach Xyz Material", 0, HINTMSG_XMATERIAL, { 55285840,0 } }
	  , ["rxmat"] = { "Remove Xyz Material", 0, HINTMSG_REMOVEXYZ, { 55285840,1 } }
	  , ["rmxmat"] = { "Remove Xyz Material", 0, HINTMSG_REMOVEXYZ, { 55285840,1 } }

	  , ["ms"] = { "Move Sequence", 0, { m,3 }, { 25163979,1 } }

	  , ["dum"] = { "Dummy Operate", 0, HINTMSG_OPERATECARD, 0, 0, { rsop.DummyOperate, 1, sg } }

	}

	--Switch Hint Format 
	local hint = 0
	for str, val in pairs(rscate.cate_selhint_list) do 
		for idx = 3, 5 do
			if val[idx] then
				hint = rshint.SwitchHintFormat(nil, val[idx]) 
				val[idx] = hint
			end
		end
	end
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
		, ["rm~"] = { EFFECT_CANNOT_REMOVE }, ["ctrl~"] = { EFFECT_CANNOT_CHANGE_CONTROL }
		, ["distm"] = { EFFECT_DISABLE_TRAPMONSTER }

		, ["pos~"] = { EFFECT_CANNOT_CHANGE_POSITION, nil, nil, EFFECT_FLAG_SET_AVAILABLE }
		, ["pose~"] = { EFFECT_CANNOT_CHANGE_POS_E, nil, nil, EFFECT_FLAG_SET_AVAILABLE }
		, ["cp~"] = { EFFECT_CANNOT_CHANGE_POSITION, nil, nil, EFFECT_FLAG_SET_AVAILABLE }
		, ["cpe~"] = { EFFECT_CANNOT_CHANGE_POSITION, nil, nil, EFFECT_FLAG_SET_AVAILABLE }

		, ["act~"] = { EFFECT_CANNOT_ACTIVATE }, ["sum~"] = { EFFECT_CANNOT_SUMMON }, ["sp~"] = { EFFECT_CANNOT_SPECIAL_SUMMON }
		, ["dr~"] = { EFFECT_CANNOT_DRAW }, ["tg~"] = { EFFECT_CANNOT_TO_GRAVE }, ["res~"] = { EFFECT_CANNOT_RELEASE }
		, ["sset~"] = { EFFECT_CANNOT_SSET }, ["mset~"] = { EFFECT_CANNOT_MSET }, ["dh~"] = { EFFECT_CANNOT_DISCARD_HAND }
		, ["dd~"] = { EFFECT_CANNOT_DISCARD_DECK }, ["fp~"] = { EFFECT_CANNOT_FLIP_SUMMON }, ["tgc~"] = { EFFECT_CANNOT_TO_GRAVE_AS_COST }


		, ["sbp"] = { EFFECT_SKIP_BP }, ["sm1"] = { EFFECT_SKIP_M1 }, ["sm2"] = { EFFECT_SKIP_M2 }
		, ["sdp"] = { EFFECT_SKIP_DP }, ["ssp"] = { EFFECT_SKIP_SP }

		, ["rtg"] = { EFFECT_TO_GRAVE_REDIRECT, LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rtd"] = { EFFECT_TO_DECK_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rth"] = { EFFECT_TO_HAND_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }
		, ["rlf"] = { EFFECT_LEAVE_FIELD_REDIRECT,  LOCATION_REMOVED, nil, EFFECT_FLAG_CANNOT_DISABLE, EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_SET_AVAILABLE, RESETS_REDIRECT }

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

		, ["rdam"] = { EFFECT_REFLECT_DAMAGE, 1 }
		, ["rdamb"] = { EFFECT_REFLECT_BATTLE_DAMAGE, 1 }

		, ["dise~"] = { EFFECT_CANNOT_DISEFFECT }
		, ["neg~"] = { EFFECT_CANNOT_INACTIVATE }

		, ["mat"] = { EFFECT_MATERIAL_CHECK, 1, nil, nil, EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE }

		, ["ormat"] = { EFFECT_OVERLAY_RITUAL_MATERIAL, 1  } , ["grmat"] = { EFFECT_EXTRA_RITUAL_MATERIAL, 1  }
		, ["fmat"] = { EFFECT_EXTRA_FUSION_MATERIAL, 1  } 

		}


	local affect_self_list = { "atk", "def", "atkf", "deff", "batk", "bdef"
		, "lv", "rk", "ls", "rs", "code", "att", "race", "type", "fatt"

		, "im", "indb", "inde", "indct", "ind", "tgb~", "tge~"

		, "fcode", "fset", "latt", "lrace", "lcode", "lset" 

		, "ormat", "grmat", "fmat"

		}

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

	rscf.FilterFaceUp =  rscf.fufilter

	--//

	rscf.GetRelationThisCard = rscf.GetFaceUpSelf

	--//

	rsval.imntg1 = rsval.imntges
	rsval.imntg2 = rsval.imntgoe

	--//

	rscost.reglabel = rscost.setlab
	rscost.rmxyz = rscost.rmxmat
	rscost.lpcost = rscost.paylp 
	rscost.lpcost2 = rscost.paylp2 
	rscost.regflag = rscost.chnlim
	rscost.regflag2 = function(flag_code)
		return function(...)
			return rscost.chnlim(flag_code, true)(...)
		end
	end

	--//
	rscon.sumtype = rscon.sumtyps
	rscon.sumtypes = rscon.sumtyps

	rscon.bsdcheck = rssf.CheckBlueEyesSpiritDragon

	--//

	rstg.chainlimit = rstg.chnlim

	--//

	rsop.SelectYesNo = rshint.SelectYesNo 
	rsop.SelectOption = rshint.SelectOption
	rsop.AnnounceNumber = rshint.AnnounceNumber
	rsop.eqop = rsop.Equip
	rsop.SelectOC = rsop.SelectExPara

	rsop.CheckOperateSuccess = rsop.CheckOperateCorrectly

	rsef.SV_UTILITY_XYZ_MATERIAL = rsef.SV_UtilityXyzMaterial
	rsef.SV_ACTIVATE_SPECIAL = rsef.SV_ActivateDirectly_Special
	rsef.SV_CANNOT_DISABLE_S = rsef.SV_CannotDisable_NoEffect
	rsef.SV_EXTRA_MATERIAL =   rsef.SV_ExtraMaterial
	rsef.FV_EXTRA_MATERIAL =   rsef.FV_ExtraMaterial
	rsef.FV_EXTRA_MATERIAL_SELF =   rsef.FV_ExtraMaterial_Self
	rsef.ACT_EQUIP  =   rsef.A_Equip
	rsef.STO_FLIP   =   rsef.STO_Flip
	rsef.STF_FLIP   =   rsef.STF_Flip

	rsef.FC_PHASELEAVE = rsef.FC_PhaseLeave

	rsef.FC_PhaseLeave = function(reg_list, leave_val, times, whos, phase, leaveway, val_reset_list, ex_con)
		return rsef.FC_PhaseOpearte(reg_list, leave_val, times, whos, phase, nil, leaveway, val_reset_list)
	end

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
			table.insert(bufflist,"rlf")
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
			if pl_fun then pl_fun = pl_fun and 1 or 0 end
			return rscon.disneg("neg", dn_filter, pl_fun)(...)
		end
	end
	rscon.discon = function(dn_filter, pl_fun)
		return function(...)
			local dn_list = { [0] = "s,t,m", [1] = "a,m", [2] = "m", [3] = "a", [4] = "s,t" }
			if type(dn_filter) == "number" then
				dn_filter = dn_list[dn_filter]
			end
			if pl_fun then pl_fun = pl_fun and 1 or 0 end
			return rscon.disneg("dis", dn_filter, pl_fun)(...)
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

	--//
	rsop.SelectSolve = function(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_list, ...)
		solve_list = type(solve_list) == "table" and solve_list or { solve_list }
		local para1 = solve_list[1]
		if #solve_list == 0 then return 
			rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
		elseif para1 and type(para1) == "function" then 
			local g = rsop.SelectCards(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, ...)
			local para_list = { }
			local total_list = rsof.Table_Mix(solve_list, { ... })
			for idx, val in pairs(total_list) do 
				if idx > 1 then 
					table.insert(para_list, val)
				end
			end
			return para1(g, table.unpack(para_list))
		else
			return rsop.SelectOperate(sel_hint, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_list, ...)
		end
	end
	rsgf.SelectSolve = function(g, sel_hint, sp, filter, minct, maxct, except_obj, solve_list, ...)
		solve_list = type(solve_list) == "table" and solve_list or { solve_list }
		local para1 = solve_list[1]
		if #solve_list == 0 then return 
			rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
		elseif para1 and type(para1) == "function" then 
			local g = rsgf.SelectCards(sel_hint, g, sp, filter, minct, maxct, except_obj, ...)
			local para_list = { }
			local total_list = rsof.Table_Mix(solve_list, { ... })
			for idx, val in pairs(total_list) do 
				if idx > 1 then 
					table.insert(para_list, val)
				end
			end
			return para1(g, table.unpack(para_list))
		else
			return rsgf.SelectOperate(sel_hint, g, sp, filter, minct, maxct, except_obj, solve_list, ...)
		end
	end
	local selectfun_list = {
		["ToHand"] = "th", ["ToGrave"] = "tg", ["Release"] = "res", ["ToDeck"] = "td", ["Destroy"] = "des", ["Remove"] = "rm", 
		["SpecialSummon"] = "sp", ["MoveToField"] = "tf", ["MoveToField_Activate"] = "act", ["SSet"] = "sset"
	}
	for str_idx, str_val in pairs(selectfun_list) do 
		rsop["Select"..str_idx] = function(sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_parama, ...)
			return rsop.SelectOperate(str_val, sp, filter, tp, loc_self, loc_oppo, minct, maxct, except_obj, solve_parama, ...)
		end
		rsgf["Select"..str_idx] = function(g, sp, filter, minct, maxct, except_obj, solve_parama, ...)
			return rsgf.SelectOperate(str_val, g, sp, filter, minct, maxct, except_obj, solve_parama, ...)
		end
	end
	--//

end


-- Old functions # effects

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
	local compare_list = { ["dise"] = "dise~", ["dis"] = "dis~", ["act"] = "neg~", ["sum"] = "dsum~", ["sp"] = "dsp~", ["fp"] = "dfp", ["neg"] = "neg~" }
	local dis_list2 = rsof.String_Split(dis_list,",")
	local dis_list3 = ""
	for _, str in pairs(dis_list2) do 
		dis_list3 = dis_list3 .. compare_list[str] .. ","
	end
	dis_list3 = string.sub(dis_list3, 1, -2)
	return dis_list3
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
	local str_list2 = rsef.LIMIT_List(lim_list)
	return rsef.FV_Player(reg_list, str_list2, val_list, tg, tg_range_list, flag, nil, con, reset_list, desc_list)
end
--Leave field list
function rsef.REDIRECT_LIST(leave_list)
	local str_list = rsof.String_Number_To_Table(leave_list)
	local str_list2 = { }
	for _, string in pairs(str_list) do
		if string == "leave" then 
			table.insert(str_list2, "rlf")  
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
--cost: tribute self 
function rscost.releaseself(check_mzone, check_exzone)
	return function(e, tp, eg, ep, ev, re, r, rp, chk)
		local c = e:GetHandler()
		if chk == 0 then return c:IsReleasable() and (not check_mzone or Duel.GetMZoneCount(tp, c, tp) > 0) and (not check_exzone or Duel.GetLocationCountFromEx(tp, tp, c, exmzone) > 0) end
		Duel.Release(c, REASON_COST)
	end
end