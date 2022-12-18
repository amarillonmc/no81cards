--银翼龙契 剑皇布鲁斯
local m=33201259
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201250") end,function() require("script/c33201250") end)
function cm.initial_effect(c)
	VHisc_Dragonk.xyzsm(c,m)	
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetValue(cm.atklimit)
	c:RegisterEffect(e2)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
cm.VHisc_DragonCovenant=true

function cm.atklimit(e,c)
	return c==e:GetHandler()
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if c:GetFlagEffect(m)==0 and c:IsAttackAbove(3600) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_SZONE,nil)
			Duel.Destroy(sg,REASON_EFFECT)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(c:GetCode(),2))
			Duel.Hint(24,0,aux.Stringid(m,3))
		end
	end
end