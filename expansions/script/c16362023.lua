--圣殿英雄 飞升之魂
function c16362023.initial_effect(c)
	c:EnableCounterPermit(0xdc0)
	c:SetCounterLimit(0xdc0,6)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c16362023.ctop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16362023,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16362023)
	e2:SetCost(c16362023.imcost)
	e2:SetTarget(c16362023.imtg)
	e2:SetOperation(c16362023.imop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16362023,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,16362123)
	e3:SetCost(c16362023.spcost)
	e3:SetTarget(c16362023.sptg)
	e3:SetOperation(c16362023.spop)
	c:RegisterEffect(e3)
end
function c16362023.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc0)
end
function c16362023.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xdc0,1)
end
function c16362023.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xdc0,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xdc0,2,REASON_COST)
end
function c16362023.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc0)
end
function c16362023.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c16362023.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16362023.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c16362023.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c16362023.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c16362023.op3v)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function c16362023.op3v(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c16362023.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0xdc0,6,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0xdc0,6,REASON_COST)
end
function c16362023.spfilter(c,e,tp)
	return c:IsSetCard(0xdc0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16362023.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16362023.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16362023.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16362023.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16362023.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end