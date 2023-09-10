--邪心英雄 恶龙魔
function c77000426.initial_effect(c)
	--race 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_ADD_RACE) 
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE) 
	e1:SetValue(RACE_DRAGON) 
	c:RegisterEffect(e1) 
	--boost
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,77000426)
	e2:SetCost(c77000426.adcost)
	e2:SetTarget(c77000426.adtg)
	e2:SetOperation(c77000426.adop)
	c:RegisterEffect(e2)  
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_REMOVE) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_REMOVE) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,17000426)
	e3:SetTarget(c77000426.rthtg) 
	e3:SetOperation(c77000426.rthop) 
	c:RegisterEffect(e3) 
end
function c77000426.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c77000426.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) 
end
function c77000426.adtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c77000426.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77000426.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77000426.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c77000426.rthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6008) end,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED) 
end 
function c77000426.rthop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6008) end,tp,LOCATION_REMOVED,0,e:GetHandler())
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
	end 
end 







