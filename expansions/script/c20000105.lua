--暴轮的煌印
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000101") end) then require("script/c20000101") end
function cm.initial_effect(c)
	local e1={fu_judg.E(c,1000,0)}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg2)
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
--e2
function cm.tg2(e,c)
	return c:IsCode(20000100)
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c,bc=Duel.GetBattleMonster(e:GetHandlerPlayer())
	if not (c and bc) then return false end
	return c:IsCode(20000100) and (c:IsRelateToBattle() or c:IsStatus(STATUS_BATTLE_DESTROYED))
		and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local a,bc=Duel.GetBattleMonster(e:GetHandlerPlayer())
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(bc)
	e1:SetOperation(cm.op3op1)
	c:RegisterEffect(e1)
end
function cm.op3op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetLabelObject(),EVENT_CUSTOM+m,re,r,rp,ep,ev)
	e:Reset()
end
--e5
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg:GetFirst(),1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if not eg:GetFirst():IsRelateToBattle() then return end
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end