local m=53707009
local cm=_G["c"..m]
cm.name="清响 沉水观"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.Peacecho(c)
	SNNM.AllGlobalCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.effcon)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
end
function cm.hspfilter(c,tp)
	return c:IsRace(RACE_PLANT) and Duel.GetMZoneCount(tp,c)>0
end
function cm.hspcon(e,c)
	if c==nil then return true end
	if c:IsLocation(LOCATION_DECK) and c:IsFacedown() then return end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroup(tp,cm.hspfilter,1,nil,tp)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsRace(RACE_PLANT)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e3,true)
	end
end
