--奉神天使 智慧
local m=20000360
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000350") end) then require("script/c20000350") end
function cm.initial_effect(c)
	local e1=fs.counter(c,CATEGORY_NEGATE+CATEGORY_DESTROY,EVENT_CHAINING,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL,
	function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsChainNegatable(ev) and re:GetHandler():GetOriginalType()&0x1>0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end,function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end,function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
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
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetLP(tp)>=1000 
		and Duel.IsExistingMatchingCard(function(c)return c:IsFaceup()and c:IsSetCard(0x5fd2)end,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and re:GetHandler():GetOriginalType()&0x1>0 and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.PayLPCost(tp,1000)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
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