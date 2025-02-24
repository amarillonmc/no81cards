--缠身的月影－孔斯
function c11900067.initial_effect(c)
	aux.AddCodeList(c,11900061)
	c:EnableReviveLimit()
	--to grave  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,11900067)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) end)
	e1:SetTarget(c11900067.tgtg) 
	e1:SetOperation(c11900067.tgop) 
	c:RegisterEffect(e1) 
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_REMOVE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(function(e,c,tp,r,re)   
	return re and r==REASON_EFFECT and c:IsSummonLocation(LOCATION_GRAVE) and c:IsLocation(LOCATION_MZONE) and c:IsControler(e:GetHandlerPlayer()) end) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end) 
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_REMOVE) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(function(e,c)   
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(e:GetHandlerPlayer()) end) 
	e3:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end) 
	c:RegisterEffect(e3)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetTarget(c11900067.actarget)
	e5:SetCost(c11900067.costchk)
	e5:SetOperation(c11900067.costop)
	e5:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end) 
	c:RegisterEffect(e5)
	--accumulate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_FLAG_EFFECT+11900067)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) end) 
	c:RegisterEffect(e6)
end
function c11900067.tgfil(c) 
	return c:IsAbleToGrave() and (c:IsCode(11900061) or (aux.IsCodeListed(c,11900061) and c:IsType(TYPE_SPELL)))   
end 
function c11900067.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c11900067.tgfil,tp,LOCATION_DECK,0,1,nil) end  
	if e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then 
		e:SetLabel(1) 
	else 
		e:SetLabel(0) 
	end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c11900067.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,11900061) and c:IsType(TYPE_MONSTER) 
end 
function c11900067.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11900067.tgfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(dg,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(c11900067.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11900067,0)) then 
			Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c11900067.thfil,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg)  
		end 
	end 
end  
function c11900067.actarget(e,te,tp) 
return te:IsHasType(EFFECT_TYPE_ACTIVATE)  
end
function c11900067.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,11900067)
	return Duel.CheckLPCost(tp,ct*800)
end
function c11900067.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,800)
end