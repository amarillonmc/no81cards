--星芒之凝忆
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.con2)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.chainfilter)
end
function s.chainfilter(c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function s.filter1(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and yume.stellar_memories.BanishorSendSpellCheck(71404016,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
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
	yume.stellar_memories.BanishorSendSpell(71404016,tp,aux.Stringid(id,2),aux.Stringid(id,3))
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_LINK)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function s.lv_or_lk(c)
	if c:IsType(TYPE_LINK) then return c:GetLink()
	else return c:GetLevel() end
end
function s.atkval(e,c)
	return Duel.GetMatchingGroup(s.atkfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetSum(s.lv_or_lk)*100
end
function s.filter3(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter3),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end