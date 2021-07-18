--卡西米尔·狙击干员-白金
function c79029092.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
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
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029092)
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
	Duel.SetChainLimit(c79029092.chlimit)
end
function c79029092.chlimit(e,ep,tp)
	return tp==ep
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
	Debug.Message("迎战。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029092,0))
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c79029092.damop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject()==Duel.GetAttacker() then
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c79029092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) end
end
function c79029092.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(79029092,3),aux.Stringid(79029092,4))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(79029092,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(79029092,4))+1
	end
	local p=op==0 and tp or 1-tp
	Debug.Message("很好啊，已经让我十分享受了呢！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029092,1))
	Duel.SortDecktop(tp,p,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if op==0 and g:IsExists(c79029092.ckfil,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029092,5)) then 
	local dg=g:Filter(c79029092.ckfil,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	end
end



