--人理之基 赫拉克勒斯
function c22020510.initial_effect(c)
	c:EnableCounterPermit(0xfed)
	c:SetCounterLimit(0xfed,12)
	aux.AddCodeList(c,22020940)
	--summon with no tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22020510,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c22020510.ntcon)
	e0:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	--Destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c22020510.desreptg)
	e1:SetOperation(c22020510.desrepop)
	c:RegisterEffect(e1)
	--attackup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c22020510.attackup)
	c:RegisterEffect(e2)
end
function c22020510.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020940)
end
function c22020510.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22020510.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c22020510.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xfed)<11 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c22020510.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xfed,1,true)
end
function c22020510.attackup(e,c)
	return c:GetCounter(0xfed)*300
end