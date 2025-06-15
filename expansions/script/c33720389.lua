--[[
炼魔改
Fegefeuer-Alter
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:Activation()
	--[[At the start of the Battle Phase: You can target 1 Fusion, Synchro, Xyz or Link Monster you control; at the end of that Battle Phase, take damage equal to that target's original ATK, also apply 1 of the following effects.
	● Banish 1 monster with the same Type and Attribute as that target from your Extra Deck, face-down, and if you do, that target gains ATK/DEF equal to the ATK/DEF of the banished monster until the end of the turn.
	● Banish that target face-down, then Special Summon, from your Extra Deck, a monster with the same card type and Level/Rank/Link Rating as that target. Its effects cannot be activated this turn, also its original ATK/DEF become equal to the banished monster's original ATK/DEF.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_REMOVE|CATEGORIES_ATKDEF|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:OPT()
	e1:SetHintTiming(TIMING_BATTLE_START)
	e1:SetFunctions(s.condition,nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_START
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExists(true,s.filter,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.Select(HINTMSG_TARGET,true,tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,tc:GetBaseAttack())
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetPossibleOperationInfo(0,CATEGORIES_ATKDEF,tc,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_FACEDOWN|RESET_PHASE|PHASE_BATTLE,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:Desc(2,id)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_BATTLE)
		e1:OPT()
		e1:SetFunctions(s.damcon,nil,nil,s.damop)
		e1:SetReset(RESET_PHASE|PHASE_BATTLE)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.damfilter(c)
	return s.filter(c) and c:HasFlagEffect(id)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExists(false,s.damfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.damfilter,tp,LOCATION_MZONE,0,nil)
	local tc
	if #g>1 then
		Duel.HintMessage(tp,HINTMSG_OPERATECARD)
		tc=g:Select(tp,1,1,nil)
	else
		tc=g:GetFirst()
	end
	
	local typ=tc:GetType()&(TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK)
	local rating,race,attr,atk=tc:GetRatingAuto(),tc:GetRace(),tc:GetAttribute(),math.max(0,tc:GetBaseAttack())
	Duel.Damage(tp,atk,REASON_EFFECT)
	
	local c=e:GetHandler()
	local b1=Duel.IsExists(false,s.rmedfilter,tp,LOCATION_EXTRA,0,1,nil,tp,race,attr)
	local b2=tc:IsAbleToRemove(tp,POS_FACEDOWN) and Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,typ,rating,tc)
	local opt=aux.Option(tp,id,3,b1,b2)
	if opt==0 then
		local rc=Duel.Select(HINTMSG_REMOVE,false,tp,s.rmedfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp,race,attr):GetFirst()
		if Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)>0 and rc:IsLocation(LOCATION_REMOVED) and tc:HasFlagEffect(id) and tc:IsFaceup() then
			local ratk,rdef=rc:GetStats()
			tc:UpdateATKDEF(ratk,rdef,RESET_PHASE|PHASE_END,{c,true})
		end
	elseif opt==1 then
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)>0 then
			local sc=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,typ,rating,nil):GetFirst()
			if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(STRING_CANNOT_TRIGGER)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESETS_STANDARD_PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_BASE_ATTACK)
				e2:SetValue(tc:GetTextAttack())
				e2:SetReset(RESET_EVENT|RESETS_STANDARD)
				sc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_SET_BASE_DEFENSE)
				e3:SetValue(tc:GetTextDefense())
				sc:RegisterEffect(e3)
			end
			Duel.SpecialSummonComplete()
		end
	end
	
	local eset={tc:IsHasEffect(EFFECT_FLAG_EFFECT|id)}
	if #eset>0 then
		local fe=eset[1]
		fe:Reset()
	end
end
function s.rmedfilter(c,tp,race,attr)
	return c:IsAttributeRace(attr,race) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function s.spfilter(c,e,tp,typ,rating,rc)
	return c:IsType(typ) and c:GetRatingAuto()==rating and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end