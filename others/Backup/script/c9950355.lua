--fate·双神赞歌
function c9950355.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c9950355.condition)
	e1:SetTarget(c9950355.target)
	e1:SetOperation(c9950355.activate)
	c:RegisterEffect(e1)
end
function c9950355.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c9950355.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsType(TYPE_LINK) and c:GetFlagEffect(9950355)==0
end
function c9950355.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9950355.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950355.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9950355.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9950355.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	tc:RegisterFlagEffect(9950355,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc:GetFieldID())
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetCondition(c9950355.actcon)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PIERCE)
			e2:SetCondition(c9950355.effcon)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e3:SetCondition(c9950355.damcon)
			e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e4:SetCondition(c9950355.effcon)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(c9950355.atkcon)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(tc)
	e2:SetCondition(c9950355.discon)
	e2:SetOperation(c9950355.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(tc)
	e3:SetCondition(c9950355.damcon2)
	e3:SetOperation(c9950355.damop)
	Duel.RegisterEffect(e3,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c9950355.descon)
	e5:SetOperation(c9950355.desop)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e5)
end
function c9950355.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c9950355.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c9950355.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c9950355.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsRelateToBattle() and e:GetOwnerPlayer()==tp
end
function c9950355.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,9950355)
	Duel.Destroy(tc,REASON_EFFECT)
end
function c9950355.atkcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c9950355.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=tc:GetFlagEffectLabel(9950355)
	return fid and fid==tc:GetFieldID()
end
function c9950355.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local tc=e:GetLabelObject()
	if not ac or not bc then return end
	if ac~=tc then ac,bc=bc,ac end
	if ac==tc and bc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		bc:RegisterEffect(e2)
	end
end
function c9950355.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid2=tc:GetFlagEffectLabel(9950355)
	local bc=tc:GetBattleTarget()
	return fid2 and fid2==tc:GetFieldID() and tc==eg:GetFirst() and tc:IsRelateToBattle() and bc and bc:GetPreviousControler()==1-tp
end
function c9950355.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if not bc then return end
	local dam=math.max(bc:GetBaseAttack(),0)
	if dam>0 then
		Duel.Hint(HINT_CARD,0,9950355)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
