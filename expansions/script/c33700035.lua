--Protoform Cosplay - Kotori
function c33700035.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--ret&draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c33700035.cost)
	e1:SetTarget(c33700035.target)
	e1:SetOperation(c33700035.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(33700035,ACTIVITY_CHAIN,c33700035.chainfilter)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetValue(LOCATION_GRAVE)
	e2:SetTarget(c33700035.tg)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c33700035.sccon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e4)
end
function c33700035.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x6440) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetCode()~=33700035
end
function c33700035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33700035,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetValue(c33700035.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33700035.aclimit(e,re,tp)
	return re:GetHandler():IsSetCard(0x6440) and re:IsActiveType(TYPE_MONSTER) and  re:GetHandler()~=e:GetLabelObject()
end
function c33700035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c33700035.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c33700035.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c33700035.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33700035.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		local cg=Duel.Draw(tp,1,REASON_EFFECT)
	   if cg==0 then return end
	   local dc=Duel.GetOperatedGroup():GetFirst()
	if (dc:IsSetCard(0x6440) or dc:IsSetCard(0x3440))
	 and Duel.SelectYesNo(tp,aux.Stringid(33700035,0)) then
	 Duel.ConfirmCards(1-tp,dc)
	 Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
	end
end
function c33700035.tg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c33700035.sccon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0x3440)
end
