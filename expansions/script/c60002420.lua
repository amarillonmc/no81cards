--万世流涌大典
function c60002420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetOperation(c60002420.operation)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetTarget(c60002420.srtg) 
	e2:SetOperation(c60002420.srop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--set
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e4:SetCode(EVENT_REMOVE) 
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c60002420.setcon) 
	e4:SetOperation(c60002420.setop) 
	c:RegisterEffect(e4) 
end
function c60002420.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCost(c60002420.rmcost)
	e1:SetTarget(c60002420.rmtg) 
	e1:SetOperation(c60002420.rmop) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1) 
end 
function c60002420.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil,POS_FACEDOWN) end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil,POS_FACEDOWN) 
	Duel.Remove(g,POS_FACEDOWN,REASON_COST) 
end 
function c60002420.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if chk==0 then return tc and tc:IsAbleToRemove(POS_FACEDOWN) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_DECK)
end  
function c60002420.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	if tc then 
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) 
	end 
end 
function c60002420.pbfil(c,e,tp) 
	return not c:IsPublic() and c:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c60002420.thfil,tp,LOCATION_DECK,0,1,nil,c:GetCode())  
end 
function c60002420.thfil(c,code) 
	if not (c:IsAbleToHand() and c:IsSetCard(0x6622) and c:IsType(TYPE_MONSTER)) then return false end 
	if code==nil then 
	return true 
	else 
	return not c:IsCode(code) end 
end 
function c60002420.srtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60002420.pbfil,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(60002420)==0 end
	e:GetHandler():RegisterFlagEffect(60002420,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	local tc=Duel.SelectMatchingCard(tp,c60002420.pbfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
	Duel.ConfirmCards(1-tp,tc) 
	local code=tc:GetCode()
	e:SetLabel(code) 
	Duel.ShuffleHand(tp) 
end 
function c60002420.srop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local code=e:GetLabel() 
	if Duel.IsExistingMatchingCard(c60002420.thfil,tp,LOCATION_DECK,0,1,nil,code) then 
		local sg=Duel.SelectMatchingCard(tp,c60002420.thfil,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end 
function c60002420.stfil(c,tp) 
	return c:GetReasonPlayer()==tp and c:IsFacedown() 
end 
function c60002420.setcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c60002420.stfil,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c60002420.thfil,tp,LOCATION_DECK,0,1,nil,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==1-tp 
end 
function c60002420.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c60002420.setcon(e,tp,eg,ep,ev,re,r,rp) then  
		if Duel.SelectEffectYesNo(tp,c,aux.Stringid(60002420,0)) then  
			Duel.Hint(HINT_CARD,0,60002420) 
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			c60002420.srop(e,tp,eg,ep,ev,re,r,rp)  
		end 
	end 
end 

