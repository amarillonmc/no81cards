--星芒之凝忆
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function c71404007.initial_effect(c)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
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
	--link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+100000)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.LinkSummonTg)
	e3:SetOperation(yume.stellar_memories.LinkSummonOp)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.chainfilter)
end
function s.chainfilter(c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function s.filter1(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)>0
end
function s.filter1sp(c,e,tp,ct)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:GetLink()<=ct*2 and c:IsFaceupEx() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return false end
		local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp)
		local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(s.filter1sp,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,ct)
		return yume.stellar_memories.QuickDualSelectCheck(g1,g2,{{1,2},{1,1}})
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=nil
		local ct=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			g2=Group.CreateGroup()
		else
			g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1sp),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,ct)
		end
		if ft>2 then ft=2 end
		local sg1,sg2=yume.stellar_memories.QuickDualSelect(tp,g1,g2,{{1,ft},{1,1}},HINTMSG_EQUIP,HINTMSG_SPSUMMON,s.opf,c,tp)
		if sg2:GetCount()==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1sp),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,ct)
		end
		if sg2:GetCount()>0 then
			Duel.BreakEffect()
			local spc=sg2:GetFirst()
			Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)
			ct=math.ceil(spc:GetLink()/2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local bg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,ct,nil,tp)
			if bg:GetCount()>0 then
				Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function s.opf(sg,c,tp)
	local op_flag=false
	for tc in aux.Next(sg) do
		if Duel.Equip(tp,tc,c) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			tc:RegisterEffect(e1)
			op_flag=true
		end
	end
	return op_flag
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_LINK)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsRace(RACE_SPELLCASTER)
end
function s.lv_or_lk(c)
	if c:IsType(TYPE_LINK) then return c:GetLink()
	else return c:GetLevel() end
end
function s.atkval(e,c)
	return Duel.GetMatchingGroup(s.atkfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetSum(s.lv_or_lk)*100
end