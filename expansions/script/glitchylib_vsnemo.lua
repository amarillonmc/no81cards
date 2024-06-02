GLITCHYLIB_LOADED					= true
self_reference_effect				= nil
self_reference_tp					= nil

--Modified functions
local duel_recover, duel_damage, aux_damcon1 = Duel.Recover, Duel.Damage, Auxiliary.damcon1

Duel.Recover = function(p,v,r,...)
	if Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER) then
		for _,e in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER)}) do
			local val=e:GetValue()
			if val and (aux.GetValueType(val)=="number" or val(e,r,v)) then
				if aux.GetValueType(val)~="number" then
					val=val(e,r,v)
				end
				return duel_recover(p,val,r,...)
			end
		end
	else
		return duel_recover(p,v,r,...)
	end
end
Duel.Damage = function(p,v,r,...)
	if Duel.IsPlayerAffectedByEffect(p,EFFECT_REVERSE_DAMAGE) and Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER) then
		for _,e in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_CHANGE_RECOVER)}) do
			local val=e:GetValue()
			if val and (aux.GetValueType(val)=="number" or val(e,r|REASON_RDAMAGE,v)) then
				if aux.GetValueType(val)~="number" then
					val=val(e,r|REASON_RDAMAGE,v)
				end
				return duel_damage(p,val,r,...)
			end
		end
	else
		return duel_damage(p,v,r,...)
	end
end
Auxiliary.damcon1 = function(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	local takedamcheck=true
	for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE)}) do
		local value=ce:GetValue()
		if not value or value(ce,cv) then
			takedamcheck=false
			break
		end
	end
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and takedamcheck then
		return true
	end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and takedamcheck
end

--Glitchylib imports
EFFECT_CHANGE_RECOVER					= 1508


--Rating types
RATING_LEVEL	 = 	0x1
RATING_RANK		=	0x2
RATING_LINK		=	0x4

--Stat types
STAT_ATTACK  = 0x1
STAT_DEFENSE = 0x2

--COIN RESULTS
COIN_HEADS = 1
COIN_TAILS = 0

--Effects
GLOBAL_EFFECT_RESET	=	10203040

--Properties
EFFECT_FLAG_DD = EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL
EFFECT_FLAG_DDD = EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL

--zone constants
EXTRA_MONSTER_ZONE=0x60

--resets
RESETS_REDIRECT_FIELD 			= 0x047e0000
RESETS_STANDARD_UNION 			= RESETS_STANDARD&(~(RESET_TOFIELD|RESET_LEAVE))
RESETS_STANDARD_TOFIELD 		= RESETS_STANDARD&(~(RESET_TOFIELD))
RESETS_STANDARD_EXC_GRAVE 		= RESETS_STANDARD&~(RESET_LEAVE|RESET_TOGRAVE)
RESETS_STANDARD_FACEDOWN 		= RESETS_STANDARD&(~(RESET_TURN_SET))
RESETS_STANDARD_ACTIVATION 		= RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TOGRAVE)

--timings
RELEVANT_TIMINGS = TIMINGS_CHECK_MONSTER|TIMING_MAIN_END|TIMING_END_PHASE

--win
WIN_REASON_CUSTOM = 0xff

--constants aliases
TYPE_ST			= TYPE_SPELL|TYPE_TRAP

CATEGORIES_ATKDEF			=	CATEGORY_ATKCHANGE|CATEGORY_DEFCHANGE
CATEGORIES_SEARCH 			= 	CATEGORY_SEARCH|CATEGORY_TOHAND
CATEGORIES_FUSION_SUMMON 	= 	CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON
CATEGORIES_TOKEN 			= 	CATEGORY_SPECIAL_SUMMON|CATEGORY_TOKEN

RACE_PSYCHIC = RACE_PSYCHO
RACES_BEASTS = RACE_BEAST|RACE_BEASTWARRIOR|RACE_WINDBEAST

ARCHE_FUSION		= 0x46

CARD_ANCIENT_PIXIE_DRAGON				= 4179255
CARD_BLACK_AND_WHITE_WAVE				= 31677606
CARD_BLUEEYES_SPIRIT					= 59822133
CARD_DESPAIR_FROM_THE_DARK				= 71200730
CARD_EHERO_BLAZEMAN						= 63060238
CARD_MONSTER_REBORN						= 83764718
CARD_MOON_MIRROR_SHIELD					= 19508728
CARD_NUMBER_39_UTOPIA					= 84013237
CARD_ROTA								= 32807846
CARD_UMI								= 22702055

LOCATION_ALL = LOCATION_DECK|LOCATION_HAND|LOCATION_MZONE|LOCATION_SZONE|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_EXTRA
LOCATION_GB  = LOCATION_GRAVE|LOCATION_REMOVED

MAX_RATING = 14

REASON_EXCAVATE	= REASON_REVEAL

RESET_TURN_SELF = RESET_SELF_TURN
RESET_TURN_OPPO = RESET_OPPO_TURN

--Nemo's archetypes and constants
ARCHE_ANIFRIENDS = 0x442

ARCHE_DESPERADO_TRICKSTER	=	0x3461
ARCHE_DESPERADO_HEART		=	0x5461

ARCHE_KEY			=	0x460
ARCHE_KEY_FRAGMENTS	=	0x3460
ARCHE_KEY_MEMORIA	=	0x5460
ARCHE_KEY_CLIMAX	=	0x6460
ARCHE_KEY_MOMENT	=	0x9460
ARCHE_KEY_LBO		=	0xa460
ARCHE_KEY_ETC		=	0xc460

ARCHE_SANDSTAR = {33700058,33700945,33731003,33731004,33731005}

CARD_ANIFRIENDS_SERVAL					= 33700055
CARD_DESPERADO_HEART					= 33720100
CARD_DESPERADO_TRICKSTER_THE_FORERUNNER	= 33720106
CARD_KEY_FRAGMENTS_RIKI					= 33730131
CARD_KEY_FRAGMENTS_RIN					= 33730133
CARD_KEY_MEMORIA_HANABI 				= 33730159
CARD_KEY_MEMORIA_JUST_ONE_MAGIC_WORD 	= 33730161
CARD_ZEORYMER_OF_THE_SKY				= 112312313--33701376

COUNTER_GEAS							= 0x1461
COUNTER_COMPASSION_OF_DESPERADO_HEART	= 0x462
COUNTER_CONNECTION_OF_DESPERADO_HEART	= 0x463
COUNTER_KARMA_OF_DESPERADO_HEART		= 0x464
COUNTER_LBO_HAPPINESS					= 0x440
COUNTER_LORE							= 0x246
COUNTER_SAN								= 0x465
COUNTER_SPARKLE 						= 0x443

TOKEN_BELKA				=	33730163
TOKEN_DESPERADO_HEART	=	33720101
TOKEN_STRELKA			=	33730162


function Card.IsHardCodedSetCard(c,...)
	local x={...}
	if #x==0 then return false end
	for _,tab in ipairs(x) do
		if type(tab)=="table" then
			if c:IsCode(table.unpack(tab)) then
				return true
			end
		end
	end
	return false
end

--Shortcuts
function Duel.IsExists(target,f,tp,loc1,loc2,min,exc,...)
	if aux.GetValueType(target)~="boolean" then Debug.Message("Duel.IsExists: First argument should be boolean") return false end
	local func = (target==true) and Duel.IsExistingTarget or Duel.IsExistingMatchingCard
	
	return func(f,tp,loc1,loc2,min,exc,...)
end
function Duel.Select(hint,target,tp,f,pov,loc1,loc2,min,max,exc,...)
	if aux.GetValueType(target)~="boolean" then return false end
	local func = (target==true) and Duel.SelectTarget or Duel.SelectMatchingCard
	local hint = hint or HINTMSG_TARGET
	
	Duel.Hint(HINT_SELECTMSG,tp,hint)
	local g=func(tp,f,pov,loc1,loc2,min,max,exc,...)
	return g
end
function Duel.ForcedSelect(hint,target,tp,f,pov,loc1,loc2,min,max,exc,...)
	if aux.GetValueType(target)~="boolean" then return false end
	local func = (target==true) and Duel.SelectTarget or Duel.SelectMatchingCard
	local hint = hint or HINTMSG_TARGET
	
	Duel.Hint(HINT_SELECTMSG,tp,hint)
	local g=func(tp,f,pov,loc1,loc2,min,max,exc,...)
	if not g or #g==0 then
		g=func(tp,f,pov,loc1,loc2,min,max,exc)
	end
	return g
end
function Duel.Group(f,tp,loc1,loc2,exc,...)
	local g=Duel.GetMatchingGroup(f,tp,loc1,loc2,exc,...)
	return g
end
function Duel.HintMessage(tp,msg)
	return Duel.Hint(HINT_SELECTMSG,tp,msg)
end
function Auxiliary.Necro(f)
	return aux.NecroValleyFilter(f)
end
function Card.Activation(c,oath,cond,cost,tg,op)
	local e1=Effect.CreateEffect(c)
	if c:IsOriginalType(TYPE_PENDULUM) then
		e1:SetDescription(STRING_ACTIVATE_PENDULUM)
	end
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if oath then
		e1:HOPT(true)
	end
	if cond then
		e1:SetCondition(cond)
	end
	if cost then
		e1:SetCost(cost)
	end
	if tg then
		e1:SetTarget(tg)
	end
	if op then
		e1:SetOperation(op)
	end
	c:RegisterEffect(e1)
	return e1
end
function Effect.SetFunctions(e,cond,cost,tg,op,val)
	if cond then
		e:SetCondition(cond)
	end
	if cost then
		e:SetCost(cost)
	end
	if tg then
		e:SetTarget(tg)
	end
	if op then
		e:SetOperation(op)
	end
	if val then
		e:SetValue(val)
	end
end
--[[Effect.Evaluate
Get the value of an effect. If the effect has a function as value, it calculates the value of the function
]]
function Effect.Evaluate(e,...)
	local extraargs={...}
	local val=e:GetValue()
	if not val then return false end
	if type(val)=="function" then
		local results={val(e,table.unpack(extraargs))}
		return table.unpack(results)
	else
		return val
	end
end

--Custom Categories
if not global_effect_category_table_global_check then
	global_effect_category_table_global_check=true
	global_effect_category_table={}
	global_effect_info_table={}
	global_possible_custom_effect_info_table={}
	global_additional_info_table={}
	global_possible_info_table={}
end
function Effect.SetCustomCategory(e,cat,flags)
	if not cat then cat=0 end
	if not flags then flags=0 end
	if not global_effect_category_table[e] then global_effect_category_table[e]={} end
	global_effect_category_table[e][1]=cat
	global_effect_category_table[e][2]=flags
end
function Effect.GetCustomCategory(e)
	if not global_effect_category_table[e] then return 0,0 end
	return global_effect_category_table[e][1], global_effect_category_table[e][2]
end
function Effect.IsHasCustomCategory(e,cat1,cat2)
	local ocat1,ocat2=e:GetCustomCategory()
	return (cat1 and ocat1&cat1>0) or (cat2 and ocat2&cat2>0)
end

--New Operation Infos
function Auxiliary.ClearCustomOperationInfo(e,tp,eg,ep,ev,re,r,rp)
	for _,chtab in pairs(global_effect_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
	end
	global_effect_info_table={}
	e:Reset()
end
function Duel.SetCustomOperationInfo(ch,cat,g,ct,p,val,...)
	local extra={...}
	local chain = ch==0 and Duel.GetCurrentChain() or ch
	if g then
		if aux.GetValueType(g)=="Card" then
			g=Group.FromCards(g)
		end
		g:KeepAlive()
	end
	if not global_effect_info_table[chain] then
		global_effect_info_table[chain]={}
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(aux.ClearCustomOperationInfo)
	Duel.RegisterEffect(e1,0)
	table.insert(global_effect_info_table[chain],{cat,g,ct,p,val,table.unpack(extra)})
end
function Duel.GetCustomOperationInfo(chain,cat)
	if not global_effect_info_table[chain] then return end
	if not cat then
		return global_effect_info_table[chain]
	else
		local res={}
		local global=global_effect_info_table[chain]
		for _,tab in ipairs(global) do
			if tab[1]&cat==cat then
				table.insert(res,tab)
			end
		end
		return res
	end
end
function Auxiliary.ClearPossibleCustomOperationInfo(e,tp,eg,ep,ev,re,r,rp)
	for _,chtab in pairs(global_possible_custom_effect_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
	end
	global_possible_custom_effect_info_table={}
	e:Reset()
end
function Duel.SetPossibleCustomOperationInfo(ch,cat,g,ct,p,val,...)
	local extra={...}
	local chain = ch==0 and Duel.GetCurrentChain() or ch
	if g then
		if aux.GetValueType(g)=="Card" then
			g=Group.FromCards(g)
		end
		g:KeepAlive()
	end
	if not global_possible_custom_effect_info_table[chain] then
		global_possible_custom_effect_info_table[chain]={}
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(aux.ClearPossibleCustomOperationInfo)
	Duel.RegisterEffect(e1,0)
	table.insert(global_possible_custom_effect_info_table[chain],{cat,g,ct,p,val,table.unpack(extra)})
end
function Auxiliary.ClearPossibleOperationInfo(e,tp,eg,ep,ev,re,r,rp)
	for _,chtab in pairs(global_possible_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
	end
	global_possible_info_table={}
	e:Reset()
end
function Duel.SetPossibleOperationInfo(ch,cat,g,ct,p,val,...)
	local extra={...}
	local chain = ch==0 and Duel.GetCurrentChain() or ch
	if g then
		if aux.GetValueType(g)=="Card" then
			g=Group.FromCards(g)
		end
		g:KeepAlive()
	end
	if not global_possible_info_table[chain] then
		global_possible_info_table[chain]={}
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(aux.ClearPossibleOperationInfo)
	Duel.RegisterEffect(e1,0)
	table.insert(global_possible_info_table[chain],{cat,g,ct,p,val,table.unpack(extra)})
end
function Auxiliary.ClearAdditionalOperationInfo(e,tp,eg,ep,ev,re,r,rp)
	for _,chtab in pairs(global_additional_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
	end
	global_additional_info_table={}
	e:Reset()
end
function Duel.SetAdditionalOperationInfo(ch,cat,g,ct,p,val,...)
	local extra={...}
	local chain = ch==0 and Duel.GetCurrentChain() or ch
	if g then
		if aux.GetValueType(g)=="Card" then
			g=Group.FromCards(g)
		end
		g:KeepAlive()
	end
	if not global_additional_info_table[chain] then
		global_additional_info_table[chain]={}
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(aux.ClearAdditionalOperationInfo)
	Duel.RegisterEffect(e1,0)
	table.insert(global_additional_info_table[chain],{cat,g,ct,p,val,table.unpack(extra)})
end
function Duel.SetConditionalOperationInfo(f,ch,cat,g,ct,p,val,...)
	if f then
		Duel.SetOperationInfo(ch,cat,g,ct,p,val)
	else
		Duel.SetPossibleOperationInfo(ch,cat,g,ct,p,val,...)
	end
end
function Duel.SetConditionalCustomOperationInfo(f,ch,cat,g,ct,p,val,...)
	if f then
		Duel.SetCustomOperationInfo(ch,cat,g,ct,p,val,...)
	else
		Duel.SetPossibleCustomOperationInfo(ch,cat,g,ct,p,val,...)
	end
end

--Announce
function Duel.AnnounceNumberMinMax(p,min,max,f)
	local tab={}
	for i=min,max do
		if not f or f(i) then
			table.insert(tab,i)
		end
	end
	return Duel.AnnounceNumber(p,table.unpack(tab))
end

--Tables
function Auxiliary.FindInTable(tab,a,...)
	local extras={...}
	if a then
		table.insert(extras,a)
	end
	
	for _,param in ipairs(extras) do
		for _,elem in ipairs(tab) do
			if elem==param then
				return true
			end
		end
	end
	
	return false
end
function Auxiliary.FindBitInTable(tab,a,...)
	local extras={...}
	if a then
		table.insert(extras,a)
	end
	
	for _,param in ipairs(extras) do
		for _,elem in ipairs(tab) do
			if elem&param>0 then
				return true
			end
		end
	end
	
	return false
end

--Card Actions
function Duel.Attach(c,xyz)
	if aux.GetValueType(c)=="Card" then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(xyz,Group.FromCards(c))
		return xyz:GetOverlayGroup():IsContains(c)
			
	elseif aux.GetValueType(c)=="Group" then
		for tc in aux.Next(c) do
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(xyz,c)
		return c:FilterCount(function (card,group) return group:IsContains(card) end, nil, xyz:GetOverlayGroup())
	end
end

function Duel.Banish(g,pos,r)
	if not pos then pos=POS_FACEUP end
	if not r then r=REASON_EFFECT end
	return Duel.Remove(g,pos,r)
end
function Card.IsAbleToRemoveFacedown(c,tp,r)
	if not r then r=REASON_EFFECT end
	return c:IsAbleToRemove(tp,POS_FACEDOWN,r)
end
function Card.IsAbleToRemoveTemp(c,tp,r)
	if not r then r=REASON_EFFECT end
	local pos = c:GetPosition()&POS_FACEDOWN>0 and POS_FACEDOWN or POS_FACEUP
	return c:IsAbleToRemove(tp,pos,r|REASON_TEMPORARY)
end
function Duel.BanishUntil(g,e,tp,pos,phase,id,phasect,phasenext,rc,r,disregard_turncount,counts_turns,op,loc,lingering_effect_to_reset)
	if not e then
		e=self_reference_effect
	end
	if not tp then
		tp=current_triggering_player
	end
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if not phase then phase=PHASE_END end
	if not phasect then phasect=1 end
	if not rc then rc=e:GetHandler() end
	if not r then r=REASON_EFFECT end
	if not loc then loc=LOCATION_REMOVED end
	
	local ct=0
	if pos or op then
		if not op then
			ct=Duel.Remove(g,pos,r|REASON_TEMPORARY)
		else
			ct=op(g,r|REASON_TEMPORARY)
		end
	else
		for tc in aux.Next(g) do
			local locpos=tc:IsFaceup() and POS_FACEUP or POS_FACEDOWN
			ct=ct+Duel.Remove(tc,locpos,r|REASON_TEMPORARY)
		end
	end
	if ct>0 then
		local og=g:Filter(Card.IsLocation,nil,loc)
		if #og>0 then
			og:KeepAlive()
			local turnct,turnct2=phasect-1,phasect
			local ph = phase&(PHASE_DRAW|PHASE_STANDBY|PHASE_MAIN1|PHASE_BATTLE_START|PHASE_BATTLE_STEP|PHASE_DAMAGE|PHASE_DAMAGE_CAL|PHASE_BATTLE|PHASE_MAIN2|PHASE_END)
			local player = phase&(RESET_SELF_TURN|RESET_OPPO_TURN)
			local p = player==RESET_SELF_TURN and tp or player==RESET_OPPO_TURN and 1-tp or nil
			
			--Debug.Message(phasenext)
			--Debug.Message(Duel.GetCurrentPhase().." "..ph)
			--Debug.Message(Duel.GetTurnPlayer().." "..tostring(p))
			if Duel.GetCurrentPhase()>ph or (p and Duel.GetTurnPlayer()~=p) or (phasenext and Duel.GetCurrentPhase()==ph and (not p or Duel.GetTurnPlayer()==p)) then
				turnct=turnct+1
				if phasenext and Duel.GetCurrentPhase()==ph and (not p or Duel.GetTurnPlayer()==p) then
					turnct2=turnct2+1
				end
			end
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|phase,EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_CLIENT_HINT,turnct2,0,STRING_TEMPORARILY_BANISHED)
			end
			local turnct0 = not p and Duel.GetTurnCount() or Duel.GetTurnCount(p)
			local e1=Effect.CreateEffect(rc)
			e1:SetDescription(STRING_RETURN_TO_FIELD)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|ph)
			e1:SetReset(RESET_PHASE|phase,turnct2)
			e1:SetCountLimit(1)
			e1:SetLabel(turnct0+turnct)
			e1:SetLabelObject(og)
			if not counts_turns then
				e1:SetCondition(aux.TimingCondition(ph,p,disregard_turncount))
			else
				e1:SetCondition(aux.TimingConditionButCountsTurns(counts_turns))
			end
			e1:SetOperation(aux.ReturnLabelObjectToFieldOp(id,lingering_effect_to_reset))
			Duel.RegisterEffect(e1,tp)
			return ct,e1
		end
	end
	return ct,nil
end
function Duel.ToExtraUntil(g,e,tp,phase,id,phasect,phasenext,rc,r,disregard_turncount,counts_turns)
	local op = function(og,reason)
		return Duel.SendtoExtraP(og,nil,reason)
	end
	return Duel.BanishUntil(g,e,tp,nil,phase,id,phasect,phasenext,rc,r,disregard_turncount,counts_turns,op,LOCATION_EXTRA)
end

function Auxiliary.TimingCondition(phase,p,disregard_turncount)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				--Debug.Message(Duel.GetTurnCount().." "..e:GetLabel())
				--Debug.Message(e:GetLabelObject():GetFirst():GetReasonEffect())
				--Debug.Message(Duel.GetTurnCount(p).." "..e:GetLabel())
				local turnct = not p and Duel.GetTurnCount() or Duel.GetTurnCount(p)
				return Duel.GetCurrentPhase()==phase and (not p or Duel.GetTurnPlayer()==p) and (disregard_turncount or turnct==e:GetLabel())
			end
end
function Auxiliary.TimingConditionButCountsTurns(counts_turns)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local tc=e:GetOwner()
				local ct=tc:GetTurnCounter()
				--Debug.Message(ct.." "..counts_turns)
				if ct==counts_turns then
					return true
				end
				if ct>counts_turns then
					e:Reset()
				end
				return false
			end
end
function Auxiliary.ReturnLabelObjectToFieldOp(id,lingering_effect_to_reset)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=e:GetLabelObject()
				local ltype=aux.GetValueType(lingering_effect_to_reset)
				--Debug.Message("OBJSIZE: "..#g)
				local sg=g:Filter(Card.HasFlagEffect,nil,id)
				local rg=Group.CreateGroup()
				for p=tp,1-tp,1-2*tp do
					local sg1=sg:Filter(Card.IsPreviousControler,nil,p)
					if #sg1>0 then
						local sgm=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
						--Debug.Message("SGM: "..#sgm)
						local ft=Duel.GetLocationCount(p,LOCATION_MZONE)
						if ft>0 then
							if ft<#sgm then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
								local tg=sgm:Select(tp,ft,ft,nil)
								if #tg>0 then
									rg:Merge(tg)
								end
							else
								rg:Merge(sgm)
							end
						end
						local sgs=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_SZONE):Filter(aux.NOT(Card.IsPreviousLocation),nil,LOCATION_FZONE)
						--Debug.Message("SGS: "..#sgs)
						local ft=Duel.GetLocationCount(p,LOCATION_SZONE)
						if ft>0 then
							if ft<#sgs then
								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
								local tg=sgs:Select(tp,ft,ft,nil)
								if #tg>0 then
									rg:Merge(tg)
								end
							else
								rg:Merge(sgs)
							end
						end
						local sgf=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_FZONE)
						rg:Merge(sgf)
					end
				end
				--Debug.Message(#rg)
				if #rg>0 then
					for tc in aux.Next(rg) do
						if tc:IsPreviousLocation(LOCATION_FZONE) then
							Duel.MoveToField(tc,tp,tc:GetPreviousControler(),LOCATION_FZONE,tc:GetPreviousPosition(),true)
						else
							local e1
							if tc:IsInExtra() and tc:IsFaceup() then
								e1=Effect.CreateEffect(tc)
								e1:SetType(EFFECT_TYPE_SINGLE)
								e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|EFFECT_FLAG_IGNORE_IMMUNE)
								e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
								e1:SetValue(1)
								e1:SetReset(RESET_EVENT|RESETS_STANDARD)
								tc:RegisterEffect(e1,true)
							end
							--Debug.Message(tc:GetReasonEffect())
							--Debug.Message(e:GetOwner())
							Duel.ReturnToField(tc,tc:GetPreviousPosition(),0xff&(~EXTRA_MONSTER_ZONE))
							if e1 then e1:Reset() end
						end
						if ltype=="number" then
							tc:ResetFlagEffect(lingering_effect_to_reset)
						end
					end
				end
				if ltype=="Effect" then
					lingering_effect_to_reset:Reset()
				end
				g:DeleteGroup()
			end
end

--Effect Building
Auxiliary.TargetRangeTable={}

local effect_set_target_range = Effect.SetTargetRange

Effect.SetTargetRange=function(e,self,oppo)
	local table_oppo = oppo
	if type(oppo)==nil then
		table_oppo=false
	end
	Auxiliary.TargetRangeTable[e]={self,table_oppo}
	return effect_set_target_range(e,self,oppo)
end

function Effect.GLGetTargetRange(e)
	if not Auxiliary.TargetRangeTable[e] then return false,false end
	local s=Auxiliary.TargetRangeTable[e][1]
	local o=Auxiliary.TargetRangeTable[e][2]
	return s,o
end

--For cards that equip other cards to themselves ONLY
function Duel.EquipAndRegisterLimit(e,p,be_equip,equip_to,...)
	local res=Duel.Equip(p,be_equip,equip_to,...)
	if res and equip_to:GetEquipGroup():IsContains(be_equip) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(function(e,c)
						return e:GetOwner()==c
					end
				   )
		be_equip:RegisterEffect(e1)
		return true
	end
	return false
end
--For effects that equip a card to another card
function Duel.EquipToOtherCardAndRegisterLimit(e,p,be_equip,equip_to,...)
	local res=Duel.Equip(p,be_equip,equip_to,...)
	if res and equip_to:GetEquipGroup():IsContains(be_equip) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(equip_to)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(function(e,c)
						return e:GetLabelObject()==c
					end
				   )
		be_equip:RegisterEffect(e1)
		return true
	end
	return false
end
function Duel.EquipAndRegisterCustomLimit(f,p,be_equip,equip_to,...)
	local res=Duel.Equip(p,be_equip,equip_to,...)
	if res and equip_to:GetEquipGroup():IsContains(be_equip) then
		local e1=Effect.CreateEffect(equip_to)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		e1:SetValue(f)
		be_equip:RegisterEffect(e1)
	end
	return res and equip_to:GetEquipGroup():IsContains(be_equip)
end

function Card.Recreate(c,...)
	local x={...}
	if #x==0 then return end
	local datalist={CARDDATA_CODE,CARDDATA_ALIAS,CARDDATA_SETCODE,CARDDATA_TYPE,CARDDATA_LEVEL,CARDDATA_ATTRIBUTE,CARDDATA_RACE,CARDDATA_ATTACK,CARDDATA_DEFENSE,CARDDATA_LSCALE,CARDDATA_RSCALE}
	for i,newval in ipairs(x) do
		if newval then
			c:SetCardData(datalist[i],newval)
		end
	end
end

function Card.CheckNegateConjunction(c,e1,e2,e3)
	return not c:IsImmuneToEffect(e1) and not c:IsImmuneToEffect(e2) and (not e3 or not c:IsImmuneToEffect(e3))
end

TYPE_NEGATE_ALL = TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP
function Duel.Negate(g,e,reset,notfield,forced,typ,cond)
	local rct=1
	if not reset then
		reset=0
	elseif type(reset)=="table" then
		rct=reset[2]
		reset=reset[1]
	end
	if not typ then typ=0 end
	
	local returntype=aux.GetValueType(g)
	if returntype=="Card" then
		g=Group.FromCards(g)
	end
	local check=0
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if cond then
			e1:SetCondition(cond)
		end
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
		tc:RegisterEffect(e1,forced)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		if cond then
			e2:SetCondition(cond)
		end
		if not notfield then
			e2:SetValue(RESET_TURN_SET)
		end
		e2:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
		tc:RegisterEffect(e2,forced)
		if not notfield and typ&TYPE_TRAP>0 and tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			if cond then
				e3:SetCondition(cond)
			end
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+reset,rct)
			tc:RegisterEffect(e3,forced)
			local res=tc:CheckNegateConjunction(e1,e2,e3)
			if res then
				Duel.AdjustInstantly(tc)
			end
			return e1,e2,e3,res
		end
		local res=tc:CheckNegateConjunction(e1,e2)
		if res then
			Duel.AdjustInstantly(tc)
		end
		if returntype=="Card" then
			return e1,e2,res
		elseif res then
			check=check+1
		end
	end
	return check
end

function Duel.NegateInGY(tc,e,reset)
	if not reset then reset=0 end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE+reset)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_EXC_GRAVE+reset)
	tc:RegisterEffect(e2)
	return e1,e2
end
function Duel.PositionChange(c)
	return Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end
function Duel.Search(g,tp,p)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	local ct=Duel.SendtoHand(g,p,REASON_EFFECT)
	local cg=g:Filter(aux.PLChk,nil,tp,LOCATION_HAND)
	if #cg>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	return ct,#cg,cg
end
function Duel.SearchAndCheck(g,tp,p,brk)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	local ct=Duel.SendtoHand(g,p,REASON_EFFECT)
	local cg=g:Filter(aux.PLChk,nil,tp,LOCATION_HAND)
	if #cg>0 then
		if brk then
			Duel.BreakEffect()
		end
		Duel.ConfirmCards(1-tp,cg)
	end
	return ct>0 and #cg>0
end
function Duel.Bounce(g)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	local cg=g:Filter(aux.PLChk,nil,nil,LOCATION_HAND)
	return ct,#cg,cg
end

function Duel.ShuffleIntoDeck(g,p,loc,seq,r)
	if not loc then loc=LOCATION_DECK|LOCATION_EXTRA end
	if not seq then seq=SEQ_DECKSHUFFLE end
	if not r then r=REASON_EFFECT end
	local ct=Duel.SendtoDeck(g,p,seq,r)
	if ct>0 then
		if seq==SEQ_DECKSHUFFLE then
			aux.AfterShuffle(g)
		end
		if aux.GetValueType(g)=="Card" and aux.PLChk(g,p,loc) then
			return 1
		elseif aux.GetValueType(g)=="Group" then
			return g:FilterCount(aux.PLChk,nil,p,loc)
		end
	end
	return 0
end
function Duel.PlaceOnTopOfDeck(g,p)
	local ct=Duel.SendtoDeck(g,p,SEQ_DECKTOP,REASON_EFFECT)
	if ct>0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
		for pp=tp,1-tp,1-2*tp do
			local dg=og:Filter(Card.IsControler,nil,pp)
			if #dg>1 then
				Duel.SortDecktop(p,pp,#dg)
			end
		end
		return ct
	end
	return 0
end

function Auxiliary.PLChk(c,p,loc,min,pos)
	if aux.GetValueType(c)=="Card" then
		if min and not pos then pos=min end
		return (not p or c:IsControler(p)) and (not loc or c:IsLocation(loc)) and (not pos or c:IsPosition(pos))
	elseif aux.GetValueType(c)=="Group" then
		if not min then min=1 end
		return c:IsExists(aux.PLChk,min,nil,p,loc,pos)
	else
		return false
	end
end
function Auxiliary.BecauseOfThisEffect(e)
	return	function(c)
				return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REDIRECT) and c:GetReasonEffect()==e
			end
end
function Duel.GetGroupOperatedByThisEffect(e,exc)
	return Duel.GetOperatedGroup():Filter(aux.BecauseOfThisEffect(e),exc)
end
function Auxiliary.AfterShuffle(g)
	for p=0,1 do
		if aux.PLChk(g,p,LOCATION_DECK) then
			Duel.ShuffleDeck(p)
		end
	end
end

--Battle Phase
function Card.IsCapableOfAttacking(c,tp)
	if not tp then tp=Duel.GetTurnPlayer() end
	return not c:IsForbidden() and not c:IsHasEffect(EFFECT_CANNOT_ATTACK) and not c:IsHasEffect(EFFECT_ATTACK_DISABLED) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_BP)
end

function Duel.GetBattleGroup()
	local g=Group.CreateGroup()
	for p=0,1 do
		local c=Duel.GetBattleMonster(p)
		if c then
			g:AddCard(c)
		end
	end
	local d=Duel.GetAttackTarget
	if d and #g==1 then
		g:AddCard(d)
	end
	return g
end

--Card Filters
function Card.IsMonster(c,typ)
	return c:IsType(TYPE_MONSTER) and (aux.GetValueType(typ)~="number" or c:IsType(typ))
end
function Card.IsSpell(c,typ)
	return c:IsType(TYPE_SPELL) and (aux.GetValueType(typ)~="number" or c:IsType(typ))
end
function Card.IsTrap(c,typ)
	return c:IsType(TYPE_TRAP) and (aux.GetValueType(typ)~="number" or c:IsType(typ))
end
function Card.IsNormalSpell(c)
	return c:GetType()&(TYPE_SPELL|TYPE_CONTINUOUS|TYPE_RITUAL|TYPE_EQUIP|TYPE_QUICKPLAY|TYPE_FIELD)==TYPE_SPELL
end
function Card.IsNormalTrap(c)
	return c:GetType()&(TYPE_TRAP|TYPE_CONTINUOUS|TYPE_COUNTER)==TYPE_TRAP
end
function Card.IsNormalST(c)
	return c:IsNormalSpell() or c:IsNormalTrap()
end
function Card.IsST(c,typ)
	return c:IsType(TYPE_ST) and (aux.GetValueType(typ)~="number" or c:IsType(typ))
end
function Card.IsMonsterCard(c)
	return c:IsOriginalType(TYPE_MONSTER)
end
function Card.IsPendulumMonsterCard(c)
	return c:IsOriginalType(TYPE_PENDULUM) and c:IsOriginalType(TYPE_MONSTER)
end
function Card.MonsterOrFacedown(c)
	return c:IsMonster() or c:IsFacedown()
end

function Card.IsSpecialSummoned(c,loc,p)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and (not loc or c:IsSummonLocation(loc)) and (not p or c:IsSummonPlayer(p))
end

function Card.IsAttributeRace(c,attr,race)
	return c:IsAttribute(attr) and c:IsRace(race)
end

function Card.IsAppropriateEquipSpell(c,ec,tp)
	return c:IsSpell(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function Card.HasAttack(c)
	return c:IsMonster()
end
function Card.IsCanChangeAttack(c)
	return c:IsFaceup() and c:HasAttack()
end

function Card.HasDefense(c)
	return c:IsMonster() and not c:IsOriginalType(TYPE_LINK)
end
function Card.IsCanChangeDefense(c)
	return c:IsFaceup() and c:HasDefense()
end

function Card.IsCanChangeStats(c)
	return c:IsFaceup() and (c:HasAttack() or c:HasDefense())
end

function Card.HasRank(c)
	return c:IsOriginalType(TYPE_XYZ)
end
function Auxiliary.GetCappedDefense(c)
	local x=c:GetDefense()
	if x>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return x
	end
end

function Card.HasHighest(c,stat,g,f)
	if not g then g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE):Filter(Card.IsFaceup,nil) end
	local func	=	function(tc,val,fil)
						return stat(tc)>val and (not fil or fil(tc))
					end
	return not g:IsExists(func,1,c,stat(c),f)
end
function Card.HasLowest(c,stat,g,f)
	if not g then g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE):Filter(Card.IsFaceup,nil) end
	local func	=	function(tc,val,fil)
						return stat(tc)<val and (not fil or fil(tc))
					end
	return not g:IsExists(func,1,c,stat(c),f)
end
function Card.HasHighestATK(c,g,f)
	return c:HasHighest(Card.GetAttack,g,f)
end
function Card.HasLowestATK(c,g,f)
	return c:HasLowest(Card.GetAttack,g,f)
end
function Card.HasHighestDEF(c,g,f)
	return c:HasHighest(Card.GetDefense,g,f)
end
function Card.HasLowestDEF(c,g,f)
	return c:HasLowest(Card.GetDefense,g,f)
end

function Card.HasOriginalLevel(c)
	return not c:IsOriginalType(TYPE_XYZ+TYPE_LINK)
end

function Card.IsOriginalType(c,typ)
	return c:GetOriginalType()&typ>0
end
function Card.IsOriginalAttribute(c,att)
	return c:GetOriginalAttribute()&att>0
end
function Card.IsOriginalRace(c,rc)
	return c:GetOriginalRace()&rc>0
end

function Card.IsReasonPlayer(c,p)
	return c:GetReasonPlayer()==p
end

function Card.HasRank(c)
	return c:IsType(TYPE_XYZ) or c:IsOriginalType(TYPE_XYZ) or c:IsHasEffect(EFFECT_ORIGINAL_LEVEL_RANK_DUALITY)
end

function Card.GetOriginalLink(c)
	local link=0
	local markers=c:GetOriginalLinkMarker()
	local i=1
	while i<=LINK_MARKER_TOP_RIGHT do
		if markers&i==i then
			link=link+1
		end
		i=i<<1
	end
	return link
end

function Card.GetRating(c)
	local list={false,false,false,false}
	if c:HasLevel() then
		list[1]=c:GetLevel()
	end
	if c:IsOriginalType(TYPE_XYZ) then
		list[2]=c:GetRank()
	end
	if c:IsOriginalType(TYPE_LINK) then
		list[3]=c:GetLink()
	end
	if c:IsOriginalType(TYPE_TIMELEAP) then
		list[4]=c:GetFuture()
	end
	return list
end
function Card.GetRatingAuto(c)
	if c:HasLevel() then
		return c:GetLevel(),0
	end
	if c:IsOriginalType(TYPE_XYZ) then
		return c:GetRank(),TYPE_XYZ
	end
	if c:IsOriginalType(TYPE_LINK) then
		return c:GetLink(),TYPE_LINK
	end
	return 0,nil
end
function Card.GetOriginalRating(c)
	local list={false,false,false}
	if c:HasLevel(true) then
		list[1]=c:GetOriginalLevel()
	end
	if c:IsOriginalType(TYPE_XYZ) then
		list[2]=c:GetOriginalRank()
	end
	if c:IsOriginalType(TYPE_LINK) then
		list[3]=c:GetOriginalLink()
	end
	return list
end
function Card.GetOriginalRatingAuto(c)
	if c:HasLevel(true) then
		return c:GetOriginalLevel(),0
	end
	if c:IsOriginalType(TYPE_XYZ) then
		return c:GetOriginalRank(),TYPE_XYZ
	end
	if c:IsOriginalType(TYPE_LINK) then
		return c:GetOriginalLink(),TYPE_LINK
	end
	return 0,nil
end
	
function Card.IsRating(c,rtyp,...)
	local x={...}
	local lv=rtyp&RATING_LEVEL>0
	local rk=rtyp&RATING_RANK>0
	local link=rtyp&RATING_LINK>0
	local fut=rtyp&RATING_FUTURE>0
	for i,n in ipairs(x) do
		if (lv and c:HasLevel() and c:IsLevel(n)) or (rk and c:HasRank() and c:IsRank(n)) or (link and c:IsOriginalType(TYPE_LINK) and c:IsLink(n))
			or (fut and c:IsOriginalType(TYPE_TIMELEAP) and c:IsFuture(n)) then
			return true
		end
	end
	return false
end
function Card.IsRatingAbove(c,rtyp,...)
	local x={...}
	local lv=rtyp&RATING_LEVEL>0
	local rk=rtyp&RATING_RANK>0
	local link=rtyp&RATING_LINK>0
	local fut=rtyp&RATING_FUTURE>0
	for i,n in ipairs(x) do
		if (lv and c:HasLevel() and c:IsLevelAbove(n)) or (rk and c:HasRank() and c:IsRankAbove(n)) or (link and c:IsOriginalType(TYPE_LINK) and c:IsLinkAbove(n))
			or (fut and c:IsOriginalType(TYPE_TIMELEAP) and c:IsFutureAbove(n)) then
			return true
		end
	end
end
function Card.IsRatingBelow(c,rtyp,...)
	local x={...}
	local lv=rtyp&RATING_LEVEL>0
	local rk=rtyp&RATING_RANK>0
	local link=rtyp&RATING_LINK>0
	local fut=rtyp&RATING_FUTURE>0
	for i,n in ipairs(x) do
		if (lv and c:HasLevel() and c:IsLevelBelow(n)) or (rk and c:HasRank() and c:IsRankBelow(n)) or (link and c:IsOriginalType(TYPE_LINK) and c:IsLinkBelow(n))
			or (fut and c:IsOriginalType(TYPE_TIMELEAP) and c:IsFutureBelow(n)) then
			return true
		end
	end
end

function Card.IsStats(c,atk,def)
	return (not atk or (c:HasAttack() and c:IsAttack(atk))) and (not def or (c:HasDefense() and c:IsDefense(def)))
end
function Card.IsStat(c,rtyp,...)
	local x={...}
	local atk=rtyp&STAT_ATTACK>0
	local def=rtyp&STAT_DEFENSE>0
	for i,n in ipairs(x) do
		if (not atk or (c:HasAttack() and c:IsAttack(n))) and (not def or (c:HasDefense() and c:IsDefense(n))) then
			return true
		end
	end
	return false
end
function Card.IsStatBelow(c,rtyp,...)
	local x={...}
	local atk=rtyp&STAT_ATTACK>0
	local def=rtyp&STAT_DEFENSE>0
	for i,n in ipairs(x) do
		if (not atk or (c:HasAttack() and c:IsAttackBelow(n))) or (not def or (c:HasDefense() and c:IsDefenseBelow(n))) then
			return true
		end
	end
	return false
end
function Card.IsStatAbove(c,rtyp,...)
	local x={...}
	local atk=rtyp&STAT_ATTACK>0
	local def=rtyp&STAT_DEFENSE>0
	for i,n in ipairs(x) do
		if (not atk or (c:HasAttack() and c:IsAttackAbove(n))) or (not def or (c:HasDefense() and c:IsDefenseAbove(n))) then
			return true
		end
	end
	return false
end

function Card.GetMechanicSummonType(c)
	local ctypes={
		[TYPE_FUSION]=SUMMON_TYPE_FUSION;
		[TYPE_RITUAL]=SUMMON_TYPE_RITUAL;
		[TYPE_SYNCHRO]=SUMMON_TYPE_SYNCHRO;
		[TYPE_XYZ]=SUMMON_TYPE_XYZ;
		[TYPE_LINK]=SUMMON_TYPE_LINK;
	}
	for typ,sumtyp in pairs(ctypes) do
		if c:IsType(typ) then
			return sumtyp
		end
	end
	return 0
end

function Card.ByBattleOrEffect(c,f,p)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and (not f or re and f(re:GetHandler(),e,tp,eg,ep,ev,re,r,rp)) and (not p or rp~=(1-p))
			end
end

function Card.IsContained(c,g,exc)
	return g:IsContains(c) and (not exc or not exc:IsContains(c))
end

function Card.GetResidence(c)
	return c:GetControler(),c:GetLocation(),c:GetSequence(),c:GetPosition()
end

--Chain Info
function Duel.GetTargetCards()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,nil)
end
function Duel.GetTargetPlayer()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
end
function Duel.GetTargetParam()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
end

--Cloned Effects
function Effect.SpecialSummonEventClone(e,c,notreg)
	local ex=e:Clone()
	ex:SetCode(EVENT_SPSUMMON_SUCCESS)
	if not notreg then
		c:RegisterEffect(ex)
	end
	return ex
end
function Effect.FlipSummonEventClone(e,c,notreg)
	local ex=e:Clone()
	ex:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	if not notreg then
		c:RegisterEffect(ex)
	end
	return ex
end
function Effect.UpdateDefenseClone(e,c,notreg)
	local ex=e:Clone()
	ex:SetCode(EFFECT_UPDATE_DEFENSE)
	if not notreg then
		c:RegisterEffect(ex)
	end
	return ex
end
function Effect.SetDefenseFinalClone(e,c,notreg)
	local ex=e:Clone()
	ex:SetCode(EFFECT_SET_DEFENSE_FINAL)
	if not notreg then
		c:RegisterEffect(ex)
	end
	return ex
end
--codes
function Card.IsOriginalCode(c,code)
	return c:GetOriginalCode()==code
end

--Columns
function Card.GlitchyGetColumnGroup(c,left,right,without_center)
	local left = (left and aux.GetValueType(left)=="number" and left>=0) and left or 0
	local right = (right and aux.GetValueType(right)=="number" and right>=0) and right or 0
	if left==0 and right==0 then
		return c:GetColumnGroup()
	else
		local f = 	function(card,refc,val)
						local refseq
						if refc:GetSequence()<5 then
							refseq=refc:GetSequence()
						else
							if refc:GetSequence()==5 then
								refseq = 1
							elseif refc:GetSequence()==6 then
								refseq = 3
							end
						end
						
						if card:GetSequence()<5 then
							if card:IsControler(refc:GetControler()) then
								return math.abs(refseq-card:GetSequence())==val
							else
								return math.abs(refseq+card:GetSequence()-4)==val
							end
						
						elseif card:GetSequence()==5 then
							local seq = card:IsControler(refc:GetControler()) and 1 or 3
							return math.abs(refseq-seq)==val
						elseif card:GetSequence()==6 then
							local seq = card:IsControler(refc:GetControler()) and 3 or 1
							return math.abs(refseq-seq)==val
						end
					end
					
		local lg=Duel.Group(f,c:GetControler(),LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,c,left)
		local cg = without_center and Group.CreateGroup() or c:GetColumnGroup()
		local rg=Duel.Group(f,c:GetControler(),LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,c,right)
		cg:Merge(lg)
		cg:Merge(rg)
		return cg
	end
end
function Card.GlitchyGetPreviousColumnGroup(c,left,right,without_center)
	local left = (left and aux.GetValueType(left)=="number" and left>=0) and left or 0
	local right = (right and aux.GetValueType(right)=="number" and right>=0) and right or 0
	if left==0 and right==0 then
		return c:GetColumnGroup()
	else
		local f = 	function(card,refc,val)
						local refseq
						if refc:GetPreviousSequence()<5 then
							refseq=refc:GetPreviousSequence()
						else
							if refc:GetPreviousSequence()==5 then
								refseq = 1
							elseif refc:GetPreviousSequence()==6 then
								refseq = 3
							end
						end
						
						if card:GetSequence()<5 then
							if card:IsControler(refc:GetPreviousControler()) then
								return math.abs(refseq-card:GetSequence())==val
							else
								return math.abs(refseq+card:GetSequence()-4)==val
							end
						
						elseif card:GetSequence()==5 then
							local seq = card:IsControler(refc:GetPreviousControler()) and 1 or 3
							return math.abs(refseq-seq)==val
						elseif card:GetSequence()==6 then
							local seq = card:IsControler(refc:GetPreviousControler()) and 3 or 1
							return math.abs(refseq-seq)==val
						end
					end
					
		local lg=Duel.Group(f,c:GetPreviousControler(),LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,c,left)
		local cg = without_center and Group.CreateGroup() or c:GetColumnGroup()
		local rg=Duel.Group(f,c:GetPreviousControler(),LOCATION_MZONE+LOCATION_SZONE,LOCATION_MZONE+LOCATION_SZONE,nil,c,right)
		cg:Merge(lg)
		cg:Merge(rg)
		return cg
	end
end

--Counters
RELEVANT_REMOVE_EVENT_COUNTERS = {0x100e}
COUNTED_COUNTERS_FOR_REMOVE_EVENT = {}

function Card.HasCounter(c,ctype)
	return c:GetCounter(ctype)>0
end
function Card.CountRelevantCountersForRemoveEvent(c)
	for _,ctype in ipairs(RELEVANT_REMOVE_EVENT_COUNTERS) do
		local ct=c:GetCounter(ctype)
		if ct>0 then
			if not COUNTED_COUNTERS_FOR_REMOVE_EVENT[ctype] then
				COUNTED_COUNTERS_FOR_REMOVE_EVENT[ctype]=0
			end
			COUNTED_COUNTERS_FOR_REMOVE_EVENT[ctype]=COUNTED_COUNTERS_FOR_REMOVE_EVENT[ctype]+ct
		end
	end
end
function Duel.RaiseRelevantRemoveCounterEvents(eg,re,r,rp,ep)
	for _,ctype in ipairs(RELEVANT_REMOVE_EVENT_COUNTERS) do
		local count=COUNTED_COUNTERS_FOR_REMOVE_EVENT[ctype]
		if count then
			Duel.RaiseEvent(eg,EVENT_REMOVE_COUNTER+ctype,re,r,rp,ep,count)
		end
	end
	COUNTED_COUNTERS_FOR_REMOVE_EVENT={}
end

--Auxiliary for Duel.DistributeCounters
function Auxiliary.DistributeCountersGroupCheck(ctype)
	return	function(g,val,n)
				if val<1 then return false end
				for c in aux.Next(g) do
					for i=val,1,-1 do
						if c:IsCanAddCounter(ctype,i) then
							if val==i then
								if not n then
									return true
								end
								n=n-1
								if n==0 then
									return true
								end
								n=n+1
							else
								val=val-i
								if n then n=n-1 end
								local sg=g:Clone()
								sg:RemoveCard(c)
								local res=sg:CheckSubGroup(aux.DistributeCountersGroupCheck(ctype),#sg,#sg,val,n)
								sg:DeleteGroup()
								val=val+i
								if n then n=n+1 end
								if res then
									return true
								end
							end
						end
					end
				end
				return false
			end
end

--[[Distributes counters among cards
• tp = Player that will distribute the counters
• ctype = Counter type
• n = Number of counters to distribute
• g = Group of cards among which the counters will be distributed
• id = Flag
]]
function Duel.DistributeCounters(tp,ctype,n,g,id)
	local conjunction_success=false
	Duel.HintMessage(tp,HINTMSG_COUNTER)
	local sg=g:SelectSubGroup(tp,aux.DistributeCountersGroupCheck(ctype),false,1,math.min(#g,n),n)
	local ct=0
	for tc in aux.Next(sg) do
		Duel.HintSelection(Group.FromCards(tc))
		tc:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_IGNORE_IMMUNE,1)
		local nums={}
		for i=n-ct,1,-1 do
			if tc:IsCanAddCounter(ctype,i,false) then
				local ng=sg:Filter(Card.HasFlagEffect,nil,id)
				local fg=sg:Filter(aux.NOT(Card.HasFlagEffect),nil,id)
				if (#ng==#sg or fg:CheckSubGroup(aux.DistributeCountersGroupCheck(ctype),#fg,#fg,n-ct-i,#fg)) then
					table.insert(nums,i)
					if #ng==#sg then
						break
					end
				end
			end
		end
		local n=Duel.AnnounceNumber(tp,table.unpack(nums))
		if tc:AddCounter(ctype,n) then
			conjunction_success=true
		end
		ct=ct+n
	end
	return conjunction_success
end
--Exception
function Auxiliary.ActivateException(e,chk)
	local c=e:GetHandler()
	if c and e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD+TYPE_EQUIP) and not c:IsHasEffect(EFFECT_REMAIN_FIELD) and (chk or c:IsRelateToChain(0)) then
		return c
	else
		return
	end
end
function Auxiliary.ExceptThis(c)
	if aux.GetValueType(c)=="Effect" then c=c:GetHandler() end
	if c:IsRelateToChain() then return c else return nil end
end

--Descriptions
function Effect.Desc(e,id,...)
	local x = {...}
	local c=e:GetOwner()
	if aux.GetValueType(aux.EffectBeingApplied)=="Effect" and aux.GetValueType(aux.ProxyEffect)=="Effect" and aux.ProxyEffect:GetOwner()==c then
		c=aux.EffectBeingApplied:GetOwner()
	end
	local code = #x>0 and x[1] or c:GetOriginalCode()
	if id<16 then
		return e:SetDescription(aux.Stringid(code,id))
	else
		return e:SetDescription(id)
	end
end
function Card.AskPlayer(c,tp,desc)
	if aux.GetValueType(aux.EffectBeingApplied)=="Effect" and aux.GetValueType(aux.ProxyEffect)=="Effect" and aux.ProxyEffect:GetHandler()==c then
		c=aux.EffectBeingApplied:GetHandler()
	end
	local string = desc<=15 and aux.Stringid(c:GetOriginalCode(),desc) or desc
	return Duel.SelectYesNo(tp,string)
end
function Duel.Ask(tp,id,desc)
	if desc and (desc<0 or desc>15) then desc=0 end
	local string = desc and aux.Stringid(id,desc) or id
	return Duel.SelectYesNo(tp,string)
end

function Auxiliary.Option(id,tp,desc,...)
	if id<2 then
		id,tp=tp,id
	end
	local list={...}
	local off=1
	local ops={}
	local opval={}
	local truect=1
	for ct,b in ipairs(list) do
		local check=b
		local localid
		local localdesc
		if aux.GetValueType(b)=="table" then
			check=b[1]
			if #b==3 then
				localid=b[2]
				localdesc=b[3]
			else
				localid=false
				localdesc=b[2]
			end
		else
			localid=id
			localdesc=desc+truect-1
			truect=truect+1
		end
		if check==true then
			if localid then
				ops[off]=aux.Stringid(localid,localdesc)
			else
				ops[off]=localdesc
			end
			opval[off]=ct-1
			off=off+1
		end
	end
	if #ops==0 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	--Duel.Hint(HINT_OPSELECTED,1-tp,ops[op])
	return sel
end

function Duel.RegisterHint(p,flag,reset,rct,id,desc,prop)
	if not reset then reset=PHASE_END end
	if not rct then rct=1 end
	if not prop then prop=0 end
	return Duel.RegisterFlagEffect(p,flag,RESET_PHASE+reset,EFFECT_FLAG_CLIENT_HINT|prop,rct,0,aux.Stringid(id,desc))
end

--EDOPro Imports
function Auxiliary.BitSplit(v)
	local res={}
	local i=0
	while 2^i<=v do
		local p=2^i
		if v & p~=0 then
			table.insert(res,p)
		end
		i=i+1
	end
	return pairs(res)
end
function Auxiliary.GetAttributeStrings(v)
	local t = {
		[ATTRIBUTE_EARTH] = 1010,
		[ATTRIBUTE_WATER] = 1011,
		[ATTRIBUTE_FIRE] = 1012,
		[ATTRIBUTE_WIND] = 1013,
		[ATTRIBUTE_LIGHT] = 1014,
		[ATTRIBUTE_DARK] = 1015,
		[ATTRIBUTE_DIVINE] = 1016
	}
	local res={}
	local ct=0
	for _,att in Auxiliary.BitSplit(v) do
		if t[att] then
			table.insert(res,t[att])
			ct=ct+1
		end
	end
	return pairs(res)
end

function Group.CheckSameProperty(g,f,...)
	local chk=nil
	for tc in aux.Next(g) do
		chk = chk and (chk&f(tc,...)) or f(tc,...)
		if chk==0 then return false,0 end
	end
	return true, chk
end

--sg: This group is initially empty and is gradually filled with cards from g.
--mg: This is a clone of the sample group (g) but it does not contain the cards that failed the loop check
--rescon: The condition that must be satisfied by the cards in the temporary checked group (sg). If the "stop" condition is fulfilled, the card is immediately removed from "sg" and fails the loop check
function Auxiliary.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
	local res=not rescon
	if #sg>=maxc then return false end
	sg:AddCard(c)
	if rescon then
		local stop
		res,stop=rescon(sg,e,tp,mg,c)
		if stop then
			sg:RemoveCard(c)
			return false
		end
	end
	if #sg<minc then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	elseif #sg<maxc and not res then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable)
	local minc=minc or 1
	local maxc=maxc or #g
	if chk==0 then
		if #g<minc then return false end
		local eg=g:Clone()
		for c in aux.Next(g) do
			if Auxiliary.SelectUnselectLoop(c,Group.CreateGroup(),eg,e,tp,minc,maxc,rescon) then return true end
			eg:RemoveCard(c)
		end
		return false
	end
	local hintmsg=hintmsg or 0
	local sg=Group.CreateGroup()
	while true do
		local finishable = #sg>=minc and (not finishcon or finishcon(sg,e,tp,g))
		local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,g,e,tp,minc,maxc,rescon)
		if (breakcon and breakcon(sg,e,tp,mg)) or #mg<=0 or #sg>=maxc then break end
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
		local tc=mg:SelectUnselect(sg,seltp,finishable,finishable or (cancelable and #sg==0),minc,maxc)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	return sg
end
--check for Free Monster Zones
function Auxiliary.ChkfMMZ(sumcount)
	return	function(sg,e,tp,mg)
				return Duel.GetMZoneCount(tp,sg)>=sumcount
			end
end

--Equip
function Auxiliary.IsEquippedCond(e)
	return e:GetHandler():GetEquipTarget()
end

--Excavate
function Duel.IsPlayerCanExcavateAndSpecialSummon(tp)
	return Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,CARD_EHERO_BLAZEMAN)
end

--Filters
function Auxiliary.Filter(f,...)
	local ext_params={...}
	return aux.FilterBoolFunction(f,table.unpack(ext_params))
end
function Auxiliary.BuildFilter(f,...)
	local ext_params={...}
	return	function(c)
				for _,func in ipairs(ext_params) do
					if type(func)=="function" then
						if not func(c) then
							return false
						end
					elseif type(func)=="table" then
						if not func[1](c,func[2]) then
							return false
						end
					end
				end
				return true
			end
	
end
function Auxiliary.Faceup(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsFaceup()
			end
end
function Auxiliary.Facedown(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsFacedown()
			end
end
function Auxiliary.FaceupFilter(f,...)
	local ext_params={...}
	return	function(target)
				return target:IsFaceup() and f(target,table.unpack(ext_params))
			end
end
function Auxiliary.ArchetypeFilter(set,f,...)
	local ext_params={...}
	return	function(target)
				return target:IsSetCard(set) and (not f or f(target,table.unpack(ext_params)))
			end
end
function Auxiliary.MonsterFilter(typ,f,...)
	local ext_params={...}
	if type(typ)=="function" then
		if type(f)~="nil" then
			table.insert(ext_params,1,f)
		end
		f=typ
		typ=nil
	end
	return	function(target)
				return target:IsMonster(typ) and (not f or f(target,table.unpack(ext_params)))
			end
end
function Auxiliary.RaceFilter(race,f,...)
	local ext_params={...}
	return	function(target)
				return target:IsRace(race) and (not f or f(target,table.unpack(ext_params)))
			end
end
function Auxiliary.STFilter(f,...)
	local ext_params={...}
	return	function(target)
				return target:IsST() and (not f or f(target,table.unpack(ext_params)))
			end
end

--Flag Effects
function Card.HasFlagEffect(c,id,...)
	local flags={...}
	if id then
		table.insert(flags,id)
	end
	for _,flag in ipairs(flags) do
		if c:GetFlagEffect(flag)>0 then
			return true
		end
	end
	
	return false
end
function Card.HasFlagEffectHigher(c,id,val)
	return c:GetFlagEffect(id)>val
end

function Duel.PlayerHasFlagEffect(p,id,...)
	local flags={...}
	if id then
		table.insert(flags,id)
	end
	for _,flag in ipairs(flags) do
		if Duel.GetFlagEffect(p,flag)>0 then
			return true
		end
	end
	
	return false
end
function Card.UpdateFlagEffectLabel(c,id,ct)
	if not ct then ct=1 end
	return c:SetFlagEffectLabel(id,c:GetFlagEffectLabel(id)+ct)
end
function Duel.UpdateFlagEffectLabel(p,id,ct)
	if not ct then ct=1 end
	return Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+ct)
end
function Card.HasFlagEffectLabel(c,id,val)
	if not c:HasFlagEffect(id) then return false end
	for _,label in ipairs({c:GetFlagEffectLabel(id)}) do
		if label==val then
			return true
		end
	end
	return false
end
function Card.HasFlagEffectLabelLower(c,id,val)
	if not c:HasFlagEffect(id) then return false end
	for _,label in ipairs({c:GetFlagEffectLabel(id)}) do
		if label<val then
			return true
		end
	end
	return false
end
function Card.HasFlagEffectLabelHigher(c,id,val)
	if not c:HasFlagEffect(id) then return false end
	for _,label in ipairs({c:GetFlagEffectLabel(id)}) do
		if label>val then
			return true
		end
	end
	return false
end
function Duel.PlayerHasFlagEffectLabel(tp,id,val)
	if Duel.GetFlagEffect(tp,id)==0 then return false end
	for _,label in ipairs({Duel.GetFlagEffectLabel(tp,id)}) do
		if label==val then
			return true
		end
	end
	return false
end

function Auxiliary.FixNegativeLabel(n)
	if n<2147483648 then
		return n
	else
		return n-4294967296
	end
end

--Gain Effect
function Auxiliary.GainEffectType(c,oc,reset)
	if not oc then oc=c end
	if not reset then reset=0 end
	if not c:IsType(TYPE_EFFECT) then
		local e=Effect.CreateEffect(oc)
		e:SetType(EFFECT_TYPE_SINGLE)
		e:SetCode(EFFECT_ADD_TYPE)
		e:SetValue(TYPE_EFFECT)
		e:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
		c:RegisterEffect(e,true)
	end
end

--Groups
function Group.GetControlers(g)
	local p=PLAYER_NONE
	if #g==0 then return p end
	for i=0,1 do
		if g:IsExists(Card.IsControler,1,nil,i) then
			if p==PLAYER_NONE then
				p=i
			else
				p=PLAYER_ALL
			end
		end
	end
	return p
end

--Hint timing
function Effect.SetRelevantTimings(e,extra_timings)
	if not extra_timings then extra_timings=0 end
	return e:SetHintTiming(extra_timings,RELEVANT_TIMINGS|extra_timings)
end


--Labels
function Effect.SetLabelPair(e,l1,l2)
	if l1 and l2 then
		e:SetLabel(l1,l2)
	elseif l1 then
		local _,o2=e:GetLabel()
		e:SetLabel(l1,o2)
	else
		local o1,_=e:GetLabel()
		e:SetLabel(o1,l2)
	end
end
function Effect.GetSpecificLabel(e,pos)
	if not pos then pos=1 end
	local tab={e:GetLabel()}
	if #tab<pos then return end
	return tab[pos]
end

--Link Markers
function Card.IsCanActivateLinkMarker(c,markers,e,tp,r)
	if not markers then markers=LINK_MARKER_ALL end
	if not c:IsType(TYPE_LINK) then return false end
	local val=c:GetLinkMarker()&markers
	return val~=markers
end
function Card.IsCanDeactivateLinkMarker(c,markers,e,tp,r)
	if not markers then markers=LINK_MARKER_ALL end
	if not c:IsType(TYPE_LINK) then return false end
	local val=c:GetLinkMarker()&markers
	return val>0
end
function Card.ActivateLinkMarker(c,markers,e,tp,r,reset,rc)
	if not markers then
		local free=(~c:GetLinkMarker())&0xffff
		local SW={free&LINK_MARKER_BOTTOM_LEFT==LINK_MARKER_BOTTOM_LEFT,STRING_LINK_MARKER_BOTTOM_LEFT}
		local S={free&LINK_MARKER_BOTTOM==LINK_MARKER_BOTTOM,STRING_LINK_MARKER_BOTTOM}
		local SE={free&LINK_MARKER_BOTTOM_RIGHT==LINK_MARKER_BOTTOM_RIGHT,STRING_LINK_MARKER_BOTTOM_RIGHT}
		local W={free&LINK_MARKER_LEFT==LINK_MARKER_LEFT,STRING_LINK_MARKER_LEFT}
		local E={free&LINK_MARKER_RIGHT==LINK_MARKER_RIGHT,STRING_LINK_MARKER_RIGHT}
		local NW={free&LINK_MARKER_TOP_LEFT==LINK_MARKER_TOP_LEFT,STRING_LINK_MARKER_TOP_LEFT}
		local N={free&LINK_MARKER_TOP==LINK_MARKER_TOP,STRING_LINK_MARKER_TOP}
		local NE={free&LINK_MARKER_TOP_RIGHT==LINK_MARKER_TOP_RIGHT,STRING_LINK_MARKER_TOP_RIGHT}
		local opt=aux.Option(tp,false,false,SW,S,SE,W,E,NW,N,NE)
		if opt>=4 then
			opt=opt+1
		end
		markers=1<<opt
	else
		markers=(markers&(~(c:GetLinkMarker())))&0x1ef
	end
	if markers==0 then return false end
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
	e1:SetValue(markers)
	if reset then
		local rct=1
		if type(reset)=="table" then
			rct=reset[2]
			reset=reset[1]
		elseif type(reset)~="number" then
			reset=0
		end
		if c==rc then reset=reset|RESET_DISABLE end
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	c:RegisterEffect(e1)
end
function Card.DeactivateLinkMarker(c,markers,e,tp,r,reset,rc)
	if not markers then
		local free=c:GetLinkMarker()&0xffff
		local SW={free&LINK_MARKER_BOTTOM_LEFT==LINK_MARKER_BOTTOM_LEFT,STRING_LINK_MARKER_BOTTOM_LEFT}
		local S={free&LINK_MARKER_BOTTOM==LINK_MARKER_BOTTOM,STRING_LINK_MARKER_BOTTOM}
		local SE={free&LINK_MARKER_BOTTOM_RIGHT==LINK_MARKER_BOTTOM_RIGHT,STRING_LINK_MARKER_BOTTOM_RIGHT}
		local W={free&LINK_MARKER_LEFT==LINK_MARKER_LEFT,STRING_LINK_MARKER_LEFT}
		local E={free&LINK_MARKER_RIGHT==LINK_MARKER_RIGHT,STRING_LINK_MARKER_RIGHT}
		local NW={free&LINK_MARKER_TOP_LEFT==LINK_MARKER_TOP_LEFT,STRING_LINK_MARKER_TOP_LEFT}
		local N={free&LINK_MARKER_TOP==LINK_MARKER_TOP,STRING_LINK_MARKER_TOP}
		local NE={free&LINK_MARKER_TOP_RIGHT==LINK_MARKER_TOP_RIGHT,STRING_LINK_MARKER_TOP_RIGHT}
		local opt=aux.Option(tp,false,false,SW,S,SE,W,E,NW,N,NE)
		if opt>=4 then
			opt=opt+1
		end
		markers=1<<opt
	else
		markers=markers&c:GetLinkMarker()
	end
	if markers==0 then return false end
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMOVE_LINK_MARKER_KOISHI)
	e1:SetValue(markers)
	if reset then
		local rct=1
		if type(reset)=="table" then
			rct=reset[2]
			reset=reset[1]
		elseif type(reset)~="number" then
			reset=0
		end
		if c==rc then reset=reset|RESET_DISABLE end
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	c:RegisterEffect(e1)
end

--LP
function Duel.LoseLP(p,val)
	return Duel.SetLP(tp,Duel.GetLP(tp)-math.abs(val))
end

--Locations
function Card.IsBanished(c,pos)
	return c:IsLocation(LOCATION_REMOVED) and (not pos or c:IsPosition(pos))
end
function Card.IsInExtra(c,fu)
	return c:IsLocation(LOCATION_EXTRA) and (fu==nil or (fu==true or fu==POS_FACEUP) and c:IsFaceup() or (fu==false or fu==POS_FACEDOWN) and c:IsFacedown())
end
function Card.IsInGY(c)
	return c:IsLocation(LOCATION_GRAVE)
end
function Card.IsInMMZ(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function Card.IsInEMZ(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
end
function Card.IsInBackrow(c,pos)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 and (not pos or c:IsPosition(pos))
end
function Card.IsSequence(c,seq)
	return c:GetSequence()==seq
end
function Card.IsSequenceBelow(c,seq)
	return c:GetSequence()<=seq
end
function Card.IsSequenceAbove(c,seq)
	return c:GetSequence()>=seq
end
function Card.IsInMainSequence(c)
	return c:IsSequenceBelow(4)
end

function Card.IsSpellTrapOnField(c,typ)
	return not c:IsLocation(LOCATION_MZONE) or (c:IsFaceup() and c:IsST(typ))
end
function Card.NotOnFieldOrFaceup(c)
	return not c:IsOnField() or c:IsFaceup()
end
function Card.NotBanishedOrFaceup(c)
	return not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()
end
function Card.NotInExtraOrFaceup(c)
	return not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()
end

function Card.IsFusionSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function Card.IsRitualSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function Card.IsSynchroSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function Card.IsXyzSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function Card.IsPendulumSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function Card.IsLinkSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function Card.IsSelfSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL+1)
end

--Zones
function Duel.GetMZoneCountForMultipleSpSummon(p,exc)
	local ft=Duel.GetMZoneCount(p,exc)
	if Duel.IsPlayerAffectedByEffect(p,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return ft
end

function Card.GetZone(c,tp)
	local rzone
	if c:IsLocation(LOCATION_MZONE) then
		rzone = c:IsControler(tp) and (1 <<c:GetSequence()) or (1 << (16+c:GetSequence()))
		if c:IsSequence(5,6) then
			rzone = rzone | (c:IsControler(tp) and (1 << (16 + 11 - c:GetSequence())) or (1 << (11 - c:GetSequence())))
		end
	elseif c:IsLocation(LOCATION_SZONE) then
		rzone = c:IsControler(tp) and (1 << (8+c:GetSequence())) or (1 << (24+c:GetSequence()))
	end
	
	return rzone
end
function Card.GetPreviousZone(c,tp)
	local rzone
	if c:IsPreviousLocation(LOCATION_MZONE) then
		rzone = c:IsControler(tp) and (1 <<c:GetPreviousSequence()) or (1 << (16+c:GetPreviousSequence()))
		if c:GetPreviousSequence()==5 or c:GetPreviousSequence()==6 then
			rzone = rzone | (c:IsControler(tp) and (1 << (16 + 11 - c:GetPreviousSequence())) or (1 << (11 - c:GetPreviousSequence())))
		end
	
	elseif c:IsPreviousLocation(LOCATION_SZONE) then
		rzone = c:IsControler(tp) and (1 << (8+c:GetPreviousSequence())) or (1 << (24+c:GetPreviousSequence()))
	end
	return rzone
end

function Duel.GetColumnZoneFromSequence(seq,seqloc,loc)
	local zones=0
	if not seqloc then
		seqloc=LOCATION_ONFIELD
	else
		if seqloc&LOCATION_ONFIELD==0 or (seqloc==LOCATION_SZONE and seq>=5) then
			return 0
		end 
	end
	if not loc then
		loc=LOCATION_ONFIELD
	else
		if loc&LOCATION_ONFIELD==0 then
			return 0
		end
	end
	
	if seq<=4 then
		if loc&LOCATION_MZONE~=0 then
			if seqloc&LOCATION_MZONE==0 then
				zones = zones|(1<<seq)
			end
			zones = zones|(1<<(16+(4-seq)))
			if seq==1 then
				zones = zones|((1<<5)|(1<<(16+6)))
			end
			if seq==3 then
				zones = zones|((1<<6)|(1<<(16+5)))
			end
		end
		if loc&LOCATION_SZONE~=0 then
			if seqloc&LOCATION_SZONE==0 then
				zones = zones|(1<<seq+8)
			end
			zones = zones|(1<<(16+8+(4-seq)))
		end
	
	elseif seq==5 then
		if loc&LOCATION_MZONE~=0 then
			zones = zones|((1 << 1) | (1 << (16 + 3)))
		end
		if loc&LOCATION_SZONE~=0 then
			zones = zones|((1 << (8 + 1)) | (1 << (16 + 8 + 3)))
		end
	
	elseif seq==6 then
		if loc&LOCATION_MZONE~=0 then
			zones = zones|((1 << 3) | (1 << (16 + 1)))
		end
		if loc&LOCATION_SZONE~=0 then
			zones = zones|((1 << (8 + 3)) | (1 << (16 + 8 + 1)))
		end
	end
	
	--Debug.Message(zones)
	return zones
end
function Duel.GetColumnGroupFromSequence(tp,seq,seqloc)
	if seqloc&LOCATION_ONFIELD==0 then return end
	local column_mzone,column_szone = Duel.GetColumnZoneFromSequence(seq,seqloc,LOCATION_MZONE),Duel.GetColumnZoneFromSequence(seq,seqloc,LOCATION_SZONE)
	local g1=Duel.GetCardsInZone(column_mzone,tp,LOCATION_MZONE)
	local g2=Duel.GetCardsInZone(column_mzone>>16,1-tp,LOCATION_MZONE)
	local g3=Duel.GetCardsInZone(column_szone>>8,tp,LOCATION_SZONE)
	local g4=Duel.GetCardsInZone(column_szone>>24,1-tp,LOCATION_SZONE)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	return g1
end
function Duel.GetCardsInZone(zone,tp,loc)
	if loc&LOCATION_ONFIELD==0 then return end
	local g=Group.CreateGroup()
	local v = loc==LOCATION_MZONE and Duel.GetFieldGroup(tp,LOCATION_MZONE,0) or Duel.GetFieldGroup(tp,LOCATION_SZONE,0):Filter(Card.IsSequenceBelow,nil,4)
	for tc in aux.Next(v) do
		local icheck=1<<tc:GetSequence()
		if zone&icheck~=0 then
			g:AddCard(tc)
		end
	end
	return g
end

function Duel.CheckPendulumZones(tp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function Card.IsInLinkedZone(c,cc)
	return cc:GetLinkedGroup():IsContains(c)
end
function Card.WasInLinkedZone(c,cc)
	return cc:GetLinkedZone(c:GetPreviousControler())&c:GetPreviousZone()~=0
end
function Card.HasBeenInLinkedZone(c,cc)
	return cc:GetLinkedGroup():IsContains(c) or (not c:IsLocation(LOCATION_MZONE) and cc:GetLinkedZone(c:GetPreviousControler())&c:GetPreviousZone()~=0)
end

function Duel.GetMZoneCountFromLocation(tp,up,g,c)
	if c:IsInExtra() then
		return Duel.GetLocationCountFromEx(tp,up,g,c)
	else
		return Duel.GetMZoneCount(tp,g,up)
	end
end

--Location Groups
function Duel.GetHand(p)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	return g,#g
end
function Duel.GetHandCount(p)
	return Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
end
function Duel.GetDeck(p)
	return Duel.GetFieldGroup(p,LOCATION_DECK,0)
end
function Duel.GetDeckCount(p)
	return Duel.GetFieldGroupCount(p,LOCATION_DECK,0)
end
function Duel.GetGY(p)
	if not p then
		return Duel.GetFieldGroup(0,LOCATION_GRAVE,LOCATION_GRAVE)
	else
		return Duel.GetFieldGroup(p,LOCATION_GRAVE,0)
	end
end
function Duel.GetGYCount(p)
	if not p then
		return Duel.GetFieldGroupCount(0,LOCATION_GRAVE,LOCATION_GRAVE)
	else
		return Duel.GetFieldGroupCount(p,LOCATION_GRAVE,0)
	end
end
function Duel.GetBanishment(p)
	if not p then
		return Duel.GetFieldGroup(0,LOCATION_REMOVED,LOCATION_REMOVED)
	else
		return Duel.GetFieldGroup(p,LOCATION_REMOVED,0)
	end
end
function Duel.GetBanismentCount(p)
	if not p then
		return Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)
	else
		return Duel.GetFieldGroupCount(p,LOCATION_REMOVED,0)
	end
end
function Duel.GetExtraDeck(p)
	return Duel.GetFieldGroup(p,LOCATION_EXTRA,0)
end
function Duel.GetExtraDeckCount(p)
	return Duel.GetFieldGroupCount(p,LOCATION_EXTRA,0)
end
function Duel.GetPendulums(p,c)
	if c then
		return Duel.GetFieldGroup(p,LOCATION_PZONE,0):Filter(aux.TRUE,c):GetFirst()
	else
		return Duel.GetFieldGroup(p,LOCATION_PZONE,0)
	end
end
function Duel.GetPendulumsCount(p)
	return Duel.GetFieldGroupCount(p,LOCATION_PZONE,0)
end

--Materials
function Auxiliary.GetMustMaterialGroup(p,eff)
	return Duel.GetMustMaterial(p,eff)
end

function Auxiliary.CannotBeTributeOrMaterial(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
end

Auxiliary.CannotBeEDMatCodes = {}
table.insert(Auxiliary.CannotBeEDMatCodes,EFFECT_CANNOT_BE_FUSION_MATERIAL)
table.insert(Auxiliary.CannotBeEDMatCodes,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
table.insert(Auxiliary.CannotBeEDMatCodes,EFFECT_CANNOT_BE_XYZ_MATERIAL)
table.insert(Auxiliary.CannotBeEDMatCodes,EFFECT_CANNOT_BE_LINK_MATERIAL)
function Auxiliary.CannotBeEDMaterial(c,f,range,isrule,reset,owner,prop,allow_customs,forced)
	if not owner then owner=c end
	local property = type(prop)=="number" and prop or 0
	if (isrule == nil or isrule == true) then
		property = property|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE
	end
	if range ~=nil then
		property = property|EFFECT_FLAG_SINGLE_RANGE
	end
	local allow_customs = type(allow_customs)=="nil" or allow_customs
	for _,val in ipairs(Auxiliary.CannotBeEDMatCodes) do
		if allow_customs or val==EFFECT_CANNOT_BE_FUSION_MATERIAL or val==EFFECT_CANNOT_BE_SYNCHRO_MATERIAL or val==EFFECT_CANNOT_BE_XYZ_MATERIAL or val==EFFECT_CANNOT_BE_LINK_MATERIAL then
			local restrict = Effect.CreateEffect(owner)
			restrict:SetType(EFFECT_TYPE_SINGLE)
			restrict:SetCode(val)
			if (property ~= 0) then
				restrict:SetProperty(property)
			end
			if range~=nil then
				restrict:SetRange(range)
			end
			if f==nil then
				restrict:SetValue(1)
			else
				restrict:SetValue(Auxiliary.FilterToCannotValue(f))
			end
			if reset~=nil then
				local rct=1
				if type(reset)=="table" then
					rct=reset[2]
					reset=reset[1]
				end
				restrict:SetReset(reset,rct)
			end
			c:RegisterEffect(restrict,forced)
		end
	end
end
function Auxiliary.FilterToCannotValue(f)
	return function (e,c)
		if not c then return false end
		return not f(c)
	end
end

--Normal Summon/set
function Card.IsSummonableOrSettable(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function Duel.SummonOrSet(tp,tc,ignore_limit,min)
	if not ignore_limit then ignore_limit=true end
	if tc:IsSummonable(ignore_limit,min) and (not tc:IsMSetable(ignore_limit,min) or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK|POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
		Duel.Summon(tp,tc,ignore_limit,min)
	else
		Duel.MSet(tp,tc,ignore_limit,min)
	end
end

--Set Monster/Spell/Trap
function Card.IsCanBeSet(c,e,tp,ignore_mzone,ignore_szone)
	if c:IsMonster() then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not ignore_mzone or Duel.GetMZoneCount(tp)>0)
	elseif c:IsST() then
		return c:IsSSetable(ignore_szone)
	end
end
function Duel.Set(tp,g)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	local ct=0
	local mg=g:Filter(Card.IsMonster,nil)
	if #mg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		for tc in aux.Next(mg) do
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	local sg=g:Filter(Card.IsST,nil)
	if #sg>0 then
		for tc in aux.Next(sg) do
			if tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				ct=ct+Duel.SSet(tp,tc)
			end
		end
	end
	ct=ct+Duel.SpecialSummonComplete()
	return ct
end

--Once per turn
function Effect.OPT(e,ct)
	if not ct then ct=1 end
	if type(ct)=="boolean" then
		return e:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	else
		return e:SetCountLimit(ct)
	end
end

if not Auxiliary.HOPTTracker then
	Auxiliary.HOPTTracker={}
end
function Effect.HOPT(e,oath,ct)
	if not e:GetOwner() then return end
	if not ct then ct=1 end
	local c=e:GetOwner()
	local cid=c:GetOriginalCode()
	if not aux.HOPTTracker[c] then
		aux.HOPTTracker[c]=-1
	end
	aux.HOPTTracker[c]=aux.HOPTTracker[c]+1
	if type(aux.HOPTTracker[c])=="number" then
		cid=cid+aux.HOPTTracker[c]*100
	end
	local flag=0
	if oath then
		if type(oath)~="number" then oath=EFFECT_COUNT_CODE_OATH end
		flag=flag|oath
	end
	return e:SetCountLimit(ct,cid+flag)
end
function Effect.SHOPT(e,oath)
	if not e:GetOwner() then return end
	local c=e:GetOwner()
	local cid=c:GetOriginalCode()
	if not aux.HOPTTracker[c] then
		aux.HOPTTracker[c]=0
	end
	if type(aux.HOPTTracker[c])=="number" then
		cid=cid+aux.HOPTTracker[c]*100
	end
	
	local flag=0
	if oath then
		if type(oath)~="number" then oath=EFFECT_COUNT_CODE_OATH end
		flag=flag|oath
	end
	
	return e:SetCountLimit(1,cid+flag)
end

--OpInfo
function Duel.SetCardOperationInfo(g,cat)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	return Duel.SetOperationInfo(0,cat,g,#g,g:GetFirst():GetControler(),g:GetFirst():GetLocation())
end


--Phases
function Duel.IsDrawPhase(tp)
	return (not tp or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==PHASE_DRAW
end
function Duel.IsStandbyPhase(tp)
	return (not tp or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==PHASE_STANDBY
end
function Duel.IsMainPhase(tp,ct)
	return (not tp or Duel.GetTurnPlayer()==tp)
		and (not ct and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) or ct==1 and Duel.GetCurrentPhase()==PHASE_MAIN1 or ct==2 and Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function Duel.IsBattlePhase(tp)
	local ph=Duel.GetCurrentPhase()
	return (not tp or Duel.GetTurnPlayer()==tp) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function Duel.IsEndPhase(tp)
	return (not tp or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==PHASE_END
end

function Duel.GetNextPhaseCount(ph,p)
	if Duel.GetCurrentPhase()==ph and (not p or Duel.GetTurnPlayer()==tp) then
		return 2
	else
		return 1
	end
end

--PositionChange
function Duel.Flip(c,pos)
	if not c or (pos&POS_FACEUP==0 and pos&POS_FACEDOWN==0) then return 0 end
	if aux.GetValueType(c)=="Card" then
		if (pos&POS_FACEUP>0 and c:IsFaceup()) or (pos&POS_FACEDOWN>0 and c:IsFacedown()) then return 0 end
		local position = pos&POS_FACEUP>0 and c:GetPosition()>>1 or c:GetPosition()<<1
		return Duel.ChangePosition(c,position)
	else
		local ct=0
		for tc in aux.Next(c) do
			ct=ct+Duel.Flip(tc,pos)
		end
		return ct
	end
end
function Card.IsCanTurnSetGlitchy(c)
	if c:IsPosition(POS_FACEDOWN_DEFENSE) then return false end
	if not c:IsPosition(POS_FACEDOWN_ATTACK) then
		return c:IsCanTurnSet()
	else
		return not c:IsType(TYPE_LINK|TYPE_TOKEN) and not c:IsHasEffect(EFFECT_CANNOT_TURN_SET) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_TURN_SET)
	end
end

--Previous
function Card.IsPreviousCodeOnField(c,code,...)
	local codes={...}
	table.insert(codes,1,code)
	local precodes={c:GetPreviousCodeOnField()}
	for _,prename in ipairs(precodes) do
		for _,name in ipairs(codes) do
			if prename==name then
				return true
			end
		end
	end
	return false
end
function Card.IsPreviousTypeOnField(c,typ)
	return c:GetPreviousTypeOnField()&typ==typ
end
function Card.IsPreviousLevelOnField(c,lv)
	return c:GetPreviousLevelOnField()==lv
end
function Card.IsPreviousRankOnField(c,lv)
	return c:GetPreviousRankOnField()==lv
end
function Card.IsPreviousAttributeOnField(c,att)
	return c:GetPreviousAttributeOnField()&att==att
end
function Card.IsPreviousRaceOnField(c,rac)
	return c:GetPreviousRaceOnField()&rac==rac
end
function Card.IsPreviousAttackOnField(c,atk)
	return c:GetPreviousAttackOnField()==atk
end
function Card.IsPreviousDefenseOnField(c,def)
	return c:GetPreviousDefenseOnField()==def
end

--Check archetype at Activation
function Auxiliary.RegisterTriggeringArchetypeCheck(c,setc)
	local s=getmetatable(c)
	if not s.TriggeringSetcodeCheck then
		s.TriggeringSetcodeCheck=true
		s.TriggeringSetcode={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_CREATED)
		ge1:SetOperation(aux.UpdateTriggeringArchetypeCheck(s,setc))
		Duel.RegisterEffect(ge1,0)
		return ge1
	end
	return
end
function Auxiliary.UpdateTriggeringArchetypeCheck(s,setc)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
				local rc=re:GetHandler()
				if rc:IsSetCard(setc) then
					s.TriggeringSetcode[cid]=true
					return
				end
				s.TriggeringSetcode[cid]=false
			end
end

function Auxiliary.CheckArchetypeReasonEffect(s,re,setc)
	local rc=re:GetHandler()
	local ch=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(ch,CHAININFO_CHAIN_ID)
	if re:IsActivated() then
		if rc:IsRelateToChain(ch) then
			return rc:IsSetCard(setc)
		else
			return s.TriggeringSetcode[cid]
		end
	else
		return rc:IsSetCard(setc)
	end
end

--Owner
function Card.IsOwner(c,tp)
	return c:GetOwner()==tp
end

--Pendulum-related
function Card.IsCapableSendToExtra(c,tp)
	if not c:IsMonster(TYPE_EXTRA|TYPE_PENDULUM) or c:IsHasEffect(EFFECT_CANNOT_TO_DECK) or not Duel.IsPlayerCanSendtoDeck(tp,c) then return false end
	return true
end
function Card.IsAbleToExtraFaceupAsCost(c,p,tp)
	local redirect=0
	local dest=LOCATION_DECK
	if not c:IsMonster(TYPE_PENDULUM) or c:IsLocation(LOCATION_EXTRA) or (tp and c:GetOwner()~=tp)
		or c:IsHasEffect(EFFECT_CANNOT_USE_AS_COST) or not c:IsCapableSendToExtra(p) then 
		return false
	end
	if c:IsOnField() then
		redirect=c:LeaveFieldRedirect(REASON_COST)&0xffff
	end
	if redirect~=0 then
		dest=redirect
	end
	redirect = c:DestinationRedirect(dest,REASON_COST)&0xffff
	if redirect~=0 then
		dest=redirect
	end
	return dest==LOCATION_DECK
end

--redirect
function Card.GetDestinationReset(c)
	if c:IsOriginalType(TYPE_TOKEN) then return 0 end
	local dest=c:GetDestination()
	local options={
		[LOCATION_HAND]=RESET_TOHAND;
		[LOCATION_DECK]=RESET_TODECK;
		[LOCATION_EXTRA]=RESET_TODECK;
		[LOCATION_GRAVE]=RESET_TOGRAVE;
		[LOCATION_REMOVED]=RESET_REMOVE|RESET_TEMP_REMOVE;
		[LOCATION_ONFIELD]=RESET_TOFIELD;
		[LOCATION_OVERLAY]=RESET_OVERLAY;
	}
	
	for loc,eloc in pairs(options) do
		if dest&loc>0 then
			return eloc
		end
	end
	
	return 0
end
function Card.DestinationRedirect(c,dest,r)
	local eset
	if c:IsOriginalType(TYPE_TOKEN) then return 0 end
	local options={
		[LOCATION_HAND]=EFFECT_TO_HAND_REDIRECT;
		[LOCATION_DECK]=EFFECT_TO_DECK_REDIRECT;
		[LOCATION_GRAVE]=EFFECT_TO_GRAVE_REDIRECT;
		[LOCATION_REMOVED]=EFFECT_REMOVE_REDIRECT
	}
	for loc,eloc in pairs(options) do
		if dest==loc then
			eset={c:IsHasEffect(eloc)}
			break
		end
	end
	if not eset then return 0 end
	for _,e in ipairs(eset) do
		local p=e:GetHandlerPlayer()
		local val=e:Evaluate(c)
		if val&LOCATION_HAND>0 and not c:IsHasEffect(EFFECT_CANNOT_TO_HAND) and Duel.IsPlayerCanSendtoHand(p,c) then
			return LOCATION_HAND
		end
		if val&LOCATION_DECK>0 and not c:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(p,c) then
			return LOCATION_DECK
		end
		if val&LOCATION_REMOVED>0 and not c:IsHasEffect(EFFECT_CANNOT_REMOVE) and Duel.IsPlayerCanRemove(p,c,r) then
			return LOCATION_REMOVED
		end
		if val&LOCATION_GRAVE>0 and not c:IsHasEffect(EFFECT_CANNOT_TO_GRAVE) and Duel.IsPlayerCanSendtoGrave(p,c) then
			return LOCATION_GRAVE
		end
	end
	
	return 0
end
function Card.LeaveFieldRedirect(c,r)
	local redirects=0
	if c:IsOriginalType(TYPE_TOKEN) then return 0 end
	local eset={c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT)}
	for _,e in ipairs(eset) do
		local p=e:GetHandlerPlayer()
		local val=e:Evaluate(c)
		if val&LOCATION_HAND>0 and not c:IsHasEffect(EFFECT_CANNOT_TO_HAND) and Duel.IsPlayerCanSendtoHand(p,c) then
			redirects = redirects|LOCATION_HAND
		end
		if val&LOCATION_DECK>0 and not c:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(p,c) then
			redirects = redirects|LOCATION_DECK
		end
		if val&LOCATION_REMOVED>0 and not c:IsHasEffect(EFFECT_CANNOT_REMOVE) and Duel.IsPlayerCanRemove(p,c,r) then
			redirects = redirects|LOCATION_REMOVED
		end
	end
	if redirects&LOCATION_REMOVED>0 then return LOCATION_REMOVED end
	if redirects&LOCATION_DECK>0 then
		if redirects&LOCATION_DECKBOT==LOCATION_DECKBOT then
			return LOCATION_DECKBOT
		end
		if redirects&LOCATION_DECKSHF==LOCATION_DECKSHF then
			return LOCATION_DECKSHF
		end
		return LOCATION_DECK
	end
	if redirects&LOCATION_HAND>0 then return LOCATION_HAND end
	return 0
end

--Relation
local _IsRelateToChain = Card.IsRelateToChain

Card.IsRelateToChain = function(c,...)
	if aux.ConvertChainToEffectRelation then
		if not ... then
			local re=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
			return c:IsRelateToEffect(re)
			
		else
			local x={...}
			local ev=x[1]
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			return c:IsRelateToEffect(re)
		end
	else
		return _IsRelateToChain(c,...)
	end
end

function Auxiliary.RelationTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():CreateEffectRelation(e)
end

--Remain on field
function Auxiliary.RemainOnFieldCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(aux.RemainOnFieldCostFunction)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function Auxiliary.RemainOnFieldCostFunction(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end

--Set Backrow
function Auxiliary.SetSuccessfullyFilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE)
end
function Duel.SSetAndFastActivation(p,g,e)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if Duel.SSet(p,g)>0 then
		local c=e:GetHandler()
		local og=g:Filter(aux.SetSuccessfullyFilter,nil)
		for tc in aux.Next(og) do
			local code = tc:IsTrap() and EFFECT_TRAP_ACT_IN_SET_TURN or EFFECT_QP_ACT_IN_SET_TURN
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(STRING_FAST_ACTIVATION)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(code)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

--Special Summon Procedures and After Effect Resolution
function Auxiliary.ApplyEffectImmediatelyAfterChainResolution(f,c,e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabelObject(e)
	e1:SetOperation(function(_e,_tp,_eg,_ep,_ev,_re,_r,_rp)
		f(e,tp,eg,ep,ev,re,r,rp,_e)
		_e:Reset()
	end
	)
	e1:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e1,tp)
	return e1
end

--Summoning Conditions
function Auxiliary.MustBeSpecialSummoned(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	return e1
end

--Update stats
function Card.UpdateATK(c,atk,reset,rc,range,cond,prop,desc)
	local typ = (SCRIPT_AS_EQUIP==true) and EFFECT_TYPE_EQUIP or EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	
	if not prop then prop=0 end
	
	local att=c:GetAttack()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range and not SCRIPT_AS_EQUIP then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_UPDATE_ATTACK)
	e:SetValue(atk)
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	
	if reset then
		return e,c:GetAttack()-att
	else
		return e
	end
end
function Card.UpdateDEF(c,def,reset,rc,range,cond,prop,desc)
	local typ = (SCRIPT_AS_EQUIP==true) and EFFECT_TYPE_EQUIP or EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	local rc = rc and rc or c
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	if not prop then prop=0 end
	
	local df=c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	if range and not SCRIPT_AS_EQUIP then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	e:SetCode(EFFECT_UPDATE_DEFENSE)
	e:SetValue(def)
	if cond then
		e:SetCondition(cond)
	end
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	if reset then
		return e,c:GetDefense()-df
	else
		return e
	end
end
function Card.UpdateATKDEF(c,atk,def,reset,rc,range,cond,prop,desc)
	local typ = (SCRIPT_AS_EQUIP==true) and EFFECT_TYPE_EQUIP or EFFECT_TYPE_SINGLE
	if not reset and not range then
		range = c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE
	end
	
	local donotdisable=false
    local rct=1
    if type(reset)=="table" then
        rct=reset[2]
        reset=reset[1]
    end
	
	if type(rc)=="table" then
        donotdisable=rc[2]
        rc=rc[1]
    end
	local rc = rc and rc or c
	
	if not atk then
		atk=def
	elseif not def then
		def=atk
	end
	
	if not prop then prop=0 end
	
	local oatk,odef=c:GetAttack(),c:GetDefense()
	local e=Effect.CreateEffect(rc)
	e:SetType(typ)
	
	if range and not SCRIPT_AS_EQUIP then
		prop=prop|EFFECT_FLAG_SINGLE_RANGE
		e:SetRange(range)
	end
	
	e:SetCode(EFFECT_UPDATE_ATTACK)
	e:SetValue(atk)
	
	if cond then
		e:SetCondition(cond)
	end
	
	if reset then
		if type(reset)~="number" then reset=0 end
		if rc==c and not donotdisable then
			reset = reset|RESET_DISABLE
		else
			prop=prop|EFFECT_FLAG_CANNOT_DISABLE
		end
		e:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
	end
	
	if prop~=0 then
		e:SetProperty(prop)
	end
	
	c:RegisterEffect(e)
	
	local e1x=e:Clone()
	e1x:SetCode(EFFECT_UPDATE_DEFENSE)
	e1x:SetValue(def)
	
	c:RegisterEffect(e1x)
	
	if not reset then
		return e,e1x
	else
		return e,e1x,c:GetAttack()-oatk,c:GetDefense()-odef
	end
end

--Location Check
EFFECT_CARD_HAS_RESOLVED = 47987298

function Auxiliary.AlreadyInRangeFilter(e,f,se)
	local se=e and e:GetLabelObject():GetLabelObject() or se
	return	function(c,...)
				return (se==nil or c:GetReasonEffect()~=se) and (not f or f(c,...))
			end
end

function Auxiliary.AddThisCardBanishedAlreadyCheck(c,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInBackrowAlreadyCheck(c,pos,setf,getf)
	if pos==POS_FACEDOWN then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SSET)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(function(e) return (not e:GetHandler():IsPreviousLocation(LOCATION_SZONE) or e:GetHandler():GetPreviousSequence()<5) and e:GetHandler():IsInBackrow(pos) end)
		e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
		Duel.RegisterEffect(e1,0)
		return e1
	end
end
function Auxiliary.AddThisCardInExtraAlreadyCheck(c,pos,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return e:GetHandler():IsInExtra(pos) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInFZoneAlreadyCheck(c,setf,getf)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_FZONE)
	e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_FZONE) and e:GetHandler():IsLocation(LOCATION_FZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInMZoneAlreadyCheck(c,setf,getf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetHandler():IsLocation(LOCATION_MZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInSZoneAlreadyCheck(c,setf,getf)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e)
		local h=e:GetHandler()
		return (not h:IsPreviousLocation(LOCATION_SZONE) or c:GetPreviousSequence()>=5) and h:IsLocation(LOCATION_SZONE) and h:GetSequence()<5
	end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,true))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AddThisCardInPZoneAlreadyCheck(c,pos,setf,getf)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CARD_HAS_RESOLVED)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(function(e) return not e:GetHandler():IsPreviousLocation(LOCATION_PZONE) and e:GetHandler():IsLocation(LOCATION_PZONE) end)
	e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf))
	c:RegisterEffect(e1)
	return e1
end
function Effect.SetLabelObjectObject(e,obj)
	return e:GetLabelObject():SetLabelObject(obj)
end
function Effect.GetLabelObjectObject(e)
	return e:GetLabelObject():GetLabelObject()
end
function Auxiliary.ThisCardInLocationAlreadyCheckReg(setf,getf,ignore_reason)
	if not setf then setf=Effect.SetLabelObject end
	if not getf then getf=Effect.GetLabelObject end
	return	function(e,tp,eg,ep,ev,re,r,rp)
				--condition of continous effect will be checked before other effects
				--Debug.Message("RE: "..tostring(re))
				--Debug.Message("GETF: "..tostring(getf(e)))
				if re==nil then return false end
				if getf(e)~=nil then return false end
				--Debug.Message("r: "..tostring(r))
				if (r&REASON_EFFECT)>0 or ignore_reason then
					setf(e,re)
					--e:SetLabelObject(re)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CHAIN_END)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset1(getf))
					e1:SetLabelObject(e)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_BREAK_EFFECT)
					e2:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset2(getf))
					e2:SetReset(RESET_CHAIN)
					e2:SetLabelObject(e1)
					Duel.RegisterEffect(e2,tp)
				elseif (r&REASON_MATERIAL)>0 or not re:IsActivated() and (r&REASON_COST)>0 then
					setf(e,re)
					--e:SetLabelObject(re)
					local reset_event=EVENT_SPSUMMON
					if re:GetCode()~=EFFECT_SPSUMMON_PROC then reset_event=EVENT_SUMMON end
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(reset_event)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetOperation(Auxiliary.ThisCardInLocationAlreadyReset1(getf))
					e1:SetLabelObject(e)
					Duel.RegisterEffect(e1,tp)
				end
			
				return false
			end
end
function Auxiliary.ThisCardInLocationAlreadyReset1(getf)
	return	function(e)
				--this will run after EVENT_SPSUMMON_SUCCESS
				getf(e):SetLabelObject(nil)
				e:Reset()
			end
end
function Auxiliary.ThisCardInLocationAlreadyReset2(getf)
	return	function(e)
				local e1=e:GetLabelObject()
				getf(e1):SetLabelObject(nil)
				e1:Reset()
				e:Reset()
			end
end

--Glitchylib_cond imports
--Turn/Phase Conditions
function Auxiliary.DrawPhaseCond(tp)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsDrawPhase(tp)
			end
end
function Auxiliary.StandbyPhaseCond(tp)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsStandbyPhase(tp)
			end
end
function Auxiliary.MainPhaseCond(tp,ct)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsMainPhase(tp,ct)
			end
end
function Auxiliary.BattlePhaseCond(tp)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsBattlePhase(tp)
			end
end
function Auxiliary.MainOrBattlePhaseCond(tp,ct)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsMainPhase(tp,ct) or Duel.IsBattlePhase(tp)
			end
end
function Auxiliary.EndPhaseCond(tp)
	return	function(e,p)
				local tp = (tp==0) and p or (tp==1) and 1-p or nil
				return Duel.IsEndPhase(tp)
			end
end
function Auxiliary.ExceptOnDamageStep()
	return Auxiliary.ExceptOnDamageCalc()
end
function Auxiliary.ExceptOnDamageCalc()
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function Auxiliary.TurnPlayerCond(tp)
	return	function(e,p)
				if not p then p=e:GetHandlerPlayer() end
				local tp = (not tp or tp==0) and p or 1-p
				return Duel.GetTurnPlayer()==tp
			end
end

--When this card is X Summoned
function Auxiliary.RitualSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function Auxiliary.FusionSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function Auxiliary.SynchroSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function Auxiliary.XyzSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function Auxiliary.PendulumSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function Auxiliary.LinkSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function Auxiliary.ProcSummonedCond(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF)
end

--Glitchylib_cost imports
function Auxiliary.DummyCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function Auxiliary.LabelCost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end

----Self as Cost
function Auxiliary.BanishFacedownSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function Auxiliary.DiscardSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function Auxiliary.DetachSelfCost(min,max)
	if not min then min=1 end
	if not max or max<min then max=min end
	
	if min==max then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,min,REASON_COST) end
					e:GetHandler():RemoveOverlayCard(tp,min,min,REASON_COST)
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						for i=min,max do
							if c:CheckRemoveOverlayCard(tp,i,REASON_COST) then
								return true
							end
						end
						return false
					end
					local list={}
					for i=min,max do
						if c:CheckRemoveOverlayCard(tp,i,REASON_COST) then
							table.insert(list,i)
						end
					end
					if #list==0 then return end
					if #list==max-min then
						c:RemoveOverlayCard(tp,min,max,REASON_COST)
					else
						local ct=Duel.AnnounceNumber(tp,table.unpack(list))
						c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
					end
				end
	end
end
function Auxiliary.RevealSelfCost(reset,rct)
	if not rct then rct=1 end
	
	if not reset then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return not c:IsPublic() end
				Duel.ConfirmCards(1-tp,c)
			end
	else
		if not rct then rct=1 end
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return not c:IsPublic() end
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
					c:RegisterEffect(e1)
				end
	end
end
function Auxiliary.RemoveCounterSelfCost(ctype,min,max)
	if not min then min=1 end
	if not max or max<min then max=min end
	
	if min==max then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return c:IsCanRemoveCounter(tp,ctype,min,REASON_COST) end
					c:RemoveCounter(tp,ctype,min,REASON_COST)
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						for i=min,max do
							if c:IsCanRemoveCounter(tp,ctype,i,REASON_COST) then
								return true
							end
						end
						return false
					end
					local list={}
					for i=min,max do
						if c:IsCanRemoveCounter(tp,ctype,i,REASON_COST) then
							table.insert(list,i)
						end
					end
					if #list==0 then return end
					local ct=Duel.AnnounceNumber(tp,table.unpack(list))
					c:RemoveCounter(tp,ctype,ct,REASON_COST)
				end
	end
end
function Auxiliary.ToDeckSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function Auxiliary.ToExtraSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function Auxiliary.ToGraveSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function Auxiliary.TributeSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

--Other Imports
function Card.HasLevel(c,general)
	if c:IsType(TYPE_MONSTER) then
		return ((c:GetType()&TYPE_LINK~=TYPE_LINK and c:GetType()&TYPE_XYZ~=TYPE_XYZ)) and not c:IsStatus(STATUS_NO_LEVEL)
	elseif general and c:IsOriginalType(TYPE_MONSTER) then
		return not (c:IsOriginalType(TYPE_XYZ+TYPE_LINK) or c:IsStatus(STATUS_NO_LEVEL))
	end
	return false
end

function Duel.IgnoreActionCheck(f,...)
	Duel.DisableActionCheck(true)
	local cr=coroutine.create(f)
	local ret={}
	while coroutine.status(cr)~="dead" do
		local sret={coroutine.resume(cr,...)}
		for i=2,#sret do
			table.insert(ret,sret[i])
		end
	end
	Duel.DisableActionCheck(false)
	return table.unpack(ret)
end

--MERGED EVENT GROUP HANDLER

local _rmde = Auxiliary.RegisterMergedDelayedEvent

Auxiliary.RegisterMergedDelayedEvent = function(c,code,event,g)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	return _rmde(c,code,event,g)
end

EVENT_COUNTER_ID = 0
aux.EventCounter = {}
EVENT_ID = 0
MERGED_ID = 1
aux.MustUpdateEventID = {}
aux.MergedDelayedEventInfotable = {}

--[[Raises custom event with a compound Event Group containing all cards that raised the specified event at different times during a Chain.
Handles correct interactions with Trigger Effects whose resolution depends on the specific card that raised the event (eg. Union Hangar)
c 								= The card that needs to check for the event
code 							= The code of the custom event that will be raised. A progressive ID might be needed in some cases, for example when check_if_already_in_location is set (see
								Dismay from the Dark)
event							= The event that must be checked. You can specify multiple events by passing a table
f								= Filter for the cards that are involved in the "event(s)"
flag							= Specify the id for the flag effect that is used internally by this function
range							= If specified, these checks will only be performed while "c" is in the "range". Otherwise, the checks are always performed during the Duel
								 (the latter case applies for private-location Trigger Effects)
evgcheck						= You can specify an additional check for the compound Event Group before raising the custom event. If this check is not passed, the custom event is not raised.
check_if_already_in_location	= If a location is specified, the respective AddThisCardInLocationAlreadyCheck will be performed
operation						= You can invoke a function before raising the custom event. The function must return the Event Value of the custom event.
simult_check					= You can specify an id for an additional flag that separately keeps track of cards that were simultaneously involved in an instance of the specified event.
forced							= Raises the custom event even if the final group is empty (required for mandatory Trigger Effects)
customevgop						= Allows to call a custom function when the cards involved in the local Event Groups are receiving the flag
								(useful for effects that must keep track of certain properties the cards had in a previous location, see BRAIN Boot Sector)
]]
function Auxiliary.RegisterMergedDelayedEventGlitchy(c,code,event,f,flag,range,evgcheck,check_if_already_in_location,operation,simult_check,forced,customevgop)
	if type(event)~="table" then event={event} end
	if not f then f=aux.TRUE end
	if not flag then flag=c:GetOriginalCode() end
	local se
	if check_if_already_in_location then
		if check_if_already_in_location&LOCATION_GRAVE>0 then
			se=aux.AddThisCardInGraveAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_FZONE>0 then
			se=aux.AddThisCardInFZoneAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_MZONE>0 then
			se=aux.AddThisCardInMZoneAlreadyCheck(c)
		elseif check_if_already_in_location&LOCATION_SZONE>0 then
			se=aux.AddThisCardInSZoneAlreadyCheck(c)
		end
	end
	
	local g=Group.CreateGroup()
	g:KeepAlive()
	
	if forced then
		EVENT_COUNTER_ID = EVENT_COUNTER_ID + 1
		aux.EventCounter[EVENT_COUNTER_ID]=0
	end
		
	if range then
		
		local ge1
		for _,ev in ipairs(event) do
			ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(ev)
			ge1:SetRange(range)
			ge1:SetLabel(code)
			ge1:SetLabelObject(g)
			ge1:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy1(ev,flag,f,range,evgcheck,se,operation,simult_check,forced,customevgop,EVENT_COUNTER_ID))
			Duel.RegisterEffect(ge1,0)
		end
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy2(flag,range,evgcheck,se,operation,forced,EVENT_COUNTER_ID))
		Duel.RegisterEffect(ge2,0)
		if simult_check then
			aux.MustUpdateEventID[c]=false
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge3:SetCode(EVENT_BREAK_EFFECT)
			ge3:SetOperation(aux.SignalEventIDUpdate)
			Duel.RegisterEffect(ge3,0)
			local ge4=ge3:Clone()
			ge4:SetCode(EVENT_CHAIN_SOLVED)
			Duel.RegisterEffect(ge4,0)
			local ge5=ge3:Clone()
			ge5:SetCode(EVENT_CHAINING)
			Duel.RegisterEffect(ge5,0)
		end
	else
		local mt=getmetatable(c)
		local ge1
		for _,ev in ipairs(event) do
			if mt[ev]~=true then
				mt[ev]=true
				ge1=Effect.CreateEffect(c)
				ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(ev)
				ge1:SetLabel(code)
				ge1:SetLabelObject(g)
				ge1:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy1(ev,flag,f,nil,evgcheck,se,operation,simult_check,forced,customevgop,EVENT_COUNTER_ID))
				Duel.RegisterEffect(ge1,0)
			end
		end
		if ge1 then
			local ge2=ge1:Clone()
			ge2:SetCode(EVENT_CHAIN_END)
			ge2:SetOperation(Auxiliary.MergedDelayEventCheckGlitchy2(flag,nil,evgcheck,se,operation,forced,EVENT_COUNTER_ID))
			Duel.RegisterEffect(ge2,0)
		end
		if simult_check then
			aux.MustUpdateEventID[c]=false
			local ge3=Effect.CreateEffect(c)
			ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			ge3:SetCode(EVENT_BREAK_EFFECT)
			ge3:SetOperation(aux.SignalEventIDUpdate)
			Duel.RegisterEffect(ge3,0)
			local ge4=ge3:Clone()
			ge4:SetCode(EVENT_CHAIN_SOLVED)
			Duel.RegisterEffect(ge4,0)
			local ge5=ge3:Clone()
			ge5:SetCode(EVENT_CHAINING)
			Duel.RegisterEffect(ge5,0)
		end
	end
end
function Auxiliary.SignalEventIDUpdate(e,tp,eg,ep,ev,re,r,rp)
	aux.MustUpdateEventID[e:GetOwner()] = true
end
function Auxiliary.MergedDelayEventCheckGlitchy1(event,id,f,range,evgcheck,se,operation,simult_check,forced,customevgop,eid)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetOwner()
				local tp=c:GetControler()
				
				if range then
					if not c:IsLocation(range) then
						return
					end
					if c:IsLocation(LOCATION_SZONE) and not c:IsHasEffect(EFFECT_CARD_HAS_RESOLVED) then
						return
					end
				end
				local label = (range) and c:GetFieldID() or 0
				local g=e:GetLabelObject()
				if aux.GetValueType(g)~="Group" then return end
				local obj = aux.GetValueType(se)=="Effect" and se:GetLabelObject() or nil
				local evg=eg:Filter(f,nil,e,tp,eg,ep,ev,re,r,rp,obj,event)
				--Debug.Message(#evg)
				local flagID=id
				if type(id)=="function" then
					flagID=id(event)
				end
				
				for tc in aux.Next(evg) do
					tc:RegisterFlagEffect(flagID,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_SET_AVAILABLE,1,label)
					if simult_check then
						tc:RegisterFlagEffect(simult_check,RESET_PHASE+PHASE_END,EFFECT_FLAG_SET_AVAILABLE,1,EVENT_ID)
					end
					if customevgop then
						customevgop(tc,e,tp,eg,ep,ev,re,r,rp,evg)
					end
				end
				if aux.MustUpdateEventID[c]==true then
					if forced and type(aux.EventCounter[eid])=="number" and #evg>0 then
						aux.EventCounter[eid] = aux.EventCounter[eid] + 1
					end
					EVENT_ID = EVENT_ID + 1
					aux.MustUpdateEventID[c]=false
				end
				
				g:Merge(evg)
				--Debug.Message('gsize '..tostring(#g))
				if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_SOLVED) and not Duel.CheckEvent(EVENT_CHAIN_END) then
					--Debug.Message('nochain')
					local flags	
					if type(id)=="function" then
						flags={id()}
					else
						flags={id}
					end
					local G=Group.CreateGroup()
					for _,cid in ipairs(flags) do
						local _eg=g:Clone()
						_eg=_eg:Filter(Card.HasFlagEffectLabel,nil,cid,label)
						--Debug.Message("NOCHAIN_FILTERED_COUNT "..tostring(cid)..": "..tostring(#_eg))
						G:Merge(_eg)
					end
					if g and #g>0 and (#G>0 or forced) then
						if not evgcheck or evgcheck(G,e,tp,ep,ev,re,r,rp) then
							--Debug.Message('a')
							local customev=ev
							if operation then
								customev=operation(e,tp,G,ep,ev,re,r,rp,obj,event)
							end
							local counter=(type(aux.EventCounter[eid])=="number" and aux.EventCounter[eid]>0) and aux.EventCounter[eid] or 1
							for i=1,counter do
								Duel.RaiseEvent(G,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,customev)
							end
						end
						for tc in aux.Next(G) do
							for _,cid in ipairs(flags) do
								tc:ResetFlagEffect(cid)
							end
						end
						MERGED_ID = MERGED_ID + 1
					end
					if type(aux.EventCounter[eid])=="number" then
						aux.EventCounter[eid]=0
					end
					g:Clear()
				end
			end
end
function Auxiliary.MergedDelayEventCheckGlitchy2(id,range,evgcheck,se,operation,forced,eid)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetOwner()
				local tp=c:GetControler()
				if range then					
					if not c:IsLocation(range) then
						return
					end
					if c:IsLocation(LOCATION_SZONE) and not c:IsHasEffect(EFFECT_CARD_HAS_RESOLVED) then
						return
					end
				end
				local label = (range) and c:GetFieldID() or 0
				local g=e:GetLabelObject()
				if aux.GetValueType(g)~="Group" then return end
				--Debug.Message('test '..tostring(#g))
				if #g>0 then
					local flags
					if type(id)=="function" then
						flags={id()}
					else
						flags={id}
					end
					local G=Group.CreateGroup()
					for _,cid in ipairs(flags) do
						local _eg=g:Clone()
						--Debug.Message("FLAG: "..tostring(cid))
						_eg=_eg:Filter(Card.HasFlagEffectLabel,nil,cid,label)
						--Debug.Message("FILTERED GROUP COUNT: "..tostring(#_eg))
						G:Merge(_eg)
					end
				    if g and #g>0 and (#G>0 or forced) then
						--Debug.Message('b')
						if not evgcheck or evgcheck(G,e,tp,ep,ev,re,r,rp) then
							local customev=ev
							if operation then
								local obj = aux.GetValueType(se)=="Effect" and se:GetLabelObject() or nil
								customev=operation(e,tp,G,ep,ev,re,r,rp,obj)
							end
							local counter=(type(aux.EventCounter[eid])=="number" and aux.EventCounter[eid]>0) and aux.EventCounter[eid] or 1
							for i=1,counter do
								--Debug.Message(i)
								Duel.RaiseEvent(G,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,customev)
							end
						end
						for tc in aux.Next(G) do
							for _,cid in ipairs(flags) do
								--Debug.Message("RESETTED: "..tostring(cid))
								tc:ResetFlagEffect(cid)
							end
						end
						MERGED_ID = MERGED_ID + 1
					end
					if type(aux.EventCounter[eid])=="number" then
						aux.EventCounter[eid]=0
					end
					g:Clear()
				end
			end
end

function Auxiliary.SimultaneousEventGroupCheck(g,simult_check,og)
	local sg=g:Filter(Card.HasFlagEffect,nil,simult_check)
	if #sg~=#g or sg:GetClassCount(Card.GetFlagEffectLabel,simult_check)>1 then return false end
	local val=sg:GetFirst():GetFlagEffectLabel(simult_check)
	if g:FilterCount(Card.HasFlagEffectLabel,nil,simult_check,val)~=og:FilterCount(Card.HasFlagEffectLabel,nil,simult_check,val) then
		return false
	end
	return true
end

---------------------------------------------------------------------------------
-------------------------------CONTACT FUSION---------------------------------
function Auxiliary.AddContactFusionProcedureGlitchy(c,desc,rule,sumtype,filter,self_location,opponent_location,mat_operation,...)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	local self_location=self_location or 0
	local opponent_location=opponent_location or 0
	
	local condition
	if type(mat_operation)=="table" then
		condition=mat_operation[1]
		mat_operation=mat_operation[#mat_operation]
	end
	
	local operation_params={...}
	
	local prop=EFFECT_FLAG_UNCOPYABLE
	if rule then
		prop=prop|EFFECT_FLAG_CANNOT_DISABLE
	end
	local e2=Effect.CreateEffect(c)
	e2:Desc(desc)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(prop)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.ContactFusionConditionGlitchy(filter,self_location,opponent_location,sumtype,condition))
	e2:SetOperation(Auxiliary.ContactFusionOperationGlitchy(filter,self_location,opponent_location,sumtype,mat_operation,operation_params))
	e2:SetValue(sumtype)
	c:RegisterEffect(e2)
	return e2
end
function Auxiliary.ContactFusionMaterialFilterGlitchy(c,fc,filter,sumtype)
	return c:IsCanBeFusionMaterial(fc,sumtype) and (not filter or filter(c,fc))
end
function Auxiliary.ContactFusionConditionGlitchy(filter,self_location,opponent_location,sumtype,condition)
	local chkfnf = sumtype==SUMMON_TYPE_FUSION and 0 or 0x200
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilterGlitchy,tp,self_location,opponent_location,c,c,filter,sumtype)
				return (sumtype==0 or c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false)) and c:CheckFusionMaterial(mg,nil,tp|chkfnf)
					and (not condition or condition(e,c,tp,mg))
			end
end
function Auxiliary.ContactFusionOperationGlitchy(filter,self_location,opponent_location,sumtype,mat_operation,operation_params)
	local chkfnf = sumtype==SUMMON_TYPE_FUSION and 0 or 0x200
	if type(mat_operation)=="function" then
		return	function(e,tp,eg,ep,ev,re,r,rp,c)
					local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilterGlitchy,tp,self_location,opponent_location,c,c,filter,sumtype)
					local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|chkfnf)
					c:SetMaterial(g)
					mat_operation(g,table.unpack(operation_params))
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,c)
					local mg=Duel.GetMatchingGroup(Auxiliary.ContactFusionMaterialFilterGlitchy,tp,self_location,opponent_location,c,c,filter,sumtype)
					local g=Duel.SelectFusionMaterial(tp,c,mg,nil,tp|chkfnf)
					c:SetMaterial(g)
					operation_params[1](g,e,tp,eg,ep,ev,re,r,rp,c)
				end
	end
end

function Auxiliary.ContactFusionMaterialsToDeck(g,_,tp)
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

--EFFECT TABLES
--Global Card Effect Table
if not global_card_effect_table_global_check then
	global_card_effect_table_global_check=true
	global_card_effect_table={}
	Card.register_global_card_effect_table = Card.RegisterEffect
	function Card:RegisterEffect(e,forced)
		if not global_card_effect_table[self] then global_card_effect_table[self]={} end
		table.insert(global_card_effect_table[self],e)
		
		local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
		if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then	
			local newcon =	function(...)
								self_reference_effect=e
								local x={...}
								if type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return condition(...)
							end
			e:SetCondition(newcon)
		end
		if cost and not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
			local newcost =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return cost(...)
							end
			e:SetCost(newcost)
		end
		if tg then
			if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			end
		end
		if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
			local newop =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return op(...)
							end
			e:SetOperation(newop)
		end
		if val then
			if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
				local newval =	function(...)
									self_reference_effect=e
									return val(...)
								end
				e:SetValue(newval)
				
			end
		end
		return self.register_global_card_effect_table(self,e,forced)
	end
end

--Global Card Effect Table (for Duel.RegisterEffect)
if not global_duel_effect_table_global_check then
	global_duel_effect_table_global_check=true
	global_duel_effect_table={}
	Duel.register_global_duel_effect_table = Duel.RegisterEffect
	Duel.RegisterEffect = function(e,tp)
							if not global_duel_effect_table[tp] then global_duel_effect_table[tp]={} end
							table.insert(global_duel_effect_table[tp],e)
							
							local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
							if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcon =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return condition(...)
												end
								e:SetCondition(newcon)
							end
							if cost and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcost =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return cost(...)
												end
								e:SetCost(newcost)
							end
							if tg then
								if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0) then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								end
							end
							if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newop =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return op(...)
												end
								e:SetOperation(newop)
							end
							if val then
								if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
									local newval =	function(...)
														self_reference_effect=e
														return val(...)
													end
									e:SetValue(newval)
								
								end
							end
							return Duel.register_global_duel_effect_table(e,tp)
	end
end