--升 华 魔 法 师
local m=22348155
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c22348155.mfilter,1,1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348155,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22348155)
	e1:SetCondition(c22348155.stcon)
	e1:SetTarget(c22348155.sttg)
	e1:SetOperation(c22348155.stop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22348155.atkval)
	c:RegisterEffect(e2)
	
end
function c22348155.mfilter(c)
	return c:IsSetCard(0x41)
end
function c22348155.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22348155.stfilter(c,tp)
	return c:IsCode(22348156) and c:GetActivateEffect():IsActivatable(tp)
end
function c22348155.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348155.stfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c22348155.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22348155.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
function c22348155.atkfilter(c)
	return c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER)
end
function c22348155.atkval(e,c)
	local g=Duel.GetMatchingGroup(c22348155.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	return g:GetClassCount(Card.GetCode)*500
end

