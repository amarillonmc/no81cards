--罗德岛·辅助干员-格劳克斯·反制电磁脉冲
function c79029212.initial_effect(c)
	c:SetSPSummonOnce(79029212)  
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c79029212.lcheck)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029212.lzcon)
	e1:SetOperation(c79029212.lzop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029212.sptg)
	e2:SetOperation(c79029212.spop)
	c:RegisterEffect(e2)  
end
function c79029212.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xf02)
end
function c79029212.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029212.lzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x1=Duel.AnnounceType(tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c79029212.disable)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetLabel(x1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c79029212.discon)
		e2:SetOperation(c79029212.disop)
		e2:SetLabel(x1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	if not e:GetHandler():GetMaterial():IsExists(Card.IsType,1,nil,TYPE_XYZ) then return end
	if Duel.SelectYesNo(tp,aux.Stringid(79029212,0)) then
	local x2=Duel.AnnounceType(tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetTarget(c79029212.disable)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetLabel(x2)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAIN_SOLVING)
		e4:SetCondition(c79029212.discon)
		e4:SetOperation(c79029212.disop)
		e4:SetLabel(x2)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e4)
end
	Debug.Message("电磁脉冲立场准备就绪。")
end
function c79029212.disable(e,c)
	local x=e:GetLabel()
	if x==0 then
	return c:IsType(TYPE_MONSTER)
	elseif x==1 then
	return c:IsType(TYPE_SPELL)
	elseif x==2 then
	return c:IsType(TYPE_TRAP)
end
end
function c79029212.spfil(c,e,tp)
	return c:IsCode(79029124) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end
function c79029212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029212.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>1 end
	local g=Duel.SelectMatchingCard(tp,c79029212.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c79029212.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=e:GetHandler():GetMaterial()
	Duel.Overlay(tc,e:GetHandler())
	Duel.Overlay(tc,g)
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP_ATTACK)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tx=g1:GetFirst()
	while tx do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tx:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tx:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tx:RegisterEffect(e3)
		tx=g1:GetNext()
end
	Debug.Message("满功率输出！")
end
function c79029212.discon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabel()
	if x==0 then
	return re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():GetControler()~=tp
	elseif x==1 then
	return re:GetHandler():IsType(TYPE_SPELL) and re:GetHandler():GetControler()~=tp
	elseif x==2 then
	return re:GetHandler():IsType(TYPE_TRAP) and re:GetHandler():GetControler()~=tp
end
end
function c79029212.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
