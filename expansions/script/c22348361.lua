--绰 影 遗 迹 的 神 秘 研 究
local m=22348361
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348361)
	e1:SetCost(c22348361.cost)
	e1:SetTarget(c22348361.target)
	e1:SetOperation(c22348361.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(22348361)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22349361)
	c:RegisterEffect(e2)
	
	--changeffect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c22348361.cecon)
	e3:SetOperation(c22348361.ceop)
	c:RegisterEffect(e3)
	
end
function c22348361.cecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_REPLACE) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard(0x970a)
end
function c22348361.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:RegisterFlagEffect(22348361,RESET_CHAIN,0,1,1)
end
function c22348361.costfilter(c)
	return c:IsSetCard(0x970a) and c:IsDiscardable()
end
function c22348361.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348361.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c22348361.costfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c22348361.filter(c)
	return c:IsSetCard(0x970a) and c:IsAbleToGrave()
end
function c22348361.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348361.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c22348361.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348361.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
	end
end