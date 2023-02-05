--古代的机械重装兵
function c98920048.initial_effect(c)   
 --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c98920048.mfilter,c98920048.xyzcheck,2,2)
		--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920048)
	e1:SetCondition(c98920048.thcon)
	e1:SetTarget(c98920048.thtg)
	e1:SetOperation(c98920048.thop)
	c:RegisterEffect(e1) 
--tograve 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98921048)
	e2:SetCost(c98920048.cost)
	e2:SetTarget(c98920048.target)
	e2:SetOperation(c98920048.operation)
	c:RegisterEffect(e2)  
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c98920048.aclimit)
	e3:SetCondition(c98920048.actcon)
	c:RegisterEffect(e3)
end
function c98920048.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,4) and c:IsRace(RACE_MACHINE)
end
function c98920048.xyzcheck(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x7)
end
function c98920048.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920048.thfilter(c)
	return ((c:IsSetCard(0x7) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(37694547)) and c:IsAbleToHand()
end
function c98920048.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920048.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920048.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920048.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920048.filter(c)
	return c:IsSetCard(0x7) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98920048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920048.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920048.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920048.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetCode()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(code)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)	
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e3:SetValue(tc:GetLevel()*100)
		c:RegisterEffect(e3)
	end
end
function c98920048.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c98920048.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end