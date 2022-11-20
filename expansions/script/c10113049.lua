--时之轮
function c10113049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10113049.target)
	e1:SetOperation(c10113049.activate)
	c:RegisterEffect(e1)	
end
function c10113049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c10113049.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		e1:SetOperation(c10113049.thop)
		e1:SetLabel(0)
		tc:RegisterEffect(e1)
end
function c10113049.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c10113049.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct,c=e:GetLabel(),e:GetHandler()
	c:SetTurnCounter(ct+1)
	if ct==1 then
		Duel.Hint(HINT_CARD,0,10113049)
		if Duel.SendtoHand(c,tp,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,c)
		   local g=Duel.GetMatchingGroup(c10113049.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,c:GetCode())
		   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10113049,0)) then
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local tc=g:Select(tp,1,1,nil):GetFirst()
			  if not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
				 Duel.SendtoHand(tc,nil,REASON_EFFECT)
				 Duel.ConfirmCards(1-tp,tc)
			  end
		   end
		end
	else e:SetLabel(1) end
end
