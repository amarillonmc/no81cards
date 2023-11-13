--太虚山
function c77002519.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,77002519) 
	e1:SetOperation(c77002519.activate)
	c:RegisterEffect(e1)	
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0x3eef) end)  
	e2:SetValue(300)
	c:RegisterEffect(e2)   
	local e3=e2:Clone() 
	e3:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e3) 
	--activate from hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3eef))
	e4:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e4)
end
function c77002519.thfilter(c)
	return c:IsSetCard(0x3eef) and c:IsAbleToHand()
end
function c77002519.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77002519.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77002519,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end 








