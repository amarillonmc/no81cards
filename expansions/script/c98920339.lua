--进化帝·猎龙
function c98920339.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DINOSAUR),2)
	c:EnableReviveLimit()
	--indestructable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e10:SetCondition(c98920339.indcon)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	local e2=e10:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e4=e10:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920339,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c98920339.target)
	e1:SetOperation(c98920339.operation)
	c:RegisterEffect(e1)
end
function c98920339.lkfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_DINOSAUR) or c:IsRace(RACE_REPTILE))
end
function c98920339.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c98920339.lkfilter,1,nil)
end
function c98920339.cfilter(c,g)
	return c:IsType(TYPE_XYZ) and g:IsContains(c)
end
function c98920339.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	s=Duel.SelectOption(tp,aux.Stringid(98920339,0),aux.Stringid(98920339,1))
	e:SetLabel(s)
end
function c98920339.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(98920339,0))
		e1:SetValue(c98920339.aclimit1)
	else
		e1:SetDescription(aux.Stringid(98920339,1))
		e1:SetValue(c98920339.aclimit2)
	end
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c98920339.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c98920339.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end