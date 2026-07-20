-- 憧憬的铁锤·阿尔梅达
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.mfilter,1)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1b)
end
function s.mfilter(c,lc,sumtype,tp)
	return c:GetCounter(0x624)>0 and not c:IsType(TYPE_LINK)
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end