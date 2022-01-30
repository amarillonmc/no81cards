--奉神天使 王冠
local m=20000359
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.counter(c,CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY,EVENT_SUMMON,0,function(e,tp,eg,ep,ev,re,r,rp)return Duel.GetCurrentChain()==0 end,
	function(e,tp,eg,ep,ev,re,r,rp)
		return true
	end,function(e,tp,eg,ep,ev,re,r,rp)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	end,function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
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
	end,EVENT_SPSUMMON)
end
--[[
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0 and Duel.GetLP(tp)>=1000 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 
		and not Duel.IsExistingMatchingCard(function(c)return c:IsFacedown()or not c:IsRace(RACE_FAIRY)end,tp,LOCATION_MZONE,0,1,nil)
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.PayLPCost(tp,1000)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
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
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
--]]