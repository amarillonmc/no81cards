--牙牙我们走
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410013)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--rmv
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
	return aux.IsCodeListed(c,23410013) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=3
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		--Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if chk==0 then return Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,tp,LOCATION_DECK)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local num=3
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	if Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)~=num then return end
	local g=Duel.GetDecktopGroup(1-tp,num)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end