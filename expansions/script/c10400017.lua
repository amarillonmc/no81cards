--UESTC·可爱可憎的银杏林
local m=10400017
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to Remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10400017,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10400017)
	e1:SetTarget(c10400017.target1)
	e1:SetOperation(c10400017.operation1)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10400017,2))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,10400017)
	e2:SetTarget(c10400017.target2)
	e2:SetOperation(c10400017.operation2)
	c:RegisterEffect(e2)
end
function c10400017.fliter1(c)
	return c:IsSetCard(0x680) and c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10400017.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10400017.fliter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c10400017.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10400017.fliter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10400017.fliter2(c)
	return c:IsSetCard(0x680) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c10400017.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10400017.fliter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10400017.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10400017.fliter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end