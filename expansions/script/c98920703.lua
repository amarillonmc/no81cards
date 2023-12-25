--龙剑士 威风星·预言
function c98920703.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd0),2,2)
--release replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_RELEASE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98920703.reptg)
	e3:SetValue(c98920703.repval)
	c:RegisterEffect(e3)	
   --cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
end
function c98920703.tgfilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM)
end
function c98920703.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER)
		and (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_EXTRA)
end
function c98920703.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_COST)~=0 and re and re:IsActiveType(TYPE_SPELL)
		and (re:GetHandler():IsSetCard(0xd0) or re:GetHandler():IsCode(76473843)) and Duel.IsExistingMatchingCard(c98920703.tgfilter,tp,LOCATION_DECK,0,1,nil) and eg:IsExists(c98920703.repfilter,1,nil,tp) end
	if Duel.SelectYesNo(tp,aux.Stringid(98920703,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24094258,3))
		local g=Duel.SelectMatchingCard(tp,c98920703.tgfilter,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoExtraP(g,nil,REASON_COST)
		return true
	else return false end
end
function c98920703.repval(e,c)
	return c98920703.repfilter(c,e:GetHandlerPlayer())
end