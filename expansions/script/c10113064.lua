--三重闪
function c10113064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCountLimit(1,10113064+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10113064.condition)
	e1:SetTarget(c10113064.target)
	e1:SetOperation(c10113064.activate)
	c:RegisterEffect(e1)   
end
function c10113064.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c10113064.filter2,tp,LOCATION_MZONE,0,2,c,c:GetRace())
end
function c10113064.filter2(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c10113064.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10113064.filter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c10113064.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and Duel.IsPlayerCanDraw(tp,1) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10113064.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   Duel.Draw(tp,1,REASON_EFFECT)
	end
end