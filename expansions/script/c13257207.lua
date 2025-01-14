--巨舰护罩充能
local m=13257207
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(cm.atcost)
	e4:SetOperation(cm.atop)
	c:RegisterEffect(e4)
	
end
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x353) and c:IsControler(tp)
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tama.cosmicBattleship_equipShield(tc,2)
		tc=g:GetNext()
	end
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and c:IsStatus(STATUS_EFFECT_ENABLED) end
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.ctcon)
	e1:SetOperation(cm.ctop1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tama.cosmicBattleship_equipShield(tc,1)
		tc=g:GetNext()
	end
end
