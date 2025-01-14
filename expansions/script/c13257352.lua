--超时空世界 无现里
local m=13257352
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--c:EnableCounterPermit(0x352)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--[[
	--Add counter2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(cm.addop2)
	c:RegisterEffect(e2)
	]]
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1,TAMA_THEME_CODE+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(cm.recon)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.ctcon)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.ctcon1)
	e4:SetOperation(cm.ctop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	elements={{"theme_effect",e2}}
	cm[c]=elements
	
end
function cm.recon(e,tp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(TAMA_THEME_CODE)
	e1:SetTargetRange(1,0)
	e1:SetValue(m)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(cm.ctcon2)
	e2:SetOperation(cm.ctop2)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsCanAddCounter(0x351,1) and c:IsControler(tp)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x351,1)
		tc=g:GetNext()
	end
end
--[[
function cm.ctfilter1(c,tp)
	return c:IsFaceup() and c:IsCanAddCounter(0x352,1) and c:IsControler(tp)
end
function cm.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x352,e:GetHandler():GetCounter(0x352),true)
		tc=g:GetNext()
	end
	e:GetHandler():RemoveCounter(tp,0x352,0,REASON_EFFECT)
end
]]
function cm.ctfilter1(c,tp)
	return c:IsFaceup() and c:IsCanAddCounter(0x352,4) and c:IsControler(tp)
end
function cm.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter1,1,nil,tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter1,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x352,4)
		tc=g:GetNext()
	end
end
function cm.ctfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x351) and (c:IsCanAddCounter(0x351,1) or c:IsCanAddCounter(0x352,2)) and c:IsControler(tp)
end
function cm.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter2,1,nil,tp)
end
function cm.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter2,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x351,1)
		tc:AddCounter(0x352,2)
		tc=g:GetNext()
	end
end
function cm.addop2(e,tp,eg,ep,ev,re,r,rp)
	local count=0
	local c=eg:GetFirst()
	while c~=nil do
		if not c:IsCode(m) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) then
			count=count+c:GetCounter(0x352)
		end
		c=eg:GetNext()
	end
	if count>0 then
		e:GetHandler():AddCounter(0x352,count)
	end
end
