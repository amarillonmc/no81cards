--人理之基 李书文
function c22023510.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023510,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,22023510)
	e2:SetTarget(c22023510.rmtg)
	e2:SetOperation(c22023510.rmop)
	c:RegisterEffect(e2)
end
function c22023510.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsCanChangePosition() end
end
function c22023510.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() and tc:IsAttackPos() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
	end
end