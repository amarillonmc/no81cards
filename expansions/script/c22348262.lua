--猩 红 庭 院 的 源 血
local m=22348262
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x70a3))
	e2:SetValue(c22348262.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c22348262.indtg)
	e3:SetValue(c22348262.indct)
	c:RegisterEffect(e3)
	--extra summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348262,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x70a3))
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c22348262.reccon)
	e5:SetOperation(c22348262.recop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	
end
function c22348262.atkval(e,c)
	return c:GetLevel()*150
end
function c22348262.indtg(e,c)
	return c:IsFaceup() and (c:IsSetCard(0x70a3) or c:IsCode(22348260))
end
function c22348262.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c22348262.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c22348262.etfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x70a3)
end
function c22348262.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348262.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348262.etfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22348262.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348262)
	local rc=Duel.GetMatchingGroupCount(c22348262.etfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*200
	Duel.Recover(tp,rc,REASON_EFFECT)
end
