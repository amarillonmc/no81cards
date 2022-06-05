--新世坏
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0xfd6)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cos3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetTarget(cm.tg4)
	c:RegisterEffect(e4)
end
--e2
function cm.conf2(c)
	return c:IsSetCard(0xfd6,0x5fd5) and c:IsType(TYPE_MONSTER)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.conf2,1,nil,0xfd6)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	eg=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local n=eg:FilterCount(Card.IsSetCard,nil,0xfd6)+3*eg:FilterCount(Card.IsSetCard,nil,0x5fd5)
	e:GetHandler():AddCounter(0xfd6,n)
end
--e3
function cm.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xfd6,5,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xfd6,5,REASON_COST)
end
function cm.tgf3(c)
	return c:IsSetCard(0x5fd5) and c:IsAbleToHand()
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabel(1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Group.CreateGroup()
	if e:GetLabel()==1 then
		g=Duel.SelectMatchingCard(tp,cm.tgf3,tp,LOCATION_DECK,0,1,1,nil)
	else
		g=Duel.SelectMatchingCard(tp,cm.tgf4,tp,LOCATION_DECK,0,2,2,nil)
	end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e4
function cm.tgf4(c)
	return c:IsSetCard(0xfd6) and c:IsAbleToHand()
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf4,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end