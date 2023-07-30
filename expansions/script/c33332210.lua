--授秽者审判日圣飧
function c33332210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,33332210+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c33332210.activate)
	c:RegisterEffect(e1)  
	--rec 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PHASE+PHASE_END) 
	e2:SetRange(LOCATION_FZONE)   
	e2:SetCountLimit(1) 
	e2:SetCondition(function(e) 
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() end)
	e2:SetTarget(c33332210.rectg) 
	e2:SetOperation(c33332210.recop) 
	c:RegisterEffect(e2) 
	--code 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCondition(c33332210.cdcon)
	e3:SetTarget(c33332210.cdtg) 
	e3:SetOperation(c33332210.cdop) 
	c:RegisterEffect(e3)
end
function c33332210.thfilter(c)
	return c:IsCode(33332200) and c:IsAbleToHand()
end
function c33332210.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33332210.thfilter,tp,LOCATION_ONFIELD+LOCATION_DECK,LOCATION_ONFIELD+LOCATION_DECK,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33332210,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c33332210.rectg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(33332200) end,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil) 
	local rec=g:GetSum(Card.GetAttack) 
	if chk==0 then return rec>0 end   
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end 
function c33332210.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(33332200) end,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil) 
	local rec=g:GetSum(Card.GetAttack) 
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER) 
	if p and rec>0 and Duel.Recover(p,rec,REASON_EFFECT)~=0 and g:FilterCount(Card.IsAbleToHand,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(33332210,1)) then 
		local sg=g:Filter(Card.IsAbleToHand,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end 
end  
function c33332210.cdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReasonPlayer()==1-tp 
end 
function c33332210.cdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c33332210.cdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CHANGE_CODE) 
	e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE) 
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) end) 
	e1:SetValue(33332200) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)  
	Duel.RegisterEffect(e1,tp) 
end 





