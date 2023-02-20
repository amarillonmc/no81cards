--雾动机龙·南方巨兽龙
function c98920338.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98920338.matfilter,2)
--extra pendulum summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920338,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c98920338.excon)
	e1:SetValue(c98920338.pendvalue)
	c:RegisterEffect(e1)
--Search
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920338.thcon)
	e3:SetTarget(c98920338.thtg)
	e3:SetOperation(c98920338.thop)
	c:RegisterEffect(e3)
end
function c98920338.matfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c98920338.pendvalue(e,c)
	return c:IsSetCard(0xd8)
end
function c98920338.excon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4
end
function c98920338.thcfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0xd8)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_PZONE)
end
function c98920338.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsSetCard(0xd8)
end
function c98920338.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920338.thcfilter,1,nil,tp)
end
function c98920338.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c98920338.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c98920338.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c98920338.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end