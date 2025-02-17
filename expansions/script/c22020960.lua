--高速神言
function c22020960.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--self destory
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c22020960.sdcon)
	c:RegisterEffect(e2)
	--activate from hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
function c22020960.sdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1) and c:IsRace(RACE_SPELLCASTER)
end
function c22020960.sdcon(e)
	return not Duel.IsExistingMatchingCard(c22020960.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end