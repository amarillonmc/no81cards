--奉与授秽者之神祭
function c33332201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c33332201.actg) 
	e1:SetOperation(c33332201.acop) 
	c:RegisterEffect(e1)  
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_RECOVER) 
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(1)
	e2:SetCondition(c33332201.thcon) 
	e2:SetTarget(c33332201.thtg) 
	e2:SetOperation(c33332201.thop) 
	c:RegisterEffect(e2) 
end 
function c33332201.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if Duel.IsExistingTarget(function(c) return c:IsFaceup() and not c:IsCode(33332200) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33332201,0)) then 
		local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and not c:IsCode(33332200) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
	end 
end 
function c33332201.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc and tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_CODE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(33332200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(3)
		tc:RegisterEffect(e2)
	end 
end 
function c33332201.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==1-tp and re and re:GetOwner():IsSetCard(0x3568) 
end 
function c33332201.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return tc and tc:IsAbleToHand(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK) 
end  
function c33332201.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst() 
	if tc then 
		local x=Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,tc)  
		if x>0 and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(33332200) end,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33332201,1)) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)  
		end 
	end 
end 









