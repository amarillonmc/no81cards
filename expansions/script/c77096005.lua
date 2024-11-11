--伊丽莎白·巴托里
function c77096005.initial_effect(c)
	aux.AddCodeList(c,77096005) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77096005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,77096005)
	e1:SetTarget(c77096005.thtg)
	e1:SetOperation(c77096005.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--atk 
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c77096005.atktg) 
	e2:SetOperation(c77096005.atkop) 
	c:RegisterEffect(e2) 
end
function c77096005.thfilter(c)
	return aux.IsCodeListed(c,77096005) and not c:IsCode(77096005) and c:IsAbleToHand()
end
function c77096005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77096005.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77096005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77096005.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c77096005.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end  
end 
function c77096005.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		local atk=200 
		if tc:IsControler(1-tp) then atk=-200 end   
		e1:SetValue(atk) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end 
 







