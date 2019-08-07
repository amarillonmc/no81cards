--毁灭之喷射白光
function c10150023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10150023+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c10150023.condition)
	e1:SetTarget(c10150023.target)
	e1:SetOperation(c10150023.activate)
	c:RegisterEffect(e1)	
end
function c10150023.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdd) and c:IsRace(RACE_DRAGON)
end
function c10150023.cfilter2(c)
	return c:IsFaceup() and c:IsCode(23995346)
end
function c10150023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10150023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10150023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=1
	if Duel.IsExistingMatchingCard(c10150023.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10150023.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>=1 then
	   Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end
