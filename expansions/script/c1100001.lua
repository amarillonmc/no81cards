--红绘卷
function c1100001.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_BOTH_BATTLE_DAMAGE)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1100001,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c1100001.con2)
	e2:SetOperation(c1100001.op2)
	c:RegisterEffect(e2)
--
end
--
function c1100001.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetAttack()>=Duel.GetLP(tp)
end
function c1100001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2_1)
end
--