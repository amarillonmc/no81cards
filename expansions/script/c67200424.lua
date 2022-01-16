--术结天缘 渴望魔精
function c67200424.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedureLevelFree(c,c67200424.mfilter,nil,2,99)   
	--destroy & search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200424,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c67200424.sptg)
	e1:SetOperation(c67200424.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c67200424.atkval)
	c:RegisterEffect(e2)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200424,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c67200424.pencon)
	e5:SetTarget(c67200424.pentg)
	e5:SetOperation(c67200424.penop)
	c:RegisterEffect(e5) 
end
--
function c67200424.mfilter(c,xyzc)
	return c:IsSetCard(0x5671)
end
--
function c67200424.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c67200424.deckfilter(c)
	return c:IsSetCard(0x5671)
end
function c67200424.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c67200424.filter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200424.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if tc:IsSetCard(0x5671) then
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200424,4))
		local gg=Duel.SelectMatchingCard(tp,c67200424.filter,tp,LOCATION_EXTRA,0,1,2,nil,c)
		Duel.Overlay(c,gg)
	end
end
--
function c67200424.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	local ag=Group.Filter(g,Card.IsSetCard,nil,0x5671)
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
--
function c67200424.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200424.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200424.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


