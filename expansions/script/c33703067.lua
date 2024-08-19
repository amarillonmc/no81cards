--他们前来救你了？
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	e:SetLabel(g:GetCount())
	if chk==0 then
		if c:IsLocation(LOCATION_HAND) then
			return g:GetCount()==Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)-1
		else
			return g:GetCount()==Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		end
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabel()~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,e:GetLabel(),nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,e:GetLabel())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.PreserveSelectDeckSequence(true)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,e:GetLabel(),e:GetLabel(),nil)
	Duel.PreserveSelectDeckSequence(false)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.Recover(tp,g:GetCount()*1000,REASON_EFFECT)
	end
end