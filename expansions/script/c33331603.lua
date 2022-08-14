--天基兵器 巨人之威
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1,e2 = Rule_SpaceWeapon.initial(c,m,cm.op)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.op_op)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.op_op(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end