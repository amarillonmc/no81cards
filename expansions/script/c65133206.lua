--幻叙同位体 螟灵「魔法秘银·旅者」
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,s.matfilter,3,99)
	c:EnableReviveLimit()
	--Place Counters
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ctcon)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Move Counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(s.mvcost)
	e2:SetTarget(s.mvtg)
	e2:SetOperation(s.mvop)
	c:RegisterEffect(e2)
	--Grant Effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.granttg)
	local ef1=Effect.CreateEffect(c)
	ef1:SetDescription(aux.Stringid(id,2))
	ef1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	ef1:SetType(EFFECT_TYPE_QUICK_O)
	ef1:SetCode(EVENT_FREE_CHAIN)
	ef1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ef1:SetRange(LOCATION_MZONE)
	ef1:SetCountLimit(1)
	ef1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ef1:SetCost(s.descost)
	ef1:SetTarget(s.destg)
	ef1:SetOperation(s.desop)
	e3:SetLabelObject(ef1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	local ef2=Effect.CreateEffect(c)
	ef2:SetDescription(aux.Stringid(id,3))
	ef2:SetType(EFFECT_TYPE_IGNITION)
	ef2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ef2:SetRange(LOCATION_MZONE)
	ef2:SetCountLimit(1)
	ef2:SetCost(s.cpcost)
	ef2:SetTarget(s.cptg)
	ef2:SetOperation(s.cpop)
	e4:SetLabelObject(ef2)
	c:RegisterEffect(e4)
end
function s.matfilter(c,scard,sumtype,tp)
	return (c:IsRace(RACE_SPELLCASTER) and c:GetAttack()==1550) 
		or c:IsSetCard(0x838)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.cfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1838)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	if c:IsRelateToChain() and c:IsFaceup() and ct>0 then
		c:AddCounter(0x1838,ct)
	end
end
function s.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1838,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1838,1,REASON_COST)
end
function s.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x838) and c:IsCanAddCounter(0x1838,1)
end
function s.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,s.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1838)
end
function s.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		tc:AddCounter(0x1838,1)
	end
end
function s.granttg(e,c)
	return c:GetCounter(0x1838)>0
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttack()>=700 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-700)
	e1:SetReset(RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1838,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1838,1,REASON_COST)
end
function s.cpfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN)
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and s.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and c:IsFaceup() and tc:IsRelateToChain() then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
