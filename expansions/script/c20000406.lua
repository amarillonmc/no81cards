--赤兽机艺•聚燄
local m=20000406
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000400") end) then require("script/c20000400") end
function cm.initial_effect(c)
	local e1=fu_hd.AttackTrigger(c,cm.Give)
end
function cm.Give(c)
	local tp=c:GetControler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetCondition(cm.atkcon)
	e1:SetValue(3000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(fu_hd.GiveTarget)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end
function cm.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()==e:GetHandler() then
		return true
	end
	return false
end
function cm.atkval(e,c)
	return e:GetHandler():GetDefense()+Duel.GetAttacker():GetDefense()
end