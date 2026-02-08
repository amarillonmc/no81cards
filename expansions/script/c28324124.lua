--三分之一
function c28324124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28324124.target)
	e1:SetOperation(c28324124.activate)
	c:RegisterEffect(e1)
end
function c28324124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler() or nil
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,exc) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function c28324124.activate(e,tp,eg,ep,ev,re,r,rp)
	local exc=e:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.ExceptThisCard(e) or nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,exc)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,0,1,nil)
	if gg:GetCount()~=0 then
		g:Merge(gg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,0,1,nil)
		if dg:GetCount()~=0 then g:Merge(dg) end
	end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(28324124,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(28324124,0))
	end
	og:KeepAlive()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetLabel(fid)
	e0:SetLabelObject(og)
	e0:SetCountLimit(1)
	e0:SetCondition(c28324124.thcon)
	e0:SetOperation(c28324124.thop)
	--e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c28324124.thfilter(c,fid)
	return c:GetFlagEffectLabel(28324124)==fid and c:IsAbleToHand()
end
function c28324124.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c28324124.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c28324124.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,28324124)
	local g=e:GetLabelObject()
	local sg=g:Filter(c28324124.thfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	local ct=sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*3050)
end
