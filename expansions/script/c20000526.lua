--堕魔凰充能
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000516,m)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.conf(c)
	return c:IsCode(20000516) and c:IsFaceup()
end
function cm.tgf1(c)
	return c:IsAbleToRemove() and not c:IsPublic()
end
function cm.tgf2(c)
	return (c:IsSetCard(0x3fd5) or c:IsSetCard(0xfd6)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToHand() 
end
function cm.tgf3(g)
	return aux.dncheck(g) and g:IsExists(Card.IsSetCard,1,nil,0xfd6) and g:IsExists(Card.IsSetCard,1,nil,0x3fd5)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conf,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgf2,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_HAND,0,1,nil) and g:CheckSubGroup(cm.tgf3,2,99) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	if g:GetCount()==0 then return end
	local sg=Duel.GetMatchingGroup(cm.tgf2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	sg=sg:SelectSubGroup(tp,cm.tgf3,false,2,2)
	if sg and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

