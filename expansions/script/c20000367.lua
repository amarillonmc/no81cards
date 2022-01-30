--奉神天使 基础
local m=20000367
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.counter(c,CATEGORY_TODECK,EVENT_TO_HAND,EFFECT_FLAG_DELAY,
	function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0
	end,function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.tgf1,nil,tp)
		return g:GetCount()>0
	end,function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.tgf1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end,function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.tgf1,nil,tp)
		if g:GetCount()>0 then 
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		if not Duel.IsPlayerAffectedByEffect(tp,m) then
			Duel.RegisterFlagEffect(tp,20000369,0,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(m)
			e1:SetTargetRange(1,0)
			e1:SetDescription(aux.Stringid(m,0))
			Duel.RegisterEffect(e1,tp)
		end
	end,0)
end
--[[
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0 and Duel.GetLP(tp)>=1000 
		and Duel.IsExistingMatchingCard(function(c)return c:IsFaceup()and c:IsSetCard(0x5fd2)end,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetCurrentPhase()~=PHASE_DRAW
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.PayLPCost(tp,1000)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=eg:Filter(cm.tgf1,nil,tp)
		if chk==0 then return g:GetCount()>0 end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(cm.tgf1,nil,tp)
		if g:GetCount()>0 then 
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
		if not Duel.IsPlayerAffectedByEffect(tp,m) then
			Duel.RegisterFlagEffect(tp,20000369,0,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(m)
			e1:SetTargetRange(1,0)
			e1:SetDescription(aux.Stringid(m,0))
			Duel.RegisterEffect(e1,tp)
		end
	end)
	c:RegisterEffect(e1)
end
--]]
function cm.tgf1(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end