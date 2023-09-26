--神光耀我瞳
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	local endcount=0
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		endcount=endcount+g:GetCount()
		local g2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
		if g2~=0 then
			Duel.ConfirmCards(tp,g2)
			endcount=endcount+g2:GetCount()
			if endcount>=1 then
				Duel.Recover(tp,500,REASON_EFFECT)
			end
			if endcount>=3 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			if endcount>=5 then
				local uc=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
				Duel.Remove(uc,POS_FACEUP,REASON_EFFECT)
			end
			if endcount>=7 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_REVERSE_DECK)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,1)
				Duel.RegisterEffect(e2,tp)		
			end
		end
	end
	
end