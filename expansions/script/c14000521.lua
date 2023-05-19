--抉择之地·生命之森
local m=14000521
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetRange(0xff)
	e2:SetCondition(cm.abdcon)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetRange(0xff)
	e3:SetValue(cm.aclimit)
	c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		e:SetCategory(CATEGORY_RECOVER)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(cm.activate)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2000)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.RegisterFlagEffect(tp,m,0,0,0)
		else
			return
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
		if Duel.GetFlagEffect(tp,m)==0 then
			Duel.RegisterFlagEffect(tp,m,0,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(m)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			Duel.RegisterEffect(e1,tp)
		else
			return
		end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function cm.check()
	return Duel.IsPlayerAffectedByEffect(tp,m) and Duel.GetFlagEffect(tp,m)~=0
end
function cm.abdcon(e)
	local at=Duel.GetAttackTarget()
	return cm.check() and (at==nil or at:IsAttackPos() or Duel.GetAttacker():GetAttack()>at:GetDefense())
end
function cm.aclimit(e,re,tp)
	return cm.check() and not re:GetHandler():IsType(TYPE_FIELD) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end