--创刻-仙崎秀哉『血之操控』
function c67200052.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionCode,67200050),aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),false)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200052,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200052)
	e1:SetCost(c67200052.sccost)
	e1:SetTarget(c67200052.cttg)
	e1:SetOperation(c67200052.ctop)
	c:RegisterEffect(e1)
	--counter 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200052,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,67200053)
	e2:SetTarget(c67200052.ctg)
	e2:SetOperation(c67200052.cop)
	c:RegisterEffect(e2)
end
function c67200052.scfilter(c)
	return c:IsReleasable() and c:IsSetCard(0x673)
end
function c67200052.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200052.scfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c67200052.scfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Release(tc,REASON_COST)
end
function c67200052.filter(c,tp)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c67200052.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c67200052.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67200052.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200052.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c67200052.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
--
function c67200052.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200052.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x1673,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1673,1)
		tc=g:GetNext()
	end
	if c:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c67200052.val)
		c:RegisterEffect(e1)
	end
end
function c67200052.val(e,c)
	return Duel.GetCounter(0,1,1,0x1673)*200
end
