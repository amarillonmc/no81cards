--圣树修正者 绮望
function c67200984.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200984,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200984)
	e1:SetTarget(c67200984.thtg)
	e1:SetOperation(c67200984.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,c:GetAttribute()))
	e2:SetValue(c67200984.indval)
	c:RegisterEffect(e2) 
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c67200984.val)
	c:RegisterEffect(e2) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c67200984.tgfilter)
	e3:SetValue(c67200984.efilter)
	c:RegisterEffect(e3)  
end
function c67200984.thfilter(c)
	return c:IsSetCard(0x67a) and c:IsAbleToHand()
end
function c67200984.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200984.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200984.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200984.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local tc=g:GetFirst()
		if Duel.ConfirmCards(1-tp,g)~=0 and e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(67200984,2)) then
			Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(tc:GetOriginalAttribute())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
--
function c67200984.val(e,c)
	local g=Duel.GetMatchingGroup(c67200984.atkfilter,c:GetControler(),LOCATION_MZONE,0,c)
	local ag=Group.Filter(g,Card.IsAttribute,c,c:GetAttribute())
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetBaseAttack()
		x=x+y
		tc=ag:GetNext()
	end
	return x
end
function c67200984.atkfilter(c)
	return c:IsSetCard(0x67a) and c:IsFaceup()
end
function c67200984.tgfilter(e,c)
	return c:IsSetCard(0x67a) and c:IsAttribute(e:GetHandler():GetAttribute())
end
function c67200984.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
