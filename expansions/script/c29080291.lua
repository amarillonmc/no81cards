--方舟骑士-临光
local cm,m,o=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.tg3)
	e3:SetValue(cm.val3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)	
end
cm.kinkuaoi_recoveraks=true
--e3
function cm.tgf3(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsLocation(LOCATION_MZONE) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.tgf3,1,nil,tp) and c:IsPosition(POS_FACEUP_ATTACK) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.val3(e,c)
	return cm.tgf3(c,e:GetHandlerPlayer())
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	Duel.Recover(tp,e:GetHandler():GetAttack(),REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end
