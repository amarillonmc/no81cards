--拟态武装 否决立方
function c67200639.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200639,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,67200639)
	e1:SetCondition(c67200639.plcon)
	e1:SetTarget(c67200639.pltg)
	e1:SetOperation(c67200639.plop)
	c:RegisterEffect(e1) 
	--extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCountLimit(1,67200638)
	e2:SetValue(c67200639.matval)
	c:RegisterEffect(e2)	  
end
function c67200639.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x667b)
end
function c67200639.plcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200639.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200639.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200639.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200639,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		--indes
		e2:SetDescription(aux.Stringid(67200639,2))
		e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c67200639.distg)
		e2:SetOperation(c67200639.disop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
	end
end
--
function c67200639.filter1(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200639.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200639.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200639.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200639.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
---
function c67200639.exmfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsCode(67200639)
end
function c67200639.matval(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0x667b) and lc:IsAttribute(ATTRIBUTE_FIRE)) then return false,nil end
	return true,not mg or not mg:IsExists(c67200639.exmfilter,1,nil)
end
