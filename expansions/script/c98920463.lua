--冰结界之龙 圣枪龙
function c98920463.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920463,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,98920463)
	e2:SetCost(c98920463.rmcost)
	e2:SetCondition(c98920463.rmcon)
	e2:SetTarget(c98920463.rmtg)
	e2:SetOperation(c98920463.rmop)
	c:RegisterEffect(e2)
end
function c98920463.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920463.rmfilter(c)
	return c:IsAbleToRemove()
end
function c98920463.costfilter(c,e,tp)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsDiscardable() and c:IsAbleToGraveAsCost()
	else
		return e:GetHandler():IsSetCard(0x2f) and c:IsAbleToRemove() and c:IsHasEffect(18319762,tp)
	end
end
function c98920463.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c98920463.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()-1
	if chk==0 then return Duel.IsExistingMatchingCard(c98920463.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if rt>ct then rt=ct end
	local g=Duel.GetMatchingGroup(c98920463.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=g:SelectSubGroup(tp,c98920463.fselect,false,1,rt)
	e:SetLabel(cg:GetCount())
	local tc=cg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc then
		local te=tc:IsHasEffect(18319762,tp)
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		cg:RemoveCard(tc)
	end
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
end
function c98920463.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local eg=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,ct,0,0)
end
function c98920463.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetCount()*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end