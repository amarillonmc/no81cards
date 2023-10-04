--虚拟YouTuber 电脑少女小白
local m=33700347
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2,nil,nil,99)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdcon)
	e4:SetCost(Senya.RemoveOverlayCost(1))
	e4:SetTarget(cm.atktg)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(m)>=4
	end)
	c:RegisterEffect(e4)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23232295,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) e:GetHandler():RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1) end)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(m)>=2
	end)
	e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ChangeBattleDamage(ep,ev*2)
	end)
	c:RegisterEffect(e5)
end
function cm.con(ct,con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetRemovedOverlayCount()>=ct and (not con or con(e,tp,eg,ep,ev,re,r,rp))
	end
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToBattle() end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
end