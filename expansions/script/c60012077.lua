-- 绯色贵公子·迪翁
Duel.LoadScript("c60001511.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(1600)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DEFENSE_ATTACK)
	e3:SetValue(1)
	e3:SetCondition(s.atkcon)
	c:RegisterEffect(e3)
end
s.listed_series={0x5624}
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local def=c:GetDefense()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.drtg)
	e1:SetValue(500)
	Duel.RegisterEffect(e1,tp)
	if def>=1700 then
		byd.AddSummonCount(e,tp)
	end
	if def>=3700 then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
function s.drtg(e,c)
	return c:IsRace(RACE_DRAGON)
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end
