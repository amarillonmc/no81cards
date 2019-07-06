--欢迎来到加帕里公园! 
function c33700056.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700056+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.Hint(HINT_MUSIC,0,33700056*16)
	end)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c33700056.cost)
	e1:SetTarget(c33700056.target)
	e1:SetOperation(c33700056.activate)
	c:RegisterEffect(e1)
	 --revive 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(92826944,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c33700056.cost2)
	e2:SetTarget(c33700056.tg)
	e2:SetOperation(c33700056.op)
	c:RegisterEffect(e2)
end
function c33700056.scon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c33700056.sop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(c33700056.hfilter,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	 if e:GetHandler():IsAbleToHand() and e:GetHandler():GetFlagEffect(33700056)==0 and g:GetCount()==g2 and g:GetClassCount(Card.GetCode)==g:GetCount()
	and Duel.SelectYesNo(tp,aux.Stringid(33700068,0)) then
	 Duel.ConfirmCards(1-tp,g)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end  
	e:GetHandler():RegisterFlagEffect(33700056,0,0,1)
end
function c33700056.hfilter(c)
	return not c:IsPublic() and c:IsSetCard(0x442) 
end
function c33700056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
   e:SetLabel(100)
	return true
 end
function c33700056.filter(c,tp)
	return c:IsSetCard(0x442) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c33700056.filter2,tp,LOCATION_DECK,0,1,nil)
end
function c33700056.filter2(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
   and c:IsAbleToHand()
end
function c33700056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c33700056.filter,tp,LOCATION_HAND,0,1,nil,tp)
	end 
	e:SetLabel(0)
	local cg=Duel.GetMatchingGroupCount(c33700056.filter2,tp,LOCATION_DECK,0,nil)
	if cg>3 then cg=3 end
	local g=Duel.SelectMatchingCard(tp,c33700056.filter,tp,LOCATION_HAND,0,1,cg,nil,tp)
	local dg=Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,dg,tp,LOCATION_DECK)
	Duel.SetTargetParam(dg)
end
function c33700056.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700056.filter,tp,LOCATION_DECK,0,ct,ct,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c33700056.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c33700056.thfilter(c)
	return c:IsSetCard(0x442)  and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c33700056.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33700056.thfilter(chkc) end
	if chk==0 then return  Duel.IsExistingTarget(c33700056.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33700056.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function c33700056.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end