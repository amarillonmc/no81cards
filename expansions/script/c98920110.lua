--侵略的意志
function c98920110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c98920110.condition)
	e1:SetTarget(c98920110.target)
	e1:SetOperation(c98920110.activate)
	c:RegisterEffect(e1)
end
function c98920110.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x100a)
end
function c98920110.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98920110.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98920110.filter(c,tp)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c98920110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98920110.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920110.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c98920110.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c98920110.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end