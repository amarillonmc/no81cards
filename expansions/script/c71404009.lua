--星导之凝忆
if not c71404000 then dofile("expansions/script/c71404000.lua") end
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetCost(yume.stellar_memories.LimitCost)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	--equipped
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2a:SetCode(EFFECT_ACTIVATE_COST)
	e2a:SetRange(LOCATION_SZONE)
	e2a:SetCondition(s.con2a)
	e2a:SetTarget(s.tg2)
	e2a:SetOperation(s.regop2)
	e2a:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e2a)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.chainop)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e2)
	--link summon
	local e3a=Effect.CreateEffect(c)
	e3a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3a:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3a:SetCode(EVENT_REMOVE)
	e3a:SetOperation(s.regop3)
	c:RegisterEffect(e3a)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+100000)
	e3:SetCondition(s.con3)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(yume.stellar_memories.LinkSummonTg)
	e3:SetOperation(yume.stellar_memories.LinkSummonOp)
	c:RegisterEffect(e3)
	yume.stellar_memories.GlobalCheck(c)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.chainfilter)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_EQUIP)
		ge1:SetOperation(s.regop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.chainfilter(c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function s.eqcfilter(c)
	local tc=c:GetEquipTarget()
	return tc and c:IsRace(RACE_SPELLCASTER)
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.eqcfilter,1,nil) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0
end
function s.filter1(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsForbidden()
end
function s.filter1sp(c,e,tp)
	return c:GetOriginalType()&(TYPE_LINK+TYPE_MONSTER)~=0 and Duel.IsPlayerCanDraw(c:GetLink()//4+1) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return false end
		local g1=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g2=Duel.GetMatchingGroup(s.filter1sp,tp,LOCATION_SZONE,0,nil,e,tp)
		return g1:GetCount()>0 and g2:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		if ft>2 then ft=2 end
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil)
		local op_flag=false
		for tc in aux.Next(g) do
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
		if op_flag and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter1sp),tp,LOCATION_SZONE,0,1,1,nil,e,tp)
			local spc=g2:GetFirst()
			if Duel.SpecialSummon(spc,0,tp,tp,false,false,POS_FACEUP)>0 then
				local ct=spc:GetLink()//4+1
				Duel.Draw(tp,ct,REASON_EFFECT)
			end
		end
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.con2a(e)
	local qc=e:GetHandler():GetEquipTarget()
	return qc and qc:IsType(TYPE_RITUAL)
end
function s.tg2(e,te,tp)
	local tc=te:GetHandler()
	if tc:IsLinkState() then
		e:SetLabelObject(tc)
	else return false end
	return true
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.con2(e)
	local qc=e:GetHandler():GetEquipTarget()
	local tc=te:GetHandler()
	return qc and qc:IsType(TYPE_RITUAL) and tc:GetFlagEffect(id)>0
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	local race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE)
	if race&RACE_SPELLCASTER~=0 then
		Duel.SetChainLimit(s.chlimit)
	end
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id+100000,RESET_PHASE+PHASE_END,0,1)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(id+100000)>0
end