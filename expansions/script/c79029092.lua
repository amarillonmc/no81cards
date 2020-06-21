--卡西米尔·狙击干员-白金
function c79029092.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--atk change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,79029092)
	e1:SetCondition(c79029092.atcon)
	e1:SetTarget(c79029092.attg)
	e1:SetOperation(c79029092.atop)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7902909299999)
	e2:SetTarget(c79029092.target)
	e2:SetOperation(c79029092.operation)
	c:RegisterEffect(e2)
end
function c79029092.atcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:GetAttack()>e:GetHandler():GetAttack()
end
function c79029092.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,chkc,1,0,0)
end
function c79029092.atop(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e1)
	if d then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c79029092.damop)
	e3:SetLabelObject(a)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
	Duel.Destroy(c:GetBattleTarget(),REASON_EFFECT)
end
function c79029092.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject()==Duel.GetAttacker() then
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c79029092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
end
function c79029092.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(69394324,0),aux.Stringid(69394324,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(69394324,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(69394324,1))+1
	end
	local p=op==0 and tp or 1-tp
	Duel.SortDecktop(tp,p,5)
end