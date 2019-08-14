--乐章之演奏谱
function c60150531.initial_effect(c)
	c:SetUniqueOnField(1,1,60150531)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c60150531.target)
	e2:SetValue(c60150531.tgvalue)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c60150531.target)
	e3:SetValue(c60150531.efilter)
	c:RegisterEffect(e3)
	--summon with no tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150531,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCountLimit(1)
	e4:SetCondition(c60150531.ntcon)
	e4:SetTarget(c60150531.nttg)
	c:RegisterEffect(e4)
end
function c60150531.tgvalue(e,te,re)
	return re~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end
function c60150531.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function c60150531.target(e,c)
	return c:IsFaceup() and c:IsSetCard(0xcb20)
end
function c60150531.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c60150531.nttg(e,c)
	return c:GetLevel()==10 and c:IsSetCard(0xab20)
end