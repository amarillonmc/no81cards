--赛博冲浪
local m=21192045
local cm=_G["c"..m]
local setcard=0x3917
local setcard2=0x91b
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.th(c,check)
	return c:IsType(6) and not c:IsCode(m) and c:IsAbleToHand() and ((check and c:IsSetCard(setcard2)) or c:IsSetCard(setcard))
end
function cm.check(c)
	return c:IsSetCard(setcard) and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(cm.th,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.th,tp,LOCATION_DECK,0,1,1,nil,check)
	if #g>0 then
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end