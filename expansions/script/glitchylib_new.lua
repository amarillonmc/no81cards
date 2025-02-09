--LIMITS
MAX_INT32 = 2147483647

--Fix for deprecated constants
EFFECT_FLAG_COPY_INHERIT = EFFECT_FLAG_COPY

--Custom Categories
CATEGORY_ZONE		  				= 0x1
CATEGORY_DISABLE_ZONE 				= 0x2
CATEGORY_PLACE_AS_CONTINUOUS_TRAP	= 0x4
CATEGORY_REDIRECT_ATTACK			= 0x8
CATEGORY_SET						= 0x10
CATEGORY_ACTIVATE					= 0x20
CATEGORY_ATTACH						= 0x40
CATEGORY_DETACH						= 0x80
CATEGORY_UPDATE_ATTRIBUTE			= 0x100
CATEGORY_UPDATE_RACE				= 0x200
CATEGORY_UPDATE_SETCODE				= 0x400
CATEGORY_LVCHANGE					= 0x800
CATEGORY_PAYLP						= 0x1000
CATEGORY_ACTIVATES_ON_NORMAL_SET	= 0x2000
CATEGORY_UPDATE_ENERGY				= 0x4000
CATEGORY_CHANGE_ENERGY				= 0x8000
CATEGORY_RESET_ENERGY				= 0x10000
CATEGORY_SPSUMMON_RITUAL_MONSTER	= 0x20000

CATEGORIES_ATKDEF			=	CATEGORY_ATKCHANGE|CATEGORY_DEFCHANGE
CATEGORIES_SEARCH 			= 	CATEGORY_SEARCH|CATEGORY_TOHAND
CATEGORIES_FUSION_SUMMON 	= 	CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON
CATEGORIES_TOKEN 			= 	CATEGORY_SPECIAL_SUMMON|CATEGORY_TOKEN

CATEGORY_FLAG_SELF					= 0x1
CATEGORY_FLAG_DELAYED_RESOLUTION	= 0x2
CATEGORY_FLAG_END_OF_MP_TRIGGER		= 0x4
CATEGORY_FLAG_EXTRA_ATTACK_FILTER	= 0x8	--For effect that grant additional attacks against a specific category of monsters only (see Machina-Eyes Zero)

--Operation Info Special Values
OPINFO_FLAG_HALVE	= 0x1
OPINFO_FLAG_DOUBLE 	= 0x2
OPINFO_FLAG_UNKNOWN = 0x4
OPINFO_FLAG_HIGHER 	= 0x8
OPINFO_FLAG_LOWER 	= 0x10
OPINFO_FLAG_FUNCTION= 0x20

--Custom Effects
EFFECT_SET_SPSUMMON_LIMIT				= 39503

--Custom Events
EVENT_ACTIVATED_DIRECTLY = 61811408

--Locations
LOCATION_ENGAGED	=	0x1000

--Rating types
RATING_LEVEL	 = 	0x1
RATING_RANK		=	0x2
RATING_LINK		=	0x4
RATING_FUTURE	=	0x8

--Stat types
STAT_ATTACK  = 0x1
STAT_DEFENSE = 0x2

--COIN RESULTS
COIN_HEADS = 1
COIN_TAILS = 0

--Effects
GLOBAL_EFFECT_RESET	=	10203040

--Players
PLAYER_EITHER = 4

--Properties
EFFECT_FLAG_DD = EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL
EFFECT_FLAG_DDD = EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL

--zone constants
EXTRA_MONSTER_ZONE=0x60

--resets
RESETS_REDIRECT_FIELD 			= 0x047e0000
RESETS_STANDARD_PHASE_END		= RESETS_STANDARD|RESET_PHASE|PHASE_END
RESETS_STANDARD_DISABLE			= RESETS_STANDARD|RESET_DISABLE
RESETS_STANDARD_UNION 			= RESETS_STANDARD&(~(RESET_TOFIELD|RESET_LEAVE))
RESETS_STANDARD_TOFIELD 		= RESETS_STANDARD&(~(RESET_TOFIELD))
RESETS_STANDARD_EXC_GRAVE 		= RESETS_STANDARD&~(RESET_LEAVE|RESET_TOGRAVE)
RESETS_STANDARD_FACEDOWN 		= RESETS_STANDARD&(~(RESET_TURN_SET))

--timings
RELEVANT_TIMINGS 		= TIMINGS_CHECK_MONSTER|TIMING_MAIN_END|TIMING_END_PHASE
RELEVANT_BATTLE_TIMINGS = TIMING_BATTLE_PHASE|TIMING_BATTLE_END|TIMING_ATTACK|TIMING_BATTLE_START|TIMING_BATTLE_STEP_END

--win
WIN_REASON_CUSTOM = 0xff

--constants aliases
TYPE_ST			= TYPE_SPELL|TYPE_TRAP
TYPE_GEMINI		= TYPE_DUAL
TYPES_NO_LEVEL	= TYPE_XYZ|TYPE_LINK

SUBTYPES_SPELL	= TYPE_CONTINUOUS|TYPE_RITUAL|TYPE_QUICKPLAY|TYPE_FIELD|TYPE_EQUIP
SUBTYPES_TRAP	= TYPE_CONTINUOUS|TYPE_COUNTER
SUBTYPES_ST		= TYPE_CONTINUOUS|TYPE_COUNTER|TYPE_RITUAL|TYPE_QUICKPLAY|TYPE_FIELD|TYPE_EQUIP

ATTRIBUTES_CHAOS = ATTRIBUTE_LIGHT|ATTRIBUTE_DARK

RACES_BEASTS = RACE_BEAST|RACE_BEASTWARRIOR|RACE_WINDBEAST

LOCATION_ALL 		= LOCATION_DECK|LOCATION_HAND|LOCATION_MZONE|LOCATION_SZONE|LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_EXTRA|LOCATION_OVERLAY
LOCATION_GB  		= LOCATION_GRAVE|LOCATION_REMOVED
LOCATIONS_PRIVATE 	= LOCATION_HAND|LOCATION_DECK|LOCATION_EXTRA

LINK_MARKER_ALL = 0x1ef

MAX_RATING = 14

REASON_EXCAVATE	= REASON_REVEAL

RESET_TURN_SELF = RESET_SELF_TURN
RESET_TURN_OPPO = RESET_OPPO_TURN

--AnnounceNumber
local _AnnounceNumber = Duel.AnnounceNumber

Duel.AnnounceNumber = function(p,n1,...)
	local x={...}
	table.insert(x,1,n1)
	local negatives={}
	for i=#x,1,-1 do
		local n=x[i]
		if n<0 then
			table.insert(negatives,n*-1)
			table.remove(x,i)
		end
	end
	
	if #negatives==0 then
		return _AnnounceNumber(p,n1,...)
	else
		local opt=aux.Option(p,false,false,{#x>0,STRING_INPUT_NONNEGATIVE_NUMBER},{true,STRING_INPUT_NEGATIVE_NUMBER})
		if opt==0 then
			return _AnnounceNumber(p,table.unpack(x))
		elseif opt==1 then
			local ct1,ct2=_AnnounceNumber(p,table.unpack(negatives))
			return ct1*-1,ct2
		end
		return false
	end
end

function Duel.AnnounceNumberMinMax(p,min,max,f,step)
	if not step then step=1 end
	local tab={}
	for i=min,max,step do
		if not f or f(i,p) then
			table.insert(tab,i)
		end
	end
	return Duel.AnnounceNumber(p,table.unpack(tab))
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
function Card.Activation(c,oath,timings,cond,cost,tg,op,stop)
	local e1=Effect.CreateEffect(c)
	if c:IsOriginalType(TYPE_PENDULUM) then
		e1:SetDescription(STRING_ACTIVATE_PENDULUM)
	end
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if oath then
		e1:HOPT(true)
	end
	if timings then
		if type(timings)=="boolean" then
			e1:SetRelevantTimings()
		elseif type(timings)=="table" then
			e1:SetHintTiming(timings[1],timings[2])
		else
			e1:SetHintTiming(timings)
		end
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
	if not stop then
		c:RegisterEffect(e1)
	end
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
function Duel.Highlight(g)
	if #g>0 then
		Duel.HintSelection(g)
		return true
	else
		return false
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

--Alternative Actions
function Duel.ToHandOrSpecialSummon(c,e,tp,cond,sumtyp,toplayer,ign1,ign2,pos)
	sumtyp=sumtyp and sumtyp or 0
	toplayer=toplayer and toplayer or tp
	if not ign1 then ign1=false end
	if not ign2 then ign2=false end
	pos=pos and pos or POS_FACEUP
	
	local b1=c:IsAbleToHand()
	local b2=Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,sumtyp,tp,ign1,ign2,pos,toplayer) and (cond==nil or cond)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,nil,nil,{b1,STRING_ADD_TO_HAND},{b2,STRING_SPECIAL_SUMMON})
	if opt==0 then
		return Duel.Search(c)
	elseif opt==1 then
		return Duel.SpecialSummon(c,sumtyp,tp,toplayer,ign1,ign2,pos)
	end
end
function Duel.ToHandOrGrave(c,tp,p,cond)
	local b1=c:IsAbleToHand()
	local b2=c:IsAbleToGrave() and (cond==nil or cond)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,nil,nil,{b1,STRING_ADD_TO_HAND},{b2,STRING_SEND_TO_GY})
	if opt==0 then
		return Duel.Search(c,nil,p)
	elseif opt==1 then
		return Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function Duel.ToHandOrSSet(c,tp,p,cond)
	local b1=c:IsAbleToHand()
	local b2=c:IsSSetable() and (cond==nil or cond)
	if not b1 and not b2 then return end
	local opt=aux.Option(tp,nil,nil,{b1,STRING_ADD_TO_HAND},{b2,STRING_SET})
	if opt==0 then
		return Duel.Search(c,nil,p)
	elseif opt==1 then
		return Duel.SSet(tp,c)
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

--Operation Infos
function Duel.SetCardOperationInfo(g,cat)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	return Duel.SetOperationInfo(0,cat,g,#g,g:GetFirst():GetControler(),g:GetFirst():GetLocation())
end

function Auxiliary.Info(ctg,ct,p,v)
	return	function(_,e,tp)
				local p=(p>1) and p or (p==0) and tp or (p==1) and 1-tp 
				return Duel.SetOperationInfo(0,ctg,nil,ct,p,v)
			end
end
function Auxiliary.DamageInfo(p,v)
	return Auxiliary.Info(CATEGORY_DAMAGE,0,p,v)
end
function Auxiliary.DrawInfo(p,v)
	return Auxiliary.Info(CATEGORY_DRAW,0,p,v)
end
function Auxiliary.MillInfo(p,v)
	return Auxiliary.Info(CATEGORY_DECKDES,0,p,v)
end
function Auxiliary.RecoverInfo(p,v)
	return Auxiliary.Info(CATEGORY_RECOVER,0,p,v)
end

--New Operation Infos
function Auxiliary.ClearCustomOperationInfo(e,tp,eg,ep,ev,re,r,rp)
	for i,chtab in pairs(global_effect_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
		global_effect_info_table[i]=nil
	end
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
	for i,chtab in pairs(global_possible_custom_effect_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
		global_possible_custom_effect_info_table[i]=nil
	end
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
	for i,chtab in pairs(global_possible_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
		global_possible_info_table[i]=nil
	end
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
	for i,chtab in pairs(global_additional_info_table) do
		for _,tab in ipairs(chtab) do
			local dg=tab[2]
			if dg then
				dg:DeleteGroup()
			end
		end
		global_additional_info_table[i]=nil
	end
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

--Card Actions
function Duel.ActivateDirectly(tc,tp)
	local te=tc:GetActivateEffect()
	if not te:IsActivatable(tp,true,true) then return end
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseSingleEvent(tc,EVENT_ACTIVATED_DIRECTLY,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.RaiseEvent(tc,EVENT_ACTIVATED_DIRECTLY,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function Card.IsDirectlyActivatable(c,tp,ignore_loc)
	if not c:IsType(TYPE_FIELD|TYPE_CONTINUOUS) then return false end
	local e=c:GetActivateEffect()
	return e and (c:IsType(TYPE_FIELD) or ignore_loc or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and e:IsActivatable(tp,true,true)
end

--Attach as material
function Card.IsCanBeAttachedTo(c,xyzc,e,p,r)
	return c:IsCanOverlay(xyzc:GetControler()) and not c:IsForbidden() --futureproofing
end
function Duel.Attach(c,xyz,transfer,e,r,rp)
	if aux.GetValueType(c)=="Card" then
		if not c:IsCanBeAttachedTo(xyz,e,rp,r) or (e and r&REASON_EFFECT>0 and c:IsImmuneToEffect(e)) then
			return false
		end
		local og=c:GetOverlayGroup()
		if #og>0 then
			if transfer then
				Duel.Overlay(xyz,og)
			else
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(xyz,Group.FromCards(c))
		return xyz:GetOverlayGroup():IsContains(c)
			
	elseif aux.GetValueType(c)=="Group" then
		for tc in aux.Next(c) do
			local og=tc:GetOverlayGroup()
			if tc:IsCanBeAttachedTo(xyz,e,rp,r) and not (e and r&REASON_EFFECT>0 and tc:IsImmuneToEffect(e)) then
				if #og>0 then
					if transfer then
						Duel.Overlay(xyz,og)
					else
						Duel.SendtoGrave(og,REASON_RULE)
					end
				end
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

--[[Banish a card temporarily
- g: 			Card, or Group, to banish
- e: 			Effect that banishes
- tp:			Player that performs the banishing
- pos:			If defined, forces the position the card will be banished in
- phase:		Specify the Phase during which the banished cards will return to the field. It also accepts RESET_SELF_TURN and RESET_OPPO_TURN. Defaults to PHASE_END
- id:			Specify the flag that will be registered to the banished cards. Only cards that retain the flag until the end of their banishment period will return to the field
- phasect:		Specify how many of the specified phases have to pass before the cards can return. Defaults to 1.
- phasenext:	If true, specifies that the cards will return only after the "next" [phasect] [phase]
- rc:			If defined, forces the card that will own the global effect that will return the cards to the field. Defaults to e:GetHandler()
- r:			If defined, forces the reason of the banishment. Defaults to REASON_EFFECT.

- disregard_turncount : If true, the condition for the returning effect will not check whether the actual turn count of the Duel matches the label of the effect
- counts_turns:			If the number of turns is set, the returning effect will be one that "counts turns" (for interactions with "Pyro Clock of Destiny")

- op:  If defined, replaces the banishing action with a custom one
- loc:  Set only if you defined a custom "op". Specifies the location the cards must be in after being affected by the effect, in order to be counted as successfully affected
		and eligible for returning to the field.
		Defaults to LOCATION_REMOVED
- lingering_effect_to_reset: If it is a number, resets all flags of the returning cards with that number after returning to the field. If it is an effect, resets the specified effect.
]]

function Duel.BanishUntil(g,e,tp,pos,phase,id,phasect,phasenext,rc,r,disregard_turncount,counts_turns,op,loc,lingering_effect_to_reset)
	if not e then
		e=self_reference_effect
	end
	if not tp then
		tp=current_triggering_player
	end
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if not phase then phase=PHASE_END end
	if not id then id=e:GetOwner():GetOriginalCode() end
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
		local because=r==REASON_COST and aux.BecauseOfThisCost or aux.BecauseOfThisEffect
		local og=g:Filter(Card.IsLocation,nil,loc):Filter(because,nil,e)
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
			
			local eid=e:GetFieldID()
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|phase,EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_CLIENT_HINT,turnct2,eid,STRING_TEMPORARILY_BANISHED)
			end
			local turnct0 = not p and Duel.GetTurnCount() or Duel.GetTurnCount(p)
			local e1=Effect.CreateEffect(rc)
			e1:SetDescription(STRING_RETURN_TO_FIELD)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE|ph)
			e1:SetReset(RESET_PHASE|phase,turnct2)
			e1:SetCountLimit(1)
			e1:SetLabel(turnct0+turnct,id,eid)
			e1:SetLabelObject(og)
			if not counts_turns then
				e1:SetCondition(aux.TimingCondition(ph,p,disregard_turncount))
			else
				e1:SetCondition(aux.TimingConditionButCountsTurns(counts_turns))
			end
			e1:SetOperation(aux.ReturnLabelObjectToFieldOp(id,lingering_effect_to_reset,r))
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
				local g=e:GetLabelObject()
				local tct,id,eid=e:GetLabel()
				if not g or g:FilterCount(Card.HasFlagEffectLabel,nil,id,eid)==0 then
					e:Reset()
					return false
				end
				local turnct = not p and Duel.GetTurnCount() or Duel.GetTurnCount(p)
				return Duel.GetCurrentPhase()==phase and (not p or Duel.GetTurnPlayer()==p) and (disregard_turncount or turnct==tct)
			end
end
function Auxiliary.TimingConditionButCountsTurns(counts_turns)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=e:GetLabelObject()
				local tct,id,eid=e:GetLabel()
				if not g or g:FilterCount(Card.HasFlagEffectLabel,nil,id,eid)==0 then
					e:Reset()
					return false
				end
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
function Auxiliary.ReturnLabelObjectToFieldOp(id,lingering_effect_to_reset,r)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local g=e:GetLabelObject()
				local ltype=aux.GetValueType(lingering_effect_to_reset)
				--Debug.Message("OBJSIZE: "..#g)
				local sg=g:Filter(Card.HasFlagEffect,nil,id)
				local rg=Group.CreateGroup()
				local turnp=Duel.GetTurnPlayer()
				for p=turnp,1-turnp,1-2*turnp do
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
						local sgf=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_FZONE|LOCATION_HAND|LOCATION_GRAVE)
						rg:Merge(sgf)
					end
				end
				--Debug.Message(#rg)
				
				if ltype=="number" then
					tc:ResetFlagEffect(lingering_effect_to_reset)
				elseif ltype=="Effect" then
					lingering_effect_to_reset:Reset()
				elseif ltype=="table" then
					for _,le in ipairs(lingering_effect_to_reset) do
						le:Reset()
					end
				end
				
				local tohand,tograve=Group.CreateGroup(),Group.CreateGroup()
				if #rg>0 then
					sg:Sub(rg)
					for tc in aux.Next(rg) do
						if tc:IsPreviousLocation(LOCATION_FZONE) then
							Duel.MoveToField(tc,tp,tc:GetPreviousControler(),LOCATION_FZONE,tc:GetPreviousPosition(),true)
							
						elseif tc:IsPreviousLocation(LOCATION_ONFIELD) then
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
							
						elseif tc:IsPreviousLocation(LOCATION_HAND) then
							tohand:AddCard(tc)
							
						elseif tc:IsPreviousLocation(LOCATION_GRAVE) then
							tograve:AddCard(tc)
						end
					end
				end
				if #tohand>0 then
					Duel.SendtoHand(tohand,nil,r|REASON_RETURN)
				end
				if #tograve>0 then
					Duel.SendtoGrave(tograve,r|REASON_RETURN)
				end
				for tc in aux.Next(sg) do
					Duel.ReturnToField(tc)
				end
				g:DeleteGroup()
			end
end

--EQUIP
----For cards that equip other cards to themselves ONLY
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
----For effects that equip a card to another card
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

----Equip-related filters
function Card.IsAppropriateEquipSpell(c,ec,tp)
	return c:IsSpell(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function Card.IsCanBeEquippedWith(c,ec,e,p,r,ignore_faceup)
	return (ignore_faceup or c:IsFaceup()) and (not ec or (not ec:IsForbidden() and ec:CheckUniqueOnField(p,LOCATION_SZONE)))
	--futureproofing (more checks could be added in the future)
end


--
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


--NEGATES
function Card.CheckNegateConjunction(c,e1,e2,e3)
	return not c:IsImmuneToEffect(e1) and not c:IsImmuneToEffect(e2) and (not e3 or not c:IsImmuneToEffect(e3))
end

TYPE_NEGATE_ALL = TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP
function Duel.Negate(g,e,reset,notfield,forced,typ,cond,prop)
	local rct=1
	if not reset then
		reset=0
	elseif type(reset)=="table" then
		rct=reset[2]
		reset=reset[1]
	end
	if not typ then typ=TYPE_NEGATE_ALL end
	prop=prop and prop or 0
	
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
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|prop)
		e1:SetCode(EFFECT_DISABLE)
		if cond then
			e1:SetCondition(cond)
		end
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
		tc:RegisterEffect(e1,forced)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|prop)
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
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|prop)
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
			if returntype=="Card" then
				return e1,e2,e3,res
			end
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
function Duel.NegateMonster(g,e,reset,forced,cond,prop)
	return Duel.Negate(g,e,reset,false,forced,TYPE_MONSTER,cond,prop)
end

--POSITION
function Duel.PositionChange(c)
	return Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end

--SEARCHING AND CHECKS
function Duel.Search(g,_,p,brk,r)
	if type(brk)=="number" then r=brk brk=nil end	--compatibility
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if not r then r=REASON_EFFECT end
	local ct=Duel.SendtoHand(g,p,r)
	local cg=g:Filter(aux.PLChk,nil,p,LOCATION_HAND)
	if #cg>0 then
		if brk then
			Duel.BreakEffect()
		end
		if p then
			Duel.ConfirmCards(1-p,cg)
		else
			for tp=0,1 do
				local pg=cg:Filter(Card.IsControler,nil,tp)
				if #pg>0 then
					Duel.ConfirmCards(1-tp,pg)
				end
			end
		end
	end
	return ct,#cg,cg
end
function Duel.SearchAndCheck(g,_,p,brk,r,count)
	count = count or 1
	local ct,cgct=Duel.Search(g,_,p,brk,r)
	return ct>=count and cgct>=count
end
function Duel.Bounce(g,p,r)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	r = r and r or REASON_EFFECT
	local ct=Duel.SendtoHand(g,p,r)
	local cg=g:Filter(aux.PLChk,nil,p,LOCATION_HAND)
	return ct,#cg,cg
end
function Duel.BounceAndCheck(g,p,r)
	local ct,cgct=Duel.Bounce(g,p,r)
	return ct>0 and cgct>0
end

function Duel.SendtoGraveAndCheck(g,p,r,count)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	r = r or REASON_EFFECT
	count = count or 1
	local ct=Duel.SendtoGrave(g,r)
	if ct<count then return false end
	local cg=g:Filter(aux.PLChk,nil,p,LOCATION_GRAVE)
	return #cg>=count
end

--RETURN TO DECK
function Duel.ShuffleIntoDeck(g,p,loc,seq,r,f)
	if not loc then loc=LOCATION_DECK|LOCATION_EXTRA end
	if not seq then seq=SEQ_DECKSHUFFLE end
	if not r then r=REASON_EFFECT end
	local ct=Duel.SendtoDeck(g,p,seq,r)
	if ct>0 then
		if seq==SEQ_DECKSHUFFLE and loc&LOCATION_DECK>0 then
			aux.AfterShuffle(g)
		end
		if aux.GetValueType(g)=="Card" and aux.PLChk(g,p,loc) and (not f or f(g)) then
			return 1
		elseif aux.GetValueType(g)=="Group" then
			local sg=g:Filter(aux.PLChk,nil,p,loc)
			if f then
				sg=sg:Filter(f,nil,sg)
			end
			return #sg
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
function Duel.PlaceOnTopOrBottomOfDeck(g,tp,p)
	if aux.GetValueType(g)=="Card" then
		g=Group.FromCards(g)
	end
	local ct=0
	local seqs={SEQ_DECKTOP,SEQ_DECKBOTTOM}
	for c in aux.Next(g) do
		local opt=Duel.SelectOption(tp,STRING_DECKTOP,STRING_DECKBOTTOM)+1
		if Duel.SendtoDeck(c,p,seqs[opt],REASON_EFFECT)>0 then
			ct=ct+1
		end
	end
	return ct
end

--OPERATION CHECKS
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
function Auxiliary.AfterShuffle(g)
	for p=0,1 do
		if aux.PLChk(g,p,LOCATION_DECK) then
			Duel.ShuffleDeck(p)
		end
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
function Auxiliary.BecauseOfThisCost(e)
	return	function(c)
				return c:IsReason(REASON_COST) and not c:IsReason(REASON_REDIRECT) and c:GetReasonEffect()==e
			end
end
function Duel.GetGroupOperatedByThisCost(e,exc)
	return Duel.GetOperatedGroup():Filter(aux.BecauseOfThisCost(e),exc)
end
function Auxiliary.BecauseOfThisRule(e)
	return	function(c)
				return c:IsReason(REASON_RULE) and not c:IsReason(REASON_REDIRECT) and c:GetReasonEffect()==e
			end
end
function Duel.GetGroupOperatedByThisRule(e,exc)
	return Duel.GetOperatedGroup():Filter(aux.BecauseOfThisRule(e),exc)
end

--Battle Phase
function Card.IsCapableOfAttacking(c,tp)
	if not tp then tp=Duel.GetTurnPlayer() end
	return not c:IsForbidden() and not c:IsHasEffect(EFFECT_CANNOT_ATTACK) and not c:IsHasEffect(EFFECT_ATTACK_DISABLED) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_SKIP_BP)
end
function Duel.GetBattleMonsters(tp)
	if not tp then tp=0 end
	return Duel.GetBattleMonster(tp),Duel.GetBattleMonster(1-tp)
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
function Card.IsEquipCard(c)
	return c:GetEquipTarget()~=nil
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

--Stats modifiers (futureproofing)
function Card.HasAttack(c)
	return c:IsMonster()
end
function Card.HasATK(c)
	return c:HasAttack()
end
function Card.IsCanUpdateATK(c,atk,e,tp,r,exactly)
	return c:IsFaceup() and c:HasATK() and (not exactly or atk>=0 or c:IsAttackAbove(-atk))
end
function Card.IsCanChangeAttack(c,atk)
	return c:IsFaceup() and c:HasATK() and (not atk or not c:IsAttack(atk))
end
function Card.IsCanChangeATK(c,atk,e,tp,r)
	return c:IsCanChangeAttack(atk,e,tp,r)
end

function Card.HasDefense(c)
	return c:IsMonster() and not c:IsOriginalType(TYPE_LINK)
end
function Card.HasDEF(c)
	return c:HasDefense()
end
function Card.IsCanUpdateDEF(c,def,e,tp,r,exactly)
	return c:IsFaceup() and c:HasDEF() (not exactly or def>=0 or c:IsDefenseAbove(-def))
end
function Card.IsCanChangeDefense(c,def)
	return c:IsFaceup() and c:HasDEF() and (not def or not c:IsDefense(def))
end
function Card.IsCanChangeDEF(c,def,e,tp,r)
	return c:IsCanChangeDefense(def,e,tp,r)
end

function Card.IsCanChangeStats(c,atk,def,e,tp,r)
	return c:IsCanChangeATK(atk,e,tp,r) or c:IsCanChangeDEF(def,e,tp,r)
end
function Card.IsCanUpdateStats(c,atk,def,e,tp,r,exactly)
	return c:IsCanUpdateATK(atk,e,tp,r) or c:IsCanUpdateDEF(def,e,tp,r)
end

function Card.IsCanChangeLevel(c,lv,e,tp,r)
	return c:HasLevel() and not c:IsLevel(lv)
end

--
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
	return not c:IsOriginalType(TYPES_NO_LEVEL)
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

function Card.GetTotalStats(c)
	return c:GetAttack()+c:GetDefense()
end
function Card.GetMinStat(c)
	return math.min(c:GetAttack(),c:GetDefense())
end
function Card.GetMaxStat(c)
	return math.max(c:GetAttack(),c:GetDefense())
end
function Card.GetMinBaseStat(c)
	return math.min(c:GetBaseAttack(),c:GetBaseDefense())
end
function Card.GetMaxBaseStat(c)
	return math.max(c:GetBaseAttack(),c:GetBaseDefense())
end
function Card.IsStats(c,atk,def)
	return (not atk or c:IsAttack(atk)) and (not def or c:IsDefense(def))
end
function Card.GetStats(c)
	return c:GetAttack(),c:GetDefense()
end
function Card.IsBaseStats(c,atk,def)
	return (not atk or c:GetBaseAttack()==atk) and (not def or c:GetBaseDefense()==def)
end
function Card.IsTextStats(c,atk,def)
	return (not atk or c:GetTextAttack()==atk) and (not def or c:GetTextDefense()==def)
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
		[TYPE_BIGBANG]=SUMMON_TYPE_BIGBANG;
		[TYPE_TIMELEAP]=SUMMON_TYPE_TIMELEAP;
		[TYPE_DRIVE]=SUMMON_TYPE_DRIVE
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
function Duel.GetTargetPlayer()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
end
function Duel.GetTargetParam()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
end

function Effect.GetChainLink(e)
	local max=Duel.GetCurrentChain()
	if max==0 then return 0 end
	for i=1,max do
		local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if ce==e then
			return i
		end
	end
	return 0
end

--Chain Limits
function Auxiliary.ChainLimitOppo(e,ep,tp)
	return tp==ep
end

--Cloned Effects
--not_simultaneous : If true, prevents the original effect and the QE clone from being both activatable in a certain gamestate
function Effect.QuickEffectClone(e,c,cond,notreg,not_simultaneous)
	local ex=e:Clone()
	ex:SetType(EFFECT_TYPE_QUICK_O)
	ex:SetCode(EVENT_FREE_CHAIN)
	ex:SetRelevantTimings()
	if cond then
		local ogcond=e:GetCondition()
		if ogcond then
			ex:SetCondition(aux.AND(cond,ogcond))
		else
			ex:SetCondition(cond)
		end
		if not_simultaneous==nil or not_simultaneous then
			if ogcond then
				e:SetCondition(aux.AND(ogcond,aux.NOT(cond)))
			else
				e:SetCondition(aux.NOT(cond))
			end
		end
	end
	if not notreg then
		c:RegisterEffect(ex)
	end
	return ex
end
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
function Card.IsCodeOrMentions(c,code,...)
	local codes={...}
	table.insert(codes,1,code)
	if #codes==0 then return false end
	return c:IsCode(table.unpack(codes)) or c:Mentions(table.unpack(codes))
end
function Card.Mentions(c,code,...)
	local codes={...}
	table.insert(codes,1,code)
	if #codes==0 then return false end
	for _,cd in ipairs(codes) do
		if aux.IsCodeListed(c,cd) then
			return true
		end
	end
	return false
end
function Card.IsMentioned(c1,c2)
	local codes={c1:GetCode()}
	return c2:Mentions(table.unpack(codes))
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

--Continuous Effects
function Auxiliary.RegisterMaxxCEffect(c,id,p,range,event,cond,outchainop,inchainop,flaglabel,reset,flagreset,label,labelobj)
	local rct,flagrct=1,1
	if type(reset)=="table" then
		rct=reset[2]
		reset=reset[1]
	end
	if type(flagreset)=="table" then
		flagrct=flagreset[2]
		flagreset=flagreset[1]
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(event)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(aux.OutsideChainMaxxCCondition(cond))
	e2:SetOperation(outchainop)
	if label then
		e2:SetLabel(label)
	end
	if labelobj then
		e2:SetLabelObject(labelobj)
	end
	if reset then
		e2:SetReset(reset,rct)
	end
	if p then
		Duel.RegisterEffect(e2,p)
	else
		e2:SetRange(range)
		c:RegisterEffect(e2)
	end
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e3:SetCode(event)
	e3:SetCondition(aux.InsideChainMaxxCCondition(cond))
	e3:SetOperation(aux.RegisterMaxxCFlag(id,flaglabel,flagreset,flagrct))
	if label then
		e3:SetLabel(label)
	end
	if labelobj then
		e3:SetLabelObject(labelobj)
	end
	if reset then
		e3:SetReset(reset,rct)
	end
	if p then
		Duel.RegisterEffect(e3,p)
	else
		e3:SetRange(range)
		c:RegisterEffect(e3)
	end
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetCondition(aux.MaxxCFlagCondition(id,cond))
	e4:SetOperation(aux.ResolvedChainMaxxCOperation(id,inchainop))
	if label then
		e4:SetLabel(label)
	end
	if labelobj then
		e4:SetLabelObject(labelobj)
	end
	if reset then
		e4:SetReset(reset,rct)
	end
	if p then
		Duel.RegisterEffect(e4,p)
	else
		e4:SetRange(range)
		c:RegisterEffect(e4)
	end
	
	return e2,e3,e4
end
function Auxiliary.OutsideChainMaxxCCondition(cond)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return (not cond or cond(e,tp,eg,ep,ev,re,r,rp)) and not Duel.IsChainSolving()
			end
end
function Auxiliary.InsideChainMaxxCCondition(cond)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return (not cond or cond(e,tp,eg,ep,ev,re,r,rp)) and Duel.IsChainSolving()
			end
end
function Auxiliary.RegisterMaxxCFlag(id,flaglabel,reset,rct)
	if not reset then reset=0 end
	local resets=RESET_CHAIN|reset
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local lab=0
				if flaglabel then
					lab=flaglabel(e,tp,eg,ep,ev,re,r,rp)
				end
				Duel.RegisterFlagEffect(tp,id,resets,0,rct,lab)
			end
end
function Auxiliary.MaxxCFlagCondition(id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return (not cond or cond(e,tp,eg,ep,ev,re,r,rp)) and Duel.PlayerHasFlagEffect(tp,id)
			end
end
function Auxiliary.ResolvedChainMaxxCOperation(id,op)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local n=Duel.GetFlagEffect(tp,id)
				op(e,tp,eg,ep,ev,re,r,rp,n)
				Duel.ResetFlagEffect(tp,id)
			end
end

--Control
function Card.CanOnlyControlOne(c,id)
	return c:SetUniqueOnField(1,0,id)
end
function Card.OnlyOneOnField(c,id)
	return c:SetUniqueOnField(1,1,id)
end

--Counters
RELEVANT_REMOVE_EVENT_COUNTERS = {0x100e, COUNTER_ICE}
COUNTED_COUNTERS_FOR_REMOVE_EVENT = {}

function Card.HasCounter(c,ctype)
	return c:GetCounter(ctype)>0
end

function aux.RegisterCountersBeforeLeavingField(c,counter,range,f,id)
	local type=range and EFFECT_TYPE_FIELD or EFFECT_TYPE_SINGLE
	if not f then f=aux.TRUE end
	
	local e=Effect.CreateEffect(c)
	e:SetType(type|EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_LEAVE_FIELD_P)
	e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	if not range then
		e:SetOperation(function (E)
			local ct=E:GetHandler():GetCounter(counter)
			E:SetLabel(ct)
		end)
	else
		e:SetRange(range)
		e:SetOperation(function (E,TP,EG,EP,EV,RE,R,RP)
			local g=EG:Filter(f,nil)
			for tc in aux.Next(g) do
				local ct=tc:GetCounter(counter)
				if ct>0 then
					tc:RegisterFlagEffect(id,RESET_EVENT|RESET_TOFIELD,0,0,ct)
				end
			end
		end)
	end
	c:RegisterEffect(e)
	return e
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
function Auxiliary.DistributeCountersGroupCheck(ctype,least_one,defaultloc)
	if type(least_one)=="nil" then least_one=false end
	return	function(g,val,n)
				if val<1 then return false end
				for c in aux.Next(g) do
					local loc=0
					if not c:IsOnField() and defaultloc then
						loc=defaultloc
					end
					for i=val,1,-1 do
						if c:IsCanAddCounter(ctype,i,least_one,loc) then
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
	Duel.HintMessage(tp,HINTMSG_COUNTER)
	local sg=g:SelectSubGroup(tp,aux.DistributeCountersGroupCheck(ctype),false,1,math.min(#g,n),n)
	if #sg==0 then return 0 end
	local cardct=0
	local ct=0
	if #sg==1 then
		Duel.HintSelection(sg)
		if sg:GetFirst():AddCounter(ctype,n) then
			return 1
		end
		return 0
	elseif #sg==n then
		for tc in aux.Next(sg) do
			Duel.HintSelection(Group.FromCards(tc))
			if tc:AddCounter(ctype,1) then
				cardct=cardct+1
			end
		end
		return cardct
	else
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
				cardct=cardct+1
			end
			ct=ct+n
		end
		return cardct
	end
	return cardct
end

function Auxiliary.PickCountersGroupCheck(ctype)
	return	function(g,val,n,tp,r)
				if val<1 then return false end
				for c in aux.Next(g) do
					for i=val,1,-1 do
						if c:IsCanRemoveCounter(tp,ctype,i,r) then
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
								local res=sg:CheckSubGroup(aux.PickCountersGroupCheck(ctype),#sg,#sg,val,n,tp,r)
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
function Duel.PickCounters(tp,ctype,n,g,id,r)
	if not r then r=REASON_EFFECT end
	Duel.HintMessage(tp,HINTMSG_COUNTER)
	local sg=g:SelectSubGroup(tp,aux.PickCountersGroupCheck(ctype),false,1,math.min(#g,n),n,nil,tp,r)
	if #sg==0 then return 0 end
	local cardct=0
	local ct=0
	if #sg==1 then
		Duel.HintSelection(sg)
		if sg:GetFirst():RemoveCounter(tp,ctype,n,r) then
			return 1
		end
		return 0
	elseif #sg==n then
		for tc in aux.Next(sg) do
			Duel.HintSelection(Group.FromCards(tc))
			if tc:RemoveCounter(tp,ctype,1,r) then
				cardct=cardct+1
			end
		end
		return cardct
	else
		for tc in aux.Next(sg) do
			Duel.HintSelection(Group.FromCards(tc))
			tc:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_IGNORE_IMMUNE,1)
			local nums={}
			for i=n-ct,1,-1 do
				if tc:IsCanAddCounter(ctype,i,false) then
					local ng=sg:Filter(Card.HasFlagEffect,nil,id)
					local fg=sg:Filter(aux.NOT(Card.HasFlagEffect),nil,id)
					if (#ng==#sg or fg:CheckSubGroup(aux.PickCountersGroupCheck(ctype),#fg,#fg,n-ct-i,#fg,tp,r)) then
						table.insert(nums,i)
						if #ng==#sg then
							break
						end
					end
				end
			end
			local n=Duel.AnnounceNumber(tp,table.unpack(nums))
			if tc:RemoveCounter(tp,ctype,n,r) then
				cardct=cardct+1
			end
			ct=ct+n
		end
		return cardct
	end
	return cardct
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
local _SetDescription = Effect.SetDescription

Effect.SetDescription = function(e,id,str)
	if not str then
		return _SetDescription(e,id)
	else
		return _SetDescription(e,aux.Stringid(id,str))
	end
end

function Effect.Desc(e,id,...)
	local x = {...}
	if #x>0 then
		return e:SetDescription(aux.Stringid(x[1],id))
	else
		local c=e:GetOwner()
		if aux.GetValueType(aux.EffectBeingApplied)=="Effect" and aux.GetValueType(aux.ProxyEffect)=="Effect" and aux.ProxyEffect:GetOwner()==c then
			c=aux.EffectBeingApplied:GetOwner()
		end
		local code = c:GetOriginalCode()
		if id<16 then
			return e:SetDescription(aux.Stringid(code,id))
		else
			return e:SetDescription(id)
		end
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

function Duel.RegisterHint(p,flag,reset,rct,id,desc,prop,refeff)
	if not reset then reset=PHASE_END end
	if not rct then rct=1 end
	if not prop then prop=0 end
	local e=Effect.GlobalEffect()
	e:SetDescription(id,desc)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_CLIENT_HINT|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_PLAYER_TARGET|prop)
	e:SetCode(EFFECT_FLAG_EFFECT|flag)
	e:SetTargetRange(1,0)
	if refeff then
		e:SetLabelObject(refeff)
		e:SetCondition(aux.ResetHintCondition)
	end
	e:SetReset(RESET_PHASE|reset,rct)
	Duel.RegisterEffect(e,p)
	return e
end
function Auxiliary.ResetHintCondition(e)
	local refeff=e:GetLabelObject()
	if not refeff or refeff:WasReset() then
		e:Reset()
		return false
	end
	return true
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

--Filter for "If a [filter] monster is Special Summoned to a zone this card points to"
--Includes non-trivial handling of self-destructing Burning Abyss monsters
function Auxiliary.zptgroup(eg,filter,c,tp)
	local fil=eg:Filter(function(cc)return not filter or filter(cc,tp) end,nil)
	return (fil&c:GetLinkedGroup()) + eg:Filter(Auxiliary.zptfilter,nil,c)
end
function Auxiliary.zptgroupcon(eg,filter,c,tp)
	local fil=eg:Filter(function(cc)return not filter or filter(cc,tp) end,nil)
	return #(fil&c:GetLinkedGroup())>0 or eg:IsExists(Auxiliary.zptfilter,1,nil,c)
end
function Auxiliary.zptfilter(c,ec)
	return not c:IsLocation(LOCATION_MZONE) and (ec:GetLinkedZone(c:GetPreviousControler())&(1<<c:GetPreviousSequence()))~=0
end
--Condition for "If a [filter] monster is Special Summoned to a zone this card points to"
--Includes non-trivial handling of self-destructing Burning Abyss monsters
--Passes tp so you can check control
function Auxiliary.zptcon(filter)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return Auxiliary.zptgroupcon(eg,filter,e:GetHandler(),tp)
	end
end

function Group.CheckSameProperty(g,f,...)
	local chk=nil
	for tc in aux.Next(g) do
		chk = chk and (chk&f(tc,...)) or f(tc,...)
		if chk==0 then return false,0 end
	end
	return true, chk
end

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
--sg: This group is initially empty and is gradually filled with cards from g.
--mg: This is a clone of the sample group (g) but it does not contain the cards that failed the loop check
--rescon: The condition that must be satisfied by the cards in the temporary checked group (sg). If the "stop" condition is fulfilled, the card is immediately removed from "sg" and fails the loop check
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
	sumcount=sumcount or 1
	return	function(g,e,tp,mg)
				return Duel.GetMZoneCount(tp,g)>=sumcount
			end
end
function Auxiliary.ChkfMMZRel(sumcount,reason)
	sumcount=sumcount or 1
	reason=reason or REASON_COST
	return	function(g,e,tp,mg)
				return Duel.GetMZoneCount(tp,g)>=sumcount and Duel.CheckReleaseGroupEx(tp,Auxiliary.IsInGroup,#g,reason,false,nil,g)
			end
end
function Auxiliary.dncheckbrk(g,e,tp,mg,c)
	local res=g:GetClassCount(Card.GetCode)==#g
	return res, not res
end
function Auxiliary.ogdncheckbrk(g,e,tp,mg,c)
	local res=g:GetClassCount(Card.GetOriginalCodeRule)==#g
	return res, not res
end

--Excavate
function Auxiliary.excthfilter(c,tp)
	if not Duel.IsPlayerCanSendtoHand(tp,c) then return false end
	if not c:IsHasEffect(EFFECT_CANNOT_TO_HAND) then return true end
	local eset={c:IsHasEffect(EFFECT_CANNOT_TO_HAND)}
	for _,e in ipairs(eset) do
		if e:GetOwner()~=c then
			return false
		end
	end
	return true
end
function Duel.IsPlayerCanExcavateAndSearch(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	return #g==ct and g:FilterCount(aux.excthfilter,nil,tp)>0
end
function Duel.IsPlayerCanExcavateAndSpecialSummon(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	return #g==ct and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,CARD_EHERO_BLAZEMAN)
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
function Auxiliary.FaceupExFilter(f,...)
	local ext_params={...}
	return	function(target)
				return target:IsFaceupEx() and f(target,table.unpack(ext_params))
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
function Auxiliary.ActivateFilter(f)
	return	function(c,e,tp)
				return (not f or f(c,e,tp)) and c:GetActivateEffect():IsActivatable(tp,true,true)
			end
end
function Auxiliary.AttachFilter(f)
	return	function(c,e,...)
				return (not f or f(c,e,...)) and not c:IsType(TYPE_TOKEN) and not c:IsImmuneToEffect(e)
			end
end
function Auxiliary.AttachFilter2(f)
	return	function(c,...)
				return (not f or f(c,e,...)) and c:IsType(TYPE_XYZ)
			end
end
function Auxiliary.BanishFilter(f,cost,pos)
	pos = pos and pos or POS_FACEUP
	return	function(c,_,tp,...)
				return (not f or f(c,...)) and (not cost and c:IsAbleToRemove(tp,pos) or cost and c:IsAbleToRemoveAsCost(pos))
			end
end
function Auxiliary.ControlFilter(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsControlerCanBeChanged()
			end
end
function Auxiliary.DestroyFilter(f)
	return	function(c,e,...)
				return (not f or f(c,e,...)) and (c:IsOnField() or c:IsDestructable(e))
			end
end
function Auxiliary.DisableFilter(f)
	return	function(c,...)
				return (not f or f(c,...)) and aux.NegateAnyFilter(c)
			end
end
function Auxiliary.DiscardFilter(f,cost)
	local r = (not cost) and REASON_EFFECT or REASON_COST
	return	function(c)
				return (not f or f(c)) and c:IsDiscardable(r)
			end
end
function Auxiliary.SearchFilter(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsAbleToHand()
			end
end
function Auxiliary.SSetFilter(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsST() and c:IsSSetable()
			end
end
function Auxiliary.ToGYFilter(f,cost)
	return	function(c,...)
				return (not f or f(c,...)) and (not cost and c:IsAbleToGrave() or (cost and c:IsAbleToGraveAsCost()))
			end
end
function Auxiliary.ToGraveFilter(f,cost)
	return aux.ToGYFilter(f,cost)
end
function Auxiliary.ToHandFilter(f,cost)
	return	function(c,...)
				return (not f or f(c,...)) and (not cost and c:IsAbleToHand() or (cost and c:IsAbleToHandAsCost()))
			end
end
function Auxiliary.ToDeckFilter(f,cost,loc)
	if not cost then
		return	function(c,...)
			return (not f or f(c,...)) and c:IsAbleToDeck()
		end
	else
		local check=Card.IsAbleToDeckOrExtraAsCost
		if loc then
			if loc==LOCATION_DECK then
				check=Card.IsAbleToDeckAsCost
			elseif loc==LOCATION_EXTRA then
				check=Card.IsAbleToExtraAsCost
			end
		end
		return	function(c,...)
					return (not f or f(c,...)) and check(c)
				end
	end
end
function Auxiliary.NSFilter(f)
	return	function(c,...)
				return (not f or f(c,...)) and c:IsSummonable(true,nil)
			end
end
function Auxiliary.SSFilter(f,sumtype,sump,ign1,ign2,pos,recp,zone)
	if not sumtype then sumtype=0 end
	if not ign1 then ign1=false end
	if not ign2 then ign2=false end
	if not pos then pos=POS_FACEUP end
	if not zone then zone=0xff end
	return	function(c,e,tp,...)
				if not sump then sump=tp end
				if not recp then recp=tp end
				local zone = type(zone)=="number" and zone or zone(e,tp)
				return (not f or f(c,e,tp,...)) and c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,recp,zone)
			end
end
function Auxiliary.SSFromExtraDeckFilter(f,sumtype,sump,ign1,ign2,pos,recp,zone)
	if not sumtype then sumtype=0 end
	if not ign1 then ign1=false end
	if not ign2 then ign2=false end
	if not pos then pos=POS_FACEUP end
	if not zone then zone=0xff end
	return	function(c,e,tp,...)
				if not sump then sump=tp end
				if not recp then recp=tp end
				local zone = type(zone)=="number" and zone or zone(e,tp)
				return (not f or f(c,e,tp,...)) and c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,recp,zone)
					and Duel.GetLocationCountFromEx(recp,sump,nil,c,zone)>0
			end
end
function Auxiliary.SSToEitherFieldFilter(f,sumtype,sump,ign1,ign2,pos,zone1,zone2)
	if not sumtype then sumtype=0 end
	if not ign1 then ign1=false end
	if not ign2 then ign2=false end
	if not pos then pos=POS_FACEUP end
	if not zone then zone=0xff end
	return	function(c,e,tp,...)
				if not sump then sump=tp end
				local zone = type(zone)=="number" and zone or zone(e,tp)
				return (not f or f(c,e,tp,...))
					and (c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,zone1) or c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone2))
			end
end

--Flag Effects
function Card.GetFlagEffectWithSpecificLabel(c,flag,label,reset)
	flag=flag&MAX_ID
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT|flag)}
	for i=#eset,1,-1 do
		local e=eset[i]
		local x=e:GetLabel()
		if not label or x==label then
			if not reset then
				return e
			else
				e:Reset()
			end
		end
	end
	return
end
function Duel.GetFlagEffectWithSpecificLabel(p,flag,label,reset)
	flag=flag&MAX_ID
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_FLAG_EFFECT|flag)}
	for i=#eset,1,-1 do
		local e=eset[i]
		local x=e:GetLabel()
		if not label or x==label then
			if not reset then
				return e
			else
				e:Reset()
			end
		end
	end
	return
end
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
function Card.HasFlagEffectLabel(c,id,...)
	local vals={...}
	if #vals==0 or not c:HasFlagEffect(id) then return false end
	local eset={c:GetFlagEffectLabel(id)}
	for _,label in ipairs({c:GetFlagEffectLabel(id)}) do
		for _,val in ipairs(vals) do
			if label==val then
				return true
			end
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
function Duel.PlayerHasFlagEffectLabel(tp,id,...)
	local vals={...}
	if #vals==0 or Duel.GetFlagEffect(tp,id)==0 then return false end
	for _,label in ipairs({Duel.GetFlagEffectLabel(tp,id)}) do
		for _,val in ipairs(vals) do
			if label==val then
				return true
			end
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
	if not reset then
		reset=RESET_EVENT|RESETS_STANDARD
	elseif reset&RESET_EVENT==0 then
		reset=RESET_EVENT|RESETS_STANDARD|reset
	end
	if not c:IsType(TYPE_EFFECT) then
		local e=Effect.CreateEffect(oc)
		e:SetType(EFFECT_TYPE_SINGLE)
		e:SetCode(EFFECT_ADD_TYPE)
		e:SetValue(TYPE_EFFECT)
		e:SetReset(reset)
		c:RegisterEffect(e,true)
	end
end

--Grant Effect
function Auxiliary.RegisterGrantEffect(c,range,s,o,tg,...)
	local effs={...}
	if #effs==0 then return end
	local returns={}
	for _,e in ipairs(effs) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_GRANT)
		e3:SetRange(range)
		e3:SetTargetRange(s,o)
		e3:SetTarget(tg)
		e3:SetLabelObject(e)
		c:RegisterEffect(e3)
		table.insert(returns,e3)
	end
	return table.unpack(returns)
end
function Auxiliary.RegisterEquipGrantEffect(c,...)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	return aux.RegisterGrantEffect(c,LOCATION_SZONE,LOCATION_MZONE,LOCATION_MZONE,function(_e,_c) return _c==_e:GetHandler():GetEquipTarget() end,...)
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

--For some reason, this function was removed from KPro's core... Redefined it here in order to make customs that use it work as normal
function Group.ForEach(g,f,...)
	for tc in aux.Next(g) do
		f(tc,...)
	end
end

--Hint timing
function Effect.SetRelevantTimings(e,extra_timings)
	if not extra_timings then extra_timings=0 end
	return e:SetHintTiming(extra_timings,RELEVANT_TIMINGS|extra_timings)
end
function Effect.SetRelevantBattleTimings(e,extra_timings)
	if not extra_timings then extra_timings=0 end
	return e:SetHintTiming(RELEVANT_BATTLE_TIMINGS|extra_timings,RELEVANT_BATTLE_TIMINGS|extra_timings)
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
function Effect.SetSpecificLabel(e,l,pos)
	if not pos then pos=1 end
	local tab={e:GetLabel()}
	if pos==0 or #tab<pos then
		if pos~=0 then
			for i=1,pos-#tab-1 do
				table.insert(tab,0)
			end
		end
		table.insert(tab,l)
	else
		tab[pos]=l
	end
	e:SetLabel(table.unpack(tab))
end
function Effect.GetSpecificLabel(e,pos)
	if not pos then pos=1 end
	local tab={e:GetLabel()}
	if #tab<pos then return end
	return tab[pos]
end
function Effect.GetLabelCount(e)
	local tab={e:GetLabel()}
	if not tab then return 0 end
	return #tab
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
function Duel.LoseLP(tp,val)
	return Duel.SetLP(tp,Duel.GetLP(tp)-math.abs(val))
end
function Duel.HalveLP(tp)
	return Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
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
function Card.IsPandemoniumSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_PANDEMONIUM)
end
function Card.IsTimeleapSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_TIMELEAP)
end
function Card.IsBigbangSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_BIGBANG)
end
function Card.IsDriveSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_DRIVE)
end
function Card.IsSelfSummoned(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL+1)
end

--Xyz Materials
function Card.HasCardAttached(c,ac)
	if not c:IsType(TYPE_XYZ) then return false end
	return c:GetOverlayGroup():IsContains(ac)
end
function Card.IsAttachedTo(c,xyzc)
	return c:IsLocation(LOCATION_OVERLAY) and xyzc:HasCardAttached(c)
end
function Group.CheckRemoveOverlayCard(g,tp,ct,r)
	return g:IsExists(Card.CheckRemoveOverlayCard,1,nil,tp,ct,r)
end
function Group.RemoveOverlayCard(g,tp,min,max,r)
	local res=0
	Duel.HintMessage(tp,HINTMSG_REMOVEXYZ)
	local tg=g:FilterSelect(tp,Card.CheckRemoveOverlayCard,1,1,nil,tp,min,r)
	if #tg>0 then
		res=tg:GetFirst():RemoveOverlayCard(tp,min,max,r)
	end
	return res
end
function Duel.GetXyzMaterialGroup(tp,s,o,xyzf,matf,...)
	xyzf=xyzf and xyzf or aux.TRUE
	matf=matf and matf or aux.TRUE
	local sloc=s==1 and LOCATION_MZONE or 0
	local oloc=o==1 and LOCATION_MZONE or 0
	local g=Group.CreateGroup()
	local xyzg=Duel.Group(xyzf,tp,sloc,oloc,nil,...):Filter(Card.IsType,nil,TYPE_XYZ)
	if #xyzg>0 then
		for xyz in aux.Next(xyzg) do
			local matg=xyz:GetOverlayGroup():Filter(matf,nil,...)
			if #matg>0 then
				g:Merge(matg)
			end
		end
	end
	return g
end
function Duel.GetXyzMaterialGroupCount(tp,s,o,xyzf,matf,...)
	local g=Duel.GetXyzMaterialGroup(tp,s,o,xyzf,matf,...)
	return #g
end

function Card.GetPreviousXyzHolder(c)
	local e=c:IsHasEffect(EFFECT_REMEMBER_XYZ_HOLDER)
	if e then
		local xyzc=e:GetLabelObject()
		return xyzc
	end
	return
end

--Zones
function Card.GetZone(c,tp)
	local rzone=0
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		rzone = c:IsControler(tp) and (1<<seq) or (1 << (16+seq))
		if c:IsSequence(5,6) then
			rzone = rzone | (c:IsControler(tp) and (1 << (16+11-seq)) or (1 << (11-seq)))
		end
	elseif c:IsLocation(LOCATION_SZONE) then
		rzone = c:IsControler(tp) and (1 << (8+seq)) or (1 << (24+seq))
	end
	
	return rzone
end
function Card.GetPreviousZone(c,tp)
	local rzone
	if c:IsPreviousLocation(LOCATION_MZONE) then
		rzone = c:IsPreviousControler(tp) and (1 <<c:GetPreviousSequence()) or (1 << (16+c:GetPreviousSequence()))
		if c:GetPreviousSequence()==5 or c:GetPreviousSequence()==6 then
			rzone = rzone | (c:IsPreviousControler(tp) and (1 << (16 + 11 - c:GetPreviousSequence())) or (1 << (11 - c:GetPreviousSequence())))
		end
	
	elseif c:IsPreviousLocation(LOCATION_SZONE) then
		rzone = c:IsPreviousControler(tp) and (1 << (8+c:GetPreviousSequence())) or (1 << (24+c:GetPreviousSequence()))
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
	return cc:GetLinkedZone(c:GetPreviousControler())&c:GetPreviousZone(c:GetPreviousControler())~=0
end
function Card.HasBeenInLinkedZone(c,cc)
	return cc:GetLinkedGroup():IsContains(c) or (not c:IsLocation(LOCATION_MZONE) and cc:GetLinkedZone(c:GetPreviousControler())&c:GetPreviousZone(c:GetPreviousControler())~=0)
end

function Duel.GetMZoneCountFromLocation(tp,up,g,c)
	if c:IsInExtra() then
		return Duel.GetLocationCountFromEx(tp,up,g,c)
	else
		return Duel.GetMZoneCount(tp,g,up)
	end
end
function Duel.GetMZoneCountForMultipleSummons(tp,g,up)
	local ft=Duel.GetMZoneCount(tp,g,up)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		ft=math.min(ft,1)
	end
	return ft
end
		

function Duel.GetDisabledZones(p)
	local dis1,dis2=0,0
	local eset=Duel.GetAuraEffects(EFFECT_DISABLE_FIELD)
	for _,e in ipairs(eset) do
		if e:IsAvailable(false) then
			local hp=e:GetHandlerPlayer()
			local val=e:GetValue()
			dis1=hp==0 and dis1|(val&0x1f7f) or dis1|((val>>16)&0x1f7f)
			dis2=hp==0 and dis2|((val>>16)&0x1f7f) or dis2|(val&0x1f7f)
		end
	end
	if not p then
		return dis1,dis2
	elseif p==0 then
		return dis1
	elseif p==1 then
		return dis2
	end
end

--Location Groups
function Duel.GetHand(p)
	if not p then
		return Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND)
	else
		return Duel.GetFieldGroup(p,LOCATION_HAND,0), Duel.GetFieldGroupCount(p,LOCATION_HAND,0) --compatibility
	end
end
function Duel.GetHandCount(p)
	if not p then
		return Duel.GetFieldGroupCount(0,LOCATION_HAND,LOCATION_HAND)
	else
		return Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	end
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
		return Duel.GetFieldGroupCount(LOCATION_GRAVE)
	end
end
function Duel.GetBanishment(p)
	if not p then
		return Duel.GetFieldGroup(0,LOCATION_REMOVED,LOCATION_REMOVED)
	else
		return Duel.GetFieldGroup(p,LOCATION_REMOVED,0)
	end
end
function Duel.GetBanishmentCount(p)
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

function Auxiliary.CannotBeTributeOrMaterial(c,forced,reset,prop)
	local prop=prop or 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|prop)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	if reset then
		e1:SetReset(reset)
	end
	c:RegisterEffect(e1,forced)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2,forced)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE|prop)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(1)
	if reset then
		e3:SetReset(reset)
	end
	c:RegisterEffect(e3,forced)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4,forced)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5,forced)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6,forced)
end

function Auxiliary.FieldCannotBeTributeOrMaterial(c,range,trange1,trange2,f,exclude)
	exclude = exclude or 0
	if exclude&TYPE_NORMAL==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(range)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetTargetRange(trange1,trange2)
		if f then
			e1:SetTarget(f)
		end
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(range)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetTargetRange(trange1,trange2)
	if f then
		e3:SetTarget(f)
	end
	e3:SetValue(1)
	if exclude&TYPE_FUSION==0 then
		c:RegisterEffect(e3)
	end
	
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	if exclude&TYPE_SYNCHRO==0 then
		c:RegisterEffect(e4)
	end
	
	if exclude&TYPE_XYZ==0 then
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5)
	end
	
	if exclude&TYPE_LINK==0 then
		local e6=e4:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e6)
	end
end

function Auxiliary.PlayerCannotTributeOrUseAsMaterial(c,range,s,o,trange1,trange2,f)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(range)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetTargetRange(s,o)
	if f then
		e1:SetTarget(aux.PlayerCannotTributeTarget(trange1,trange2,f))
	end
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(range)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetTargetRange(trange1,trange2)
	if f then
		e3:SetTarget(f)
	end
	if s~=o then
		e3:SetValue(aux.PlayerCannotUseAsMaterialFilter(s,o))
	else
		e3:SetValue(1)
	end
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
end
function Auxiliary.PlayerCannotTributeTarget(loc1,loc2,f)
	local shared=loc1&loc2
	return	function(e,c,tp)
				local p=e:GetHandlerPlayer()
				return (not f or f(e,c)) and ((shared~=0 and c:IsLocation(shared)) or (c:IsControler(p) and c:IsLocation(loc1)) or (c:IsControler(1-p) and c:IsLocation(loc2)))
			end
end
function Auxiliary.PlayerCannotUseAsMaterialFilter(s,o)
	return	function(e,c)
				if not c then return false end
				local p=s==1 and e:GetHandlerPlayer() or 1-e:GetHandlerPlayer()
				return c:IsControler(p)
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
function Card.IsCanBeSet(c,e,tp,ignore_mzone,ignore_szone,mct)
	mct = mct and mct or 0
	if c:IsMonster() then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and (not ignore_mzone or Duel.GetMZoneCount(tp)>mct)
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
function Duel.IsStartOfBattlePhase(tp)
	local ph=Duel.GetCurrentPhase()
	return (not tp or Duel.GetTurnPlayer()==tp) and ph==PHASE_BATTLE_START
end
function Duel.IsEndPhase(tp)
	return (not tp or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==PHASE_END
end

function Duel.GetNextPhaseCount(ph,p)
	if not ph and not p then return 1 end
	if (not ph or Duel.GetCurrentPhase()==ph) and (not p or Duel.GetTurnPlayer()==p) then
		return 2
	else
		return 1
	end
end
function Duel.GetNextMainPhaseCount(p)
	if Duel.IsMainPhase() and (not p or Duel.GetTurnPlayer()==p) then
		return 2
	else
		return 1
	end
end
function Duel.GetNextBattlePhaseCount(p)
	if Duel.IsBattlePhase() and (not p or Duel.GetTurnPlayer()==p) then
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
	if ch>0 and re:IsActivated() then
		local cid=Duel.GetChainInfo(ch,CHAININFO_CHAIN_ID)
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
	if not c:IsMonster(TYPE_EXTRA|TYPE_PENDULUM|TYPE_PANDEMONIUM) or c:IsHasEffect(EFFECT_CANNOT_TO_DECK) or not Duel.IsPlayerCanSendtoDeck(tp,c) then return false end
	return true
end
function Card.IsAbleToExtraFaceupAsCost(c,p,tp)
	local redirect=0
	local dest=LOCATION_DECK
	if not c:IsMonster(TYPE_PENDULUM|TYPE_PANDEMONIUM) or c:IsLocation(LOCATION_EXTRA) or (tp and c:GetOwner()~=tp)
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

--Place in backrow
function Duel.PlaceAsContinuousCard(g,movep,recp,owner,type,desc,...)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if not desc then
		desc=type==TYPE_SPELL and STRING_TREATED_AS_CONTINUOUS_SPELL or STRING_TREATED_AS_CONTINUOUS_TRAP
	end
	local effs={...}
	local ct=0
	for tc in aux.Next(g) do
		local recp=recp and recp or tc:GetOwner()
		if Duel.MoveToField(tc,movep,recp,LOCATION_SZONE,POS_FACEUP,true) then
			ct=ct+1
			local e1=Effect.CreateEffect(owner)
			e1:SetDescription(desc)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
			e1:SetValue(type|TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			for _,e in ipairs(effs) do
				e:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
				tc:RegisterEffect(e)
			end
		end
	end
	return ct
end

--Reason
function Card.IsReasonPlayer(c,p)
	return c:GetReasonPlayer()==p
end

--redirect
function Card.IsAbleToLocationAsCost(c,loc)
	local loclist={
		[LOCATION_HAND]=Card.IsAbleToHandAsCost;
		[LOCATION_GRAVE]=Card.IsAbleToGraveAsCost;
		[LOCATION_DECK]=Card.IsAbleToDeckAsCost;
		[LOCATION_EXTRA]=Card.IsAbleToExtraAsCost;
		[LOCATION_REMOVED]=Card.IsAbleToRemoveAsCost;
	}
	return loclist[loc](c)
end
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
		
	elseif aux.GetValueType(aux.ProxyEffect)=="Effect" then
		return c:IsRelateToEffect(aux.ProxyEffect)
		
	else
		return _IsRelateToChain(c,...)
	end
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

--RETURN TO GRAVE
function Card.IsAbleToReturnToGrave(c,e,p,r)
	return true --futureproofing
end
function Card.IsAbleToReturnToGraveAsCost(c,e,p)
	return true --futureproofing
end

--Set Backrow
function Auxiliary.SetSuccessfullyFilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE)
end
function Card.MustWaitOneTurnToActivateAfterBeingSet(c)
	return c:IsTrap() or c:IsSpell(TYPE_QUICKPLAY)
end
function Duel.SSetAndFastActivation(p,g,e,cond,brk)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if Duel.SSet(p,g)>0 and (not cond or cond==true or cond(e,p)) then
		local c=e:GetHandler()
		local og=g:Filter(aux.AND(Card.MustWaitOneTurnToActivateAfterBeingSet,aux.SetSuccessfullyFilter),nil)
		if #og>0 and brk then
			Duel.BreakEffect()
		end
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
function Duel.SSetAndRedirect(p,g,e)
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	if Duel.SSet(p,g)>0 then
		local c=e:GetHandler()
		local og=g:Filter(aux.SetSuccessfullyFilter,nil)
		for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(STRING_BANISH_REDIRECT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT|RESETS_REDIRECT_FIELD)
			tc:RegisterEffect(e1,true)
		end
	end
end

--Special Summoning
function Duel.SpecialSummonATK(e,g,styp,sump,tp,ign1,ign2,pos,zone,atk,reset,rc)
	if not zone then zone=0xff end
	if not reset then reset=0 end
	if not rc then rc=e:GetHandler() end
	if aux.GetValueType(g)=="Card" then
		if g==e:GetHandler() and rc==e:GetHandler() then reset=reset|RESET_DISABLE end
		g=Group.FromCards(g)
	end
	local ct=0
	for dg in aux.Next(g) do
		local finalzone=zone
		if type(zone)=="table" then
			finalzone=zone[tp+1]
			if tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone[2-tp]) and (not tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,finalzone) or Duel.SelectYesNo(sump,aux.Stringid(61665245,2))) then
				tp=1-tp
				finalzone=zone[tp+1]
			end
		end
		if Duel.SpecialSummonStep(dg,styp,sump,tp,ign1,ign2,pos,finalzone) then
			ct=ct+1
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset)
			dg:RegisterEffect(e1)
		end
	end
	return Duel.SpecialSummonComplete()
end
function Duel.SpecialSummonNegate(e,g,styp,sump,tp,ign1,ign2,pos,zone,reset,rc)
	if not zone then zone=0xff end
	if not reset then reset=0 end
	if not rc then rc=e:GetHandler() end
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	for dg in aux.Next(g) do
		local finalzone=zone
		if type(zone)=="table" then
			finalzone=zone[tp+1]
			if tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone[2-tp]) and (not tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,finalzone) or Duel.SelectYesNo(sump,aux.Stringid(61665245,2))) then
				tp=1-tp
				finalzone=zone[tp+1]
			end
		end
		if Duel.SpecialSummonStep(dg,styp,sump,tp,ign1,ign2,pos,finalzone) then
			local e1=Effect.CreateEffect(rc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset)
			dg:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(rc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD|reset)
			dg:RegisterEffect(e2,true)
		end
	end
	return Duel.SpecialSummonComplete()
end
function Duel.SpecialSummonRedirect(e,g,styp,sump,tp,ign1,ign2,pos,zone,loc,desc)
	if not zone then zone=0xff end
	if not loc then loc=LOCATION_REMOVED end
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	
	if not desc then
		if loc==LOCATION_REMOVED then
			desc=STRING_BANISH_REDIRECT
		elseif loc==LOCATION_DECKSHF then
			desc=STRING_SHUFFLE_INTO_DECK_REDIRECT
		end
	end
	
	for dg in aux.Next(g) do
		local finalzone=zone
		if type(zone)=="table" then
			finalzone=zone[tp+1]
			if tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone[2-tp]) and (not tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,finalzone) or Duel.SelectYesNo(sump,aux.Stringid(61665245,2))) then
				tp=1-tp
				finalzone=zone[tp+1]
			end
		end
		if Duel.SpecialSummonStep(dg,styp,sump,tp,ign1,ign2,pos,finalzone) then
			local e=Effect.CreateEffect(e:GetHandler())
			e:SetType(EFFECT_TYPE_SINGLE)
			e:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			if desc then
				e:SetDescription(desc)
				e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
			else
				e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			end
			e:SetValue(loc)
			e:SetReset(RESET_EVENT|RESETS_REDIRECT_FIELD)
			dg:RegisterEffect(e,true)
		end
	end
	return Duel.SpecialSummonComplete()
end

function Duel.SpecialSummonATKDEF(e,g,styp,sump,tp,ign1,ign2,pos,zone,atk,def,reset,rc)
	if not zone then zone=0xff end
	if not reset then reset=0 end
	if not rc then rc=e:GetHandler() end
	if aux.GetValueType(g)=="Card" then
		if g==e:GetHandler() and rc==e:GetHandler() then reset=reset|RESET_DISABLE end
		g=Group.FromCards(g)
	end
	for dg in aux.Next(g) do
		local finalzone=zone
		if type(zone)=="table" then
			finalzone=zone[tp+1]
			if tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone[2-tp]) and (not tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,finalzone) or Duel.SelectYesNo(sump,aux.Stringid(61665245,2))) then
				tp=1-tp
				finalzone=zone[tp+1]
			end
		end
		if Duel.SpecialSummonStep(dg,styp,sump,tp,ign1,ign2,pos,finalzone) then
			local e=Effect.CreateEffect(rc)
			e:SetType(EFFECT_TYPE_SINGLE)
			e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e:SetReset(RESET_EVENT|RESETS_STANDARD|reset)
			if atk then
				e:SetCode(EFFECT_SET_ATTACK_FINAL)
				e:SetValue(atk)
				dg:RegisterEffect(e,true)
			end
			if def then
				local e=e:Clone()
				e:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e:SetValue(def)
				dg:RegisterEffect(e,true)
			end
		end
	end
	return Duel.SpecialSummonComplete()
end

SPSUM_MOD_NEGATE   		= 0x1
SPSUM_MOD_REDIRECT 		= 0x2
SPSUM_MOD_CHANGE_ATKDEF	= 0x4

function Duel.SpecialSummonMod(e,g,styp,sump,tp,ign1,ign2,pos,zone,...)
	local mods={...}
	for i,mod in ipairs(mods) do
		if type(mod)=="table" then
			obj=mod[1]
		else
			obj=mod
			mods[i]={0}
		end
		if obj==SPSUM_MOD_NEGATE then
			mods[i][1]={EFFECT_DISABLE,EFFECT_DISABLE_EFFECT}
		elseif obj==SPSUM_MOD_REDIRECT then
			mods[i][1]={EFFECT_LEAVE_FIELD_REDIRECT}
		elseif obj==SPSUM_MOD_CHANGE_ATKDEF then
			mods[i][1]={EFFECT_SET_ATTACK_FINAL,EFFECT_SET_DEFENSE_FINAL}
		end
	end
	
	if not zone then zone=0xff end
	if aux.GetValueType(g)=="Card" then g=Group.FromCards(g) end
	local ct=0
	for dg in aux.Next(g) do
		local finalzone=zone
		if type(zone)=="table" then
			finalzone=zone[tp+1]
			if tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,1-tp,zone[2-tp]) and (not tc:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,tp,finalzone) or Duel.SelectYesNo(sump,aux.Stringid(61665245,2))) then
				tp=1-tp
				finalzone=zone[tp+1]
			end
		end
		
		local c=e:GetHandler()
		local selfchk=#g==1 and g:GetFirst()==c
		
		if Duel.SpecialSummonStep(dg,styp,sump,tp,ign1,ign2,pos,finalzone) then
			ct=ct+1
			for i,mod in ipairs(mods) do
				local code=mod[1]
				
				local val
				if #mod>1 then val=mod[2] end
				
				local reset=#mod>2 and mod[3] or 0
				
				for _,cd in ipairs(code) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(cd)
					if cd==EFFECT_LEAVE_FIELD_REDIRECT then
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
						if not val then
							val=LOCATION_REMOVED
							e1:SetDescription(STRING_BANISH_REDIRECT)
						end
					elseif cd==EFFECT_SET_ATTACK_FINAL or cd==EFFECT_SET_DEFENSE_FINAL then
						if selfchk then
							reset=reset|RESET_DISABLE
						end
						local prop=reset&RESET_DISABLE==0 and EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_CANNOT_DISABLE or EFFECT_FLAG_IGNORE_IMMUNE
						e1:SetProperty(prop)
					end
					if val then
						e1:SetValue(val)
					end
					e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset)
					dg:RegisterEffect(e1)
				end
				
			end
		end
	end
	Duel.SpecialSummonComplete()
	return ct
end

--Special Summon Procedures and After Effect Resolution
SUMMON_VALUE_PRIVATE = 0x1000000

--for usage of ignore_reset, see Dynastygian Launch
function Auxiliary.ApplyEffectImmediatelyAfterResolution(f,c,e,tp,eg,ep,ev,re,r,rp,ignore_reset)
	local chain_end=Duel.GetCurrentChain()==1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCode(chain_end and EVENT_CHAIN_END or EVENT_CHAIN_SOLVED)
	e1:SetLabelObject(e)
	e1:OPT()
	e1:SetOperation(function(_e,_tp,_eg,_ep,_ev,_re,_r,_rp)
		f(e,tp,eg,ep,ev,re,r,rp,_e,chain_end)
		if not ignore_reset then
			_e:Reset()
		end
	end
	)
	e1:SetOwnerPlayer(tp)
	Duel.RegisterEffect(e1,tp)
	return e1
end
function Auxiliary.RegisterResetAfterSpecialSummonRule(c,tp,...)
	local effs={...}
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON)
	e0:SetOperation(function(_e,_tp,_eg,_ep,_ev,_re,_r,_rp)
		for _,e in ipairs(effs) do
			e:Reset()
		end
		_e:Reset()
	end
	)
	Duel.RegisterEffect(e0,tp)
	return e0
end

--Tables
function Auxiliary.TableRemove(t,fnKeep)
    local j, n = 1, #t

    for i=1,n do
        if (fnKeep(t, i, j)) then
            if (i ~= j) then
                t[j] = t[i]
                t[i] = nil
            end
            j = j + 1
        else
            t[i] = nil
        end
    end

    return t;
end


--Tributing
Auxiliary.TributeOppoCostFlag = false
function Auxiliary.EnableGlobalEffectTributeOppoCost()
	if not aux.TributeOppoCostCheck then
		aux.TributeOppoCostCheck=true
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_EXTRA_RELEASE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetCondition(function() return aux.TributeOppoCostFlag end)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,0)
	end
end


--Location Check
EFFECT_CARD_HAS_RESOLVED = 47987298

function Auxiliary.AlreadyInRangeCondition(e,re,se)
	local se=e and e:GetLabelObject():GetLabelObject() or se
	return	function(c,...)
				return se==nil or re~=se
			end
end
function Auxiliary.AlreadyInRangeEventCondition(f)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,f),1,nil,e,tp,eg,ep,ev,re,r,rp)
			end
end
function Auxiliary.AlreadyInRangeFilter(e,f)
	local se=e:GetLabelObject():GetLabelObject()
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

--XYZ
function Card.GetXyzLevel(c,xyzc)
	local eset={c:IsHasEffect(EFFECT_XYZ_LEVEL)}
	if #eset==0 then
		return c:GetLevel()
	else
		local levels={}
		for _,ce in ipairs(eset) do
			local level=ce:Evaluate(c,xyzc)
			local lv1,lv2=level&0xffff,(level>>16)&0xffff
			if not aux.FindInTable(levels,lv1) then
				table.insert(levels,lv1)
			end
			if lv2~=0 and not aux.FindInTable(levels,lv2) then
				table.insert(levels,lv2)
			end
		end
		return table.unpack(levels)
	end
end

-----------------------------------------------------------------------
SCRIPT_REGISTER_FLAG = nil

function Auxiliary.HOPT(oath)
	if oath then
		return {true,false,true}
	else
		return true
	end
end
function Auxiliary.SHOPT(oath)
	if oath then
		return {true,true,true}
	else
		return {true,true}
	end
end

function Card.Ignition(c,desc,ctg,prop,range,ctlim,cond,cost,tg,op,reset,quickcon)
	if not range then range=c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE end
	---
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:Desc(desc)
	end
	if ctg then
		if aux.GetValueType(ctg)=="table" then
			e1:SetCategory(ctg[1])
			if #ctg>1 then
				e1:SetCustomCategory(ctg[2])
			end
		else
			e1:SetCategory(ctg)
		end
	end
	if aux.GetValueType(prop)=="number" and prop~=0 then
		e1:SetProperty(prop)
	end	
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(range)
	if ctlim then
		if type(ctlim)=="boolean" then
			e1:HOPT()
		elseif type(ctlim)=="table" then
			if type(ctlim[1])=="boolean" then
				local shopt=ctlim[2]
				local oath=ctlim[3]
				if shopt then
					e1:SHOPT(oath)
				else
					e1:HOPT(oath)
				end
			else
				local flag=#ctlim>2 and ctlim[3] or 0
				e1:SetCountLimit(ctlim[1],c:GetOriginalCode()+ctlim[2]*100+flag)
			end
		else
			e1:SetCountLimit(ctlim)
		end
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
	if reset then
		e1:SetReset(reset)
	end
	c:RegisterEffect(e1)
	--
	if quickcon then
		local e2=e1:Clone()
		if desc then
			e2:Desc(desc+1)
		end
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		if e1:GetCategory()&(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)>0 then
			local prop = aux.GetValueType(prop)=="number" and prop or 0
			e2:SetProperty(prop+EFFECT_FLAG_DAMAGE_STEP)
			quickcon=aux.AND(quickcon,aux.ExceptOnDamageCalc)
		end
		if ctlim and aux.GetValueType(ctlim)=="number" then
			e1:SetCountLimit(ctlim,EFFECT_COUNT_CODE_SINGLE)
			e2:SetCountLimit(ctlim,EFFECT_COUNT_CODE_SINGLE)
		end
		if cond then
			e2:SetCondition(aux.AND(cond,quickcon))
			e1:SetCondition(aux.NOT(aux.AND(cond,quickcon)))
		else
			e2:SetCondition(quickcon)
			e1:SetCondition(aux.NOT(quickcon))
		end
		c:RegisterEffect(e2)
		return e1,e2
	end
	return e1
end
function Card.Activate(c,desc,ctg,prop,event,ctlim,cond,cost,tg,op,handcon,timing)
	local event = event and event or EVENT_FREE_CHAIN
	---
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:Desc(desc)
	end
	if ctg then
		if aux.GetValueType(ctg)=="table" then
			e1:SetCategory(ctg[1])
			if #ctg>1 then
				e1:SetCustomCategory(ctg[2])
			end
		else
			e1:SetCategory(ctg)
		end
	end
	if prop~=nil then
		e1:SetProperty(prop)
	end	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(event)
	if ctlim then
		if type(ctlim)=="boolean" then
			e1:HOPT()
		elseif type(ctlim)=="table" then
			if type(ctlim[1])=="boolean" then
				local shopt=ctlim[2]
				local oath=ctlim[3]
				if shopt then
					e1:SHOPT(oath)
				else
					e1:HOPT(oath)
				end
			else
				local flag=#ctlim>2 and ctlim[3] or 0
				e1:SetCountLimit(ctlim[1],c:GetOriginalCode()+ctlim[2]*100+flag)
			end
		else
			e1:SetCountLimit(ctlim)
		end
	end
	if timing then
		if type(timing)=="table" then
			e1:SetHintTiming(timing[1],timing[2])
		else
			e1:SetHintTiming(0,timing)
		end
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
	if reset then
		e1:SetReset(reset)
	end
	c:RegisterEffect(e1)
	--
	if handcon and c:GetOriginalType()&(TYPE_QUICKPLAY+TYPE_TRAP)>0 then
		local handcode = c:GetOriginalType()&TYPE_TRAP==0 and EFFECT_QP_ACT_IN_NTPHAND or EFFECT_TRAP_ACT_IN_HAND
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e2:SetRange(LOCATION_HAND)
		e2:SetCondition(handcon)
		c:RegisterEffect(e2)
		return e1,e2
	end
	return e1
end
function Card.Quick(c,forced,desc,ctg,prop,event,range,ctlim,cond,cost,tg,op,timing)
	if not range then range=c:GetOriginalType()&TYPE_FIELD>0 and LOCATION_FZONE or c:GetOriginalType()&TYPE_ST>0 and LOCATION_SZONE or LOCATION_MZONE end
	if not event then event=EVENT_FREE_CHAIN end
	local quick_type=(not forced) and EFFECT_TYPE_QUICK_O or EFFECT_TYPE_QUICK_F
	---
	local e1=Effect.CreateEffect(c)
	if desc then
		e1:Desc(desc)
	end
	if ctg then
		if aux.GetValueType(ctg)=="table" then
			e1:SetCategory(ctg[1])
			if #ctg>1 then
				e1:SetCustomCategory(ctg[2])
			end
		else
			e1:SetCategory(ctg)
		end
	end
	if prop~=nil then
		if aux.GetValueType(prop)=="boolean" and prop==true then
			e1:SetProperty(EFFECT_FLAG_DELAY)
		else
			e1:SetProperty(prop)
		end
	end	
	e1:SetType(quick_type)
	e1:SetCode(event)
	e1:SetRange(range)
	if ctlim then
		if type(ctlim)=="boolean" then
			e1:HOPT()
		elseif type(ctlim)=="table" then
			if type(ctlim[1])=="boolean" then
				local shopt=ctlim[2]
				local oath=ctlim[3]
				if shopt then
					e1:SHOPT(oath)
				else
					e1:HOPT(oath)
				end
			else
				local flag=#ctlim>2 and ctlim[3] or 0
				e1:SetCountLimit(ctlim[1],c:GetOriginalCode()+ctlim[2]*100+flag)
			end
		else
			e1:SetCountLimit(ctlim)
		end
	end
	if timing then
		if type(timing)=="table" then
			e1:SetHintTiming(timing[1],timing[2])
		else
			e1:SetHintTiming(0,timing)
		end
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

function Card.CreateNegateEffect(c,negateact,rp,rf,desc,range,ctlim,cond,cost,tg,negatedop,negatecat)
	local negcategory = negateact and CATEGORY_NEGATE or CATEGORY_DISABLE
	local negcategory2 = (negatecat and negatecat) or (type(negatedop)=="number" and negatedop) or 0
	local negatedop = negatedop or 0
	if c:IsOriginalType(TYPE_MONSTER) then
		local range = range and range or (c:IsOriginalType(TYPE_MONSTER)) and LOCATION_MZONE or (c:IsOriginalType(TYPE_FIELD)) and LOCATION_FZONE or LOCATION_SZONE
		local e1=Effect.CreateEffect(c)
		if desc then
			e1:Desc(desc)
		end
		e1:SetCategory(negcategory+negcategory2)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		if negateact then
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		end
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(range)
		if ctlim then
			if type(ctlim)=="boolean" then
				e1:HOPT()
			elseif type(ctlim)=="table" then
				if type(ctlim[1])=="boolean" then
					local shopt=ctlim[2]
					local oath=ctlim[3]
					if shopt then
						e1:SHOPT(oath)
					else
						e1:HOPT(oath)
					end
				else
					local flag=#ctlim>2 and ctlim[3] or 0
					e1:SetCountLimit(ctlim[1],c:GetOriginalCode()+ctlim[2]*100+flag)
				end
			else
				e1:SetCountLimit(ctlim)
			end
		end
		e1:SetCondition(aux.NegateCondition(true,negateact,rp,rf,cond))
		if cost then e1:SetCost(cost) end
		e1:SetTarget(aux.NegateTarget(negateact,negatedop,tg))
		e1:SetOperation(aux.NegateOperation(negateact,negatedop))
		c:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		if desc then
			e1:Desc(desc)
		end
		e1:SetCategory(negcategory+negcategory2)
		if not range then
			e1:SetType(EFFECT_TYPE_ACTIVATE)
		else
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetRange(range)
		end
		if negateact then
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		end
		e1:SetCode(EVENT_CHAINING)
		if ctlim then
			if type(ctlim)=="boolean" then
				e1:HOPT()
			elseif type(ctlim)=="table" then
				if type(ctlim[1])=="boolean" then
					local shopt=ctlim[2]
					local oath=ctlim[3]
					if shopt then
						e1:SHOPT(oath)
					else
						e1:HOPT(oath)
					end
				else
					local flag=#ctlim>2 and ctlim[3] or 0
					e1:SetCountLimit(ctlim[1],c:GetOriginalCode()+ctlim[2]*100+flag)
				end
			else
				e1:SetCountLimit(ctlim)
			end
		end
		e1:SetCondition(aux.NegateCondition(false,negateact,rp,rf,cond))
		if cost then e1:SetCost(cost) end
		e1:SetTarget(aux.NegateTarget(negateact,negatedop,tg))
		e1:SetOperation(aux.NegateOperation(negateact,negatedop))
		c:RegisterEffect(e1)
	end
end

--FUNCTIONS FOR SPECIAL CARDS
--[[
1) (c) 		= The card that owns the Pyro-Clock-related effect
2) (tp) 	= The player that activated the effect that is currently resolving
3) (p) 		= If the Pyro-Clock-related effect counts turns of a specific player, input that player as (p)
4) (phase)	= The phase in which the Pyro-Clock-related effect advances its count
5) (rct)	= The number of turns that must pass for the Pyro-Clock-related effect to expire
6) (cond)	= Optional additional condition for the advancement of the turn counter
7) (op)		= Optional additional operation for the advancement of the turn counter
8) (...)	= All the Pyro-Clock-related must be passed as extra parameters

For activated effects, remember to set their conditions to aux.FALSE and let this function handle them (see Celestial Ruler of the Zodiac)
]]
function Auxiliary.ManagePyroClockInteraction(c,tp,p,phase,rct,cond,op,...)
	phase=phase and phase or PHASE_END
	rct=rct and rct or 1
	local resetp=0
	if p then
		resetp = p==tp and RESET_SELF_TURN or RESET_OPPO_TURN
	end
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	if phase==PHASE_END and not effectDoesAction then
		e1:SetCode(EVENT_TURN_END)
	else
		e1:SetCode(EVENT_PHASE|phase)
		e1:SetReset(RESET_PHASE|phase|resetp,rct)
	end
	e1:OPT()
	e1:SetCondition(
		function(_e,_tp)
			return (not p or Duel.IsTurnPlayer(p)) and (not cond or cond(_e,_tp))
		end
	)
	e1:SetOperation(aux.PyroClockOperation(rct,op))
	
	local effectDoesAction=false
	local effs_to_reset={...}
	if #effs_to_reset>0 then
		if not aux.EffectsToResetByPyroClock then
			aux.EffectsToResetByPyroClock={}
		end
		aux.EffectsToResetByPyroClock[e1]={}
		for _,re in ipairs(effs_to_reset) do
			if not effectDoesAction and re:IsHasType(EFFECT_TYPE_CONTINUOUS) then
				effectDoesAction=true
			end
			table.insert(aux.EffectsToResetByPyroClock[e1],re)
		end
	end
	
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(CARD_PYRO_CLOCK,RESET_PHASE|phase|resetp,0,rct)
	local s=getmetatable(c)
	s[c]=e1
	
	return e1
end
function Auxiliary.PyroClockOperation(rct,op)
	return	function(e,tp,eg,ep,ev,_re,r,rp)
				local ct=e:GetLabel()
				ct=ct+1
				e:SetLabel(ct)
				e:GetHandler():SetTurnCounter(ct)
				if ct==rct then
					if aux.EffectsToResetByPyroClock[e] then
						while #aux.EffectsToResetByPyroClock[e]>0 do
							local re=aux.EffectsToResetByPyroClock[e][#aux.EffectsToResetByPyroClock[e]]
							if re:IsHasType(EFFECT_TYPE_CONTINUOUS) then
								local reop=re:GetOperation()
								if reop then
									reop(re,tp,eg,ep,ev,_re,r,rp)
								end
							end
							re:Reset()
							table.remove(aux.EffectsToResetByPyroClock[e])
						end
						aux.EffectsToResetByPyroClock[e]=nil
					end
					if op then op(e,tp,eg,ep,ev,re,r,rp) end
					e:GetOwner():ResetFlagEffect(CARD_PYRO_CLOCK)
					e:Reset()
				end
			end
end

--ARCHETYPAL FUNCTIONS

----ILLUSION MONSTERS
function Auxiliary.AddIllusionBattleEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.IllusionBattleEffectTarget)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.IllusionBattleEffectTarget(e,c)
	local h=e:GetHandler()
	return c==h or c==h:GetBattleTarget()
end

----RUM
function Auxiliary.CreateRUMLimitFunction(f)
	return	function(mc,e,tp,c)
				if aux.GetValueType(mc)=="Group" then
					return mc:IsExists(f,1,nil,e,tp,c)
				else
					return f(mc,e,tp,c)
				end
			end
end

----AIRCASTER
function Auxiliary.AddAircasterExcavateEffect(c,ct,typ,desc,id,e,cat,altf)
	if typ==EFFECT_TYPE_TRIGGER_O then
		local e1=Effect.CreateEffect(c)
		e1:Desc(desc)
		e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DECKDES)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetTarget(aux.AircasterExcavateTarget(ct))
		e1:SetOperation(aux.AircasterExcavateOperation(ct))
		c:RegisterEffect(e1)
		local e2=e1:SpecialSummonEventClone(c)
		local e3=e1:FlipSummonEventClone(c)
		return e1,e2,e3
	
	elseif typ==EFFECT_TYPE_QUICK_O then
		if not cat then cat=0 end
		if id==ARCHE_DESPAIRCASTER then cat=cat|CATEGORY_HANDES end
		local e1=Effect.CreateEffect(c)
		e1:Desc(desc)
		e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DECKDES|cat)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_HAND)
		e1:SetRelevantTimings()
		if id==ARCHE_FLAIRCASTER then
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:HOPT(true)
			e1:SetCost(aux.RevealSelfCost())
		end
		e1:SetTarget(aux.AircasterExcavateTarget(ct,typ,id,e))
		e1:SetOperation(aux.AircasterExcavateOperation(ct,typ,id,e,altf))
		c:RegisterEffect(e1)
		return e1
	
	elseif typ==EFFECT_TYPE_IGNITION then
		local e1=Effect.CreateEffect(c)
		e1:Desc(desc)
		e1:SetCategory(CATEGORY_TOGRAVE|CATEGORY_DECKDES)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_MZONE)
		if id then
			e1:SetCost(aux.DetachSelfCost())
		else
			e1:OPT()
		end
		e1:SetTarget(aux.AircasterExcavateTarget(ct))
		e1:SetOperation(aux.AircasterExcavateOperation(ct))
		c:RegisterEffect(e1)
		return e1
	end
end
function Auxiliary.AircasterExcavateFilter(c,altf)
	return c:IsMonster() and ((not altf and c:IsRace(RACE_PSYCHIC)) or (altf and c:IsSetCard(ARCHE_AIRCASTER))) and c:IsAbleToGrave()
end
function Auxiliary.AircasterExcavateTarget(ct,typ,id)
	if not typ or (id and id==ARCHE_FLAIRCASTER) then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanSendtoGrave(tp) end
					Duel.SetTargetPlayer(tp)
					Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
				end
	
	elseif (id and id==ARCHE_DESPAIRCASTER) then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return not c:HasFlagEffect(id) and c:IsDiscardable(REASON_EFFECT) and Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanSendtoGrave(tp) end
					c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1)
					Duel.SetCardOperationInfo(c,CATEGORY_TOGRAVE)
					Duel.SetCardOperationInfo(c,CATEGORY_HANDES)
					Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
				end
	
	elseif typ==EFFECT_TYPE_QUICK_O then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return not c:HasFlagEffect(id) and c:IsAbleToGrave() end
					c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_CHAIN,0,1)
					Duel.SetCardOperationInfo(c,CATEGORY_TOGRAVE)
					Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
				end
	end
end
function Auxiliary.AircasterExcavateOperation(ct,typ,id,ge,altf)
	if (id and id==ARCHE_FLAIRCASTER) then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local p=Duel.GetTargetPlayer()
					if not Duel.IsPlayerCanDiscardDeck(p,ct) then return end
					if ge then
						local eff=ge:Clone()
						eff:SetLabel(e:GetFieldID())
						e:GetHandler():RegisterEffect(eff)
					end
					Duel.ConfirmDecktop(p,ct)
					local g=Duel.GetDecktopGroup(p,ct)
					local sg=g:Filter(aux.AircasterExcavateFilter,nil,altf)
					if #sg>0 then
						Duel.DisableShuffleCheck()
						Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
					end
					Duel.ShuffleDeck(p)
				end
				
	elseif not typ then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local p=Duel.GetTargetPlayer()
					if not Duel.IsPlayerCanDiscardDeck(p,ct) then return end
					if ge then
						local eff=ge:Clone()
						eff:SetLabel(e:GetFieldID())
						Duel.RegisterEffect(eff,tp)
					end
					Duel.ConfirmDecktop(p,ct)
					local g=Duel.GetDecktopGroup(p,ct)
					local sg=g:Filter(aux.AircasterExcavateFilter,nil,altf)
					if #sg>0 then
						Duel.DisableShuffleCheck()
						Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
					end
					Duel.ShuffleDeck(p)
				end
	
	elseif (id and id==ARCHE_DESPAIRCASTER) then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if c:IsRelateToChain() and c:IsDiscardable(REASON_EFFECT) and Duel.SendtoGrave(c,REASON_EFFECT|REASON_DISCARD)>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) then
						if ge then
							local eff=ge:Clone()
							eff:SetLabel(e:GetFieldID())
							Duel.RegisterEffect(eff,tp)
						end
						Duel.BreakEffect()
						Duel.ConfirmDecktop(tp,ct)
						local g=Duel.GetDecktopGroup(tp,ct)
						local sg=g:Filter(aux.AircasterExcavateFilter,nil)
						if #sg>0 then
							Duel.DisableShuffleCheck()
							Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
						end
						Duel.ShuffleDeck(tp)
					end
				end
	
	elseif typ==EFFECT_TYPE_QUICK_O then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if c:IsRelateToChain() and Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsInGY() and Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanSendtoGrave(tp)
					and c:AskPlayer(tp,STRING_ASK_EXCAVATE) then
						if ge then
							local eff=ge:Clone()
							eff:SetLabel(e:GetFieldID())
							Duel.RegisterEffect(eff,tp)
						end
						Duel.BreakEffect()
						Duel.ConfirmDecktop(tp,ct)
						local g=Duel.GetDecktopGroup(tp,ct)
						local sg=g:Filter(aux.AircasterExcavateFilter,nil)
						if #sg>0 then
							Duel.DisableShuffleCheck()
							Duel.SendtoGrave(sg,REASON_EFFECT|REASON_EXCAVATE)
						end
						Duel.ShuffleDeck(tp)
					end
				end
	end
end

function Auxiliary.AddAircasterEquipEffect(c,desc)
	local e1=Effect.CreateEffect(c)
	e1:Desc(desc)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(aux.AircasterEquipCond)
	e1:SetTarget(aux.AircasterEquipTarget)
	e1:SetOperation(aux.AircasterEquipOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.AircasterEquipCond(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetReason()&(REASON_EFFECT|REASON_EXCAVATE)==REASON_EFFECT|REASON_EXCAVATE
end
function Auxiliary.AircasterEquipTarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,c:GetControler(),c:GetLocation())
	if c:IsInGY() then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,c:GetControler(),0)
	end
end
function Auxiliary.AircasterEquipOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToChain() then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if tc:IsFacedown() or not tc:IsRelateToChain() then
		if not c:IsLocation(LOCATION_GB) then
			Duel.SendtoGrave(c,REASON_RULE)
		end
		return
	end
	Duel.EquipToOtherCardAndRegisterLimit(e,tp,c,tc)
end

----DAYLILLY
function Auxiliary.AddDaylillyFusionProcedures(c)
	aux.AddFusionProcFunRep(c,aux.DaylillyFusionMatFilter,2,true)
	local contact_fusion=aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,aux.DaylillyContactFusionOp(c))
	local cond=contact_fusion:GetCondition()
	contact_fusion:SetCondition(aux.DaylillyContactFusionCond(cond))
end
function Auxiliary.DaylillyFusionMatFilter(c)
	return not c:IsFusionType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function Auxiliary.DaylillyContactFusionCond(cond)
	return	function(e,c)
				return (not cond or cond(e,c)) and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_BLACK_GARDEN),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			end 
end
function Auxiliary.DaylillyContactFusionOp(c)
	return  function(g)
				Duel.Release(g,REASON_COST|REASON_MATERIAL)
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(TOKEN_DAYLILLY,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CLIENT_HINT)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD_TOFIELD)
				e1:SetValue(function(e,te) return te:GetHandler():IsCode(CARD_BLACK_GARDEN) end)
				c:RegisterEffect(e1)
			end
end

function Auxiliary.AddDaylillySpSummonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(1)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:HOPT(true)
	e1:SetCost(aux.DaylillySpSummonEffectCost)
	e1:SetTarget(aux.DaylillySpSummonEffectTarget)
	e1:SetOperation(aux.DaylillySpSummonEffectOp)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.DaylillyReleaseFilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsRace(RACE_PLANT)
end
function Auxiliary.DaylillySpSummonEffectCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(aux.DaylillyReleaseFilter,nil)
	if chk==0 then return g:CheckSubGroup(aux.mzctcheckrel,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,aux.mzctcheckrel,false,2,2,tp)
	aux.UseExtraReleaseCount(rg,tp)
	Duel.Release(rg,REASON_COST)
end
function Auxiliary.DaylillySpSummonEffectTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (e:IsCostChecked() or Duel.GetMZoneCount(tp)>0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
end
function Auxiliary.DaylillySpSummonEffectOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsControler(tp) and c:IsLocation(LOCATION_PZONE) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function Auxiliary.AddDaylillyPlacingEffect(c,cond,hopt)
	local e5=Effect.CreateEffect(c)
	e5:Desc(3)
	e5:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	if hopt then
		e5:HOPT(true)
	end
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						return c:IsPreviousLocation(LOCATION_MZONE) and (not cond or cond(e,tp,eg,ep,ev,re,r,rp))
					end)
	e5:SetTarget(aux.DaylillyPlaceInPZoneTarget)
	e5:SetOperation(aux.DaylillyPlaceInPZoneOp)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_RELEASE)
	c:RegisterEffect(e6)
	return e1
end
function Auxiliary.DaylillyPlaceInPZoneTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
	local c=e:GetHandler()
	if c:IsInGY() then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,c:GetControler(),0)
	end
end
function Auxiliary.DaylillyPlaceInPZoneOp(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

----DREAMY/DREARY FOREST
function Auxiliary.AddDreamyDrearyTransformation(c,status)
	local side = status==ARCHE_DREARY_FOREST and SIDE_REVERSE or SIDE_OBVERSE
	local e1=Effect.CreateEffect(c)
	e1:Desc(2)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetCondition(Auxiliary.DreamyDrearyTransformationCondition(status))
	e1:SetTarget(aux.IsCanTransformTargetFunction)
	e1:SetOperation(aux.TransformOperationFunction(side))
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.DreamyDrearyTransformationCondition(status)
	if status==ARCHE_DREARY_FOREST then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.GetTurnPlayer()==tp
				end
	elseif status==ARCHE_DREAMY_FOREST then
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return Duel.GetTurnPlayer()==1-tp
						and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,ARCHE_DREAMY_FOREST,ARCHE_DREARY_FOREST),tp,LOCATION_ONFIELD,0,1,e:GetHandler())
				end
	end
end

----LICH-LORD
function Auxiliary.PhylacteryCondition(e,tp)
	local tp = tp or e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,CARD_LICH_LORD_PHYLACTERY)
end
function Auxiliary.ReversePhylacteryCondition(e,tp)
	local tp = tp or e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_GRAVE,1,nil,CARD_LICH_LORD_PHYLACTERY)
end
function Auxiliary.PhylacteryCheck(tp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,CARD_LICH_LORD_PHYLACTERY)
end

----OSCURION
function Auxiliary.RegisterOscurionDiscardCostEffectFlag(c,e)
	local prop=EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE
	if e:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then prop=prop|EFFECT_FLAG_UNCOPYABLE end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(prop)
	e3:SetCode(CARD_OSCURION_TYPE0)
	e3:SetLabelObject(e)
	e3:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e3)
end
function Auxiliary.RegisterOscurionDriveSummonEffectFlag(c,e)
	local prop=EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE
	if e:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then prop=prop|EFFECT_FLAG_UNCOPYABLE end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(prop)
	e3:SetCode(CARD_OSCURION_TYPE2)
	e3:SetLabelObject(e)
	e3:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e3)
end

----VAISSEAU
function Auxiliary.RegisterVaisseauPendulumEffectFlag(c,pe)
	local prop=EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE
	if pe:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then prop=prop|EFFECT_FLAG_UNCOPYABLE end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(prop)
	e3:SetCode(CARD_ROI_DU_VAISSEAU)
	e3:SetLabelObject(pe)
	e3:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e3)
end
function Auxiliary.VaisseauQECondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==1-tp or c:IsSummonType(SUMMON_TYPE_RITUAL)
end

----VIRAVOLVE
function Auxiliary.AddViravolveDamageEffect(c,id)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local loc=c:GetPreviousLocation()
			return c:IsPreviousLocation(LOCATION_ONFIELD|LOCATION_OVERLAY) and r&REASON_LOST_TARGET==0
		end
	)
	e2:SetOperation(
		function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,id)
			Duel.Damage(1-tp,200,REASON_EFFECT)
		end
	)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local loc=c:GetPreviousLocation()
			return c:IsPreviousLocation(LOCATION_OVERLAY) and r&REASON_LOST_TARGET==0
		end
	)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EVENT_MOVE)
	e6:SetCondition(
		function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local loc=c:GetPreviousLocation()
			return c:IsPreviousLocation(LOCATION_OVERLAY) and r&REASON_LOST_TARGET==0 and c:IsLocation(LOCATION_SZONE)
		end
	)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	return e2,e3,e4,e5,e6,e7
end

----WINTER SPIRIT
function Auxiliary.AddWinterSpiritBattleEffect(c,range)
	if not range then range=LOCATION_MZONE end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(range)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(aux.WinterSpiritBattleEffectCondition)
	e2:SetTarget(aux.WinterSpiritBattleEffectTarget)
	e2:SetValue(aux.WinterSpiritBattleEffectValue)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	return e2,e3
end
function Auxiliary.WinterSpiritBattleEffectCondition(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()
end
function Auxiliary.WinterSpiritBattleEffectTarget(e,c)
	local bc=c:GetBattleTarget()
	return bc and c:HasCounter(COUNTER_ICE) and bc:IsSetCard(ARCHE_WINTER_SPIRIT)
end
function Auxiliary.WinterSpiritBattleEffectValue(e,c)
	return c:GetCounter(COUNTER_ICE)*-200
end

----ZEROST
--[[Scripts the following effect template:
● You can only use 1 "Zerost Moby" effect per turn, and only once that turn.

① If this card is in your hand or GY: You can roll a six-sided die, banish other monsters from your field and/or GY equal to the result, and if you do, Special Summon this card, and if you do that, its ATK/DEF become equal to the number of monsters banished by this effect x 400.
② If this card is banished by the effect of a "Zerost" card: ...]]
function Auxiliary.AddZerostMonsterEffects(c,category,property,target,operation,only_second)
	if not property then property=0 end
	local e1
	if not only_second then
		e1=Effect.CreateEffect(c)
		e1:Desc(0)
		e1:SetCategory(CATEGORY_DICE|CATEGORY_REMOVE|CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
		e1:SHOPT()
		e1:SetTarget(Auxiliary.ZerostFirstMonsterEffectTarget)
		e1:SetOperation(Auxiliary.ZerostFirstMonsterEffectOperation)
		c:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	if category then
		e2:SetCategory(category)
	end
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY|property)
	e2:SetCode(EVENT_REMOVE)
	if not only_second then
		e2:SHOPT()
	else
		e2:HOPT()
	end
	e2:SetCondition(Auxiliary.ZerostSecondMonsterEffectCondition)
	e2:SetTarget(target)
	e2:SetOperation(operation)
	c:RegisterEffect(e2)
	--
	local prop=EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE|EFFECT_FLAG_SET_AVAILABLE
	if e2:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then prop=prop|EFFECT_FLAG_UNCOPYABLE end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(prop)
	e3:SetCode(CARD_ZEROST_BEAST_ZEROTL)
	e3:SetLabelObject(e2)
	e3:SetLabel(c:GetOriginalCode())
	c:RegisterEffect(e3)
	local s=getmetatable(c)
	if s.toss_dice==nil then
		s.toss_dice=true
	end
	return e1,e2
end
function Auxiliary.ZerostFirstMonsterEffectFilter(c,tp,zonechk)
	return (c:IsLocation(LOCATION_MZONE) or c:IsMonster()) and c:IsAbleToRemove() and (not zonechk or Duel.GetMZoneCount(tp,c)>0)
end
function Auxiliary.ZerostFirstMonsterEffectTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.ZerostFirstMonsterEffectFilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,c,tp,true) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE|LOCATION_GRAVE)
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
end
function Auxiliary.ZerostFirstMonsterEffectOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	local g=Duel.Group(aux.NecroValleyFilter(aux.ZerostFirstMonsterEffectFilter),tp,LOCATION_MZONE|LOCATION_GRAVE,0,aux.ExceptThis(c),tp)
	if #g>=dc then
		local rg=Group.CreateGroup()
		if Duel.GetMZoneCount(tp)<=0 then
			Duel.HintMessage(tp,HINTMSG_REMOVE)
			local rg0=g:FilterSelect(tp,function(card,p) return Duel.GetMZoneCount(p,card)>0 end,1,1,nil,tp)
			rg:Merge(rg0)
			g:Sub(rg0)
			dc=dc-1
		end
		if dc>0 then
			Duel.HintMessage(tp,HINTMSG_REMOVE)
			local rg1=g:Select(tp,dc,dc,nil)
			rg:Merge(rg1)
		end
		if #rg>0 then
			Duel.HintSelection(rg)
			local ct=Duel.Banish(rg)
			if ct>0 and c:IsRelateToChain() and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK)
				e1:SetValue(ct*400)
				e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_DISABLE)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE)
				c:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function Auxiliary.ZerostSecondMonsterEffectCondition(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT==0 or not re then return false end
	local rc=re:GetHandler()
	return rc and rc:IsSetCard(ARCHE_ZEROST)
end

function Auxiliary.AddZerostDiceModifier(c,id,etyp)
	if not etyp then etyp=EFFECT_TYPE_IGNITION end
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetType(etyp)
	if etyp==EFFECT_TYPE_QUICK_O then
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetHintTiming(0,RELEVANT_TIMINGS)
	end
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(Auxiliary.RegisterZerostDiceModifier(id))
	c:RegisterEffect(e2)
	return e2
end
function Auxiliary.RegisterZerostDiceModifier(id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_TOSS_DICE_NEGATE)
				e1:SetOperation(Auxiliary.ZerostDiceModifierOperation(id))
				Duel.RegisterEffect(e1,tp)
			end
end
function Auxiliary.ZerostDiceModifierOperation(id)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				if not re or not re:IsActivated() then return end
				if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
					local dc={Duel.GetDiceResult()}
					local ac=1
					local ct=(ev&0xff)+(ev>>16&0xff)
					if ct>1 then
						Duel.Hint(HINT_SELECTMSG,tp,STRING_INPUT_DICE_ROLL)
						local _,idx=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,ct))
						ac=idx+1
					end
					local val=dc[ac]
					local increase=val<6
					local reduce=val>1
					local opt=aux.Option(tp,0,0,{increase,STRING_INCREASE_DICE_RESULT},{reduce,STRING_DECREASE_DICE_RESULT})
					if opt==0 then
						val=val+1
					else
						val=val-1
					end
					dc[ac]=val
					Duel.SetDiceResult(table.unpack(dc))
				end
				e:Reset()
			end
end