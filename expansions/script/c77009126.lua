--谜之Alterego·Λ
function c77009126.initial_effect(c)
	aux.AddCodeList(c,22702055)  
	--tohand
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,77009126)
	e1:SetCost(c77009126.thcost)
	e1:SetTarget(c77009126.thtg)
	e1:SetOperation(c77009126.thop)
	c:RegisterEffect(e1) 
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)  
	e1:SetCondition(function(e)
	return Duel.IsEnvironment(22702055) end)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1) 
	e2:SetCondition(function(e)
	return Duel.IsEnvironment(22702055) end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	c:RegisterEffect(e3) 
	--atk 
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,17009126)
	e4:SetTarget(c77009126.atktg)
	e4:SetOperation(c77009126.atkop)
	c:RegisterEffect(e4)
end
function c77009126.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c77009126.thfil(c) 
	return ((aux.IsCodeListed(c,22702055) and c:IsType(TYPE_SPELL)) or c:IsCode(22702055)) and c:IsAbleToHand() 
end
function c77009126.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77009126.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77009126.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77009126.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c77009126.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end 
end
function c77009126.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) end,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if c:IsFaceup() and c:IsRelateToEffect(e) and g:GetCount()>0 then 
		local atk=g:GetSum(Card.GetAttack) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1) 
	end
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c77009126.ftarget)
	e0:SetLabel(c:GetFieldID())
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function c77009126.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
