--键★断片 -  佳乃·星 / Frammenti K.E.Y - Kano -STELLA-
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--lower ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetCondition(s.retcon)
	e4:SetTarget(s.rettg)
	e4:SetOperation(s.retop)
	c:RegisterEffect(e4)
	--lingering effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(s.lpcon)
	e5:SetOperation(s.lpop)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		--custom damage function
		_Damage = Duel.Damage
		function Duel.Damage(tp,ct,r,is_step)
			if Duel.IsPlayerAffectedByEffect(tp,id) then
				local e1=Effect.GlobalEffect()
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_REVERSE_DAMAGE)
				e1:SetTargetRange(1,0)
				e1:SetValue(1)
				e1:SetReset(RESET_CHAIN)
				Duel.RegisterEffect(e1,tp)
				Duel.Hint(HINT_CARD,tp,id)
				local res = _Damage(tp,math.ceil(ct/2),r,is_step)
				e1:Reset()
				return res
			end
			return _Damage(tp,ct,r,is_step)	
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0 and (r&REASON_BATTLE+REASON_EFFECT+REASON_COST)~=0
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if tc:RegisterEffect(e1)~=0 and not tc:IsImmuneToEffect(e1) and tc:GetAttack()==0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			if (tc:IsType(TYPE_EFFECT) and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
			end
			if tc:GetDefense()>0 then
				Duel.Recover(tp,tc:GetDefense(),REASON_EFFECT)
			end
		end
	end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsRelateToBattle()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	bc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,bc:GetControler(),bc:GetLocation())
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToEffect(e) then
		bc:ReleaseEffectRelation(e)
		if (aux.nzatk(bc) or aux.nzdef(bc)) and Duel.IsChainDisablable(0) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local val=math.max(bc:GetAttack(),bc:GetDefense())*2
			Duel.Recover(tp,val,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	if bc and bc:IsRelateToBattle() then
		Duel.SendtoDeck(bc,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT+REASON_BATTLE)~=0
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
		Duel.NegateEffect(0)
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetCondition(s.rdcon)
	e2:SetOperation(s.rdop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e5=e1:Clone()
	e5:SetCode(id)
	Duel.RegisterEffect(e5,tp)
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(ep,math.ceil(ev/2),REASON_EFFECT)
	Duel.ChangeBattleDamage(ep,0)
end