--人理之基 赫拉克勒斯
function c22020510.initial_effect(c)
	c:EnableCounterPermit(0xfed)
	c:SetCounterLimit(0xfed,12)
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