--冰汽时代 决斗场
local m=33502211
local cm=_G["c"..m]
Duel.LoadScript("c33502200.lua")
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.reccon)
	e1:SetOperation(cm.recop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
end
--e1
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function cm.filter0(c,tp)
	return c:IsFaceup() and c:IsAttackable()
end
function cm.filter(c,tp)
	return c:IsFaceup() 
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local bg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_MZONE,0,nil,tp)
	local bg2=Duel.GetMatchingGroup(cm.filter,1-tp,LOCATION_MZONE,0,nil,tp)
	if #bg1>0 and #bg2>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	   local sg1=bg1:Select(tp,1,1,nil):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RESOLVECARD)
	   local sg2=bg2:Select(1-tp,1,1,nil):GetFirst()
	   Duel.CalculateDamage(sg1,sg2)
	else
	   if #bg1==0 then Duel.SetLP(tp,Duel.GetLP(tp)-1000) end
	   if #bg2==0 then Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000) end
	end
end
--e2
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsControler(tp)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(1000)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e0)
end
