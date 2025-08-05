--凝刃之星意
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,s.lcheck)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+TYPE_EQUIP)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.lvtg)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ritual summon
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_REMOVE)
	e3a:SetOperation(s.regop)
	c:RegisterEffect(e3a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,id+100000)
	e3:SetCondition(s.con3)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.RitualUltimateTarget("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_DECK,nil))
	e3:SetOperation(yume.stellar_memories.RitualUltimateOperation("Greater",LOCATION_HAND,LOCATION_ONFIELD+LOCATION_DECK,nil))
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0
		or Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)>0
end
function s.filter1(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.filter1a(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(s.filter1a,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		if ft>2 then ft=2 end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		for tc in aux.Next(g) do
			if Duel.Equip(tp,tc,c) then
				local e1=Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(s.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,s.filter1a,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		local tc=g1:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
end
function s.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL)
end
function s.lvtg(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(id)>0
end