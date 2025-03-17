--凝宿之星意
if not c71404000 then dofile("expansions/script/c71404000.lua") end
function c71404004.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c71404004.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71404004,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_GRAVE_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCountLimit(1,71404004)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetCondition(c71404004.con1)
	e1:SetTarget(c71404004.tg1)
	e1:SetOperation(c71404004.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c71404004.con2)
	e2:SetValue(c71404004.atlimit)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	--banish from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71404004,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,71504004)
	e3:SetCost(c71404004.cost3)
	e3:SetTarget(c71404004.tg3)
	e3:SetOperation(c71404004.op3)
	c:RegisterEffect(e3)
	--[[ritual summon
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_REMOVE)
	e3a:SetOperation(c71404004.regop)
	c:RegisterEffect(e3a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71404004,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,71504004)
	e3:SetCondition(c71404004.con3)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_DECK,LOCATION_HAND +LOCATION_ONFIELD,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_DECK,LOCATION_HAND+LOCATION_ONFIELD,nil))
	c:RegisterEffect(e3)
	--]]
	yume.stellar_memories.GlobalCheck(c)
end
function c71404004.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_RITUAL)
end
function c71404004.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c71404004.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function c71404004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71404004.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71404004.MultiRitualToDeckFilter(c)
	return yume.stellar_memories.RitualIncludeCheck(c)
		and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToDeck()
		and c:IsFaceupEx()
end
function c71404004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op_flag=false
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71404004.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c71404004.eqlimit)
				tc:RegisterEffect(e1)
				op_flag=true
				
			end
		end
	end
	if op_flag then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		::cancel::
		local mat_location=LOCATION_GRAVE+LOCATION_REMOVED
		local summon_location=LOCATION_GRAVE+LOCATION_REMOVED
		local greater_or_equal="Greater"
		local msg=aux.Stringid(71404004,1)
		local mg=Duel.GetMatchingGroup(c71404004.MultiRitualToDeckFilter,tp,mat_location,0,nil)
		mg=mg:Filter(yume.stellar_memories.MultiRitualSelectToUseFilter,nil,e,tp,summon_location,Card.GetLink,greater_or_equal)
		if mg:GetCount()==0 or not Duel.SelectYesNo(tp,msg) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local mat=mg:Select(tp,1,1,nil)
		local mc=mat:GetFirst()
		local sg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualSelectToSummonFilter,tp,summon_location,0,mc,e,tp,mc,Card.GetLink,greater_or_equal)
		if sg:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		--Ritual Summon 1 monster with ritual Level
		local b1=sg:IsExists(yume.stellar_memories.MultiRitualRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
		--Ritual Summon 1+ monsters with Link Rating
		local b2=sg:IsExists(yume.stellar_memories.MultiRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(71404000,4))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Filter(yume.stellar_memories.MultiRitualRitualLevelCheck,nil,mc,Card.GetLink,greater_or_equal):SelectUnselect(nil,tp,false,true,1,1)
			if not tc then goto cancel end
			tc:SetMaterial(mat)
			Duel.SendtoDeck(mc,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			local lv=mc:GetLink()*2
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			aux.GCheckAdditional=yume.stellar_memories.MultiRitualCheckAdditional(lv)
			local tg=sg:SelectSubGroup(tp,yume.stellar_memories.MultiRitualFSelect,true,1,ft,tp,lv)
			aux.GCheckAdditional=nil
			if not tg then goto cancel end
			local tc=tg:GetFirst()
			while tc do
				tc:SetMaterial(mat)
				tc=tg:GetNext()
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.BreakEffect()
			tc=tg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
				tc=tg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c71404004.eqlimit(e,c)
	return e:GetOwner()==c
end
function c71404004.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL)
end
function c71404004.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLinkState()
end
--[[
function c71404004.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(71404004)>0
end
--]]
function c71404004.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function c71404004.filter3(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove(tp)
end
function c71404004.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404004.filter3,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c71404004.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71404004.filter3,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end