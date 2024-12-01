--终阶解放
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.fil1(c,tp)
	return c:IsFaceup() and c:IsAttack(1800) and c:IsDefense(1600)
		and Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.fil2(c,tc)
	return c:IsAbleToHand() and aux.IsCodeListed(c,tc:GetOriginalCode()) 
		and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local mc=Duel.SelectMatchingCard(tp,cm.fil1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not mc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_DECK,0,1,1,nil,mc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
