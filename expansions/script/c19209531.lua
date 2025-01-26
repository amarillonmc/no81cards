--判决牢狱的囚犯 07椋原一威
function c19209531.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209531)
	e1:SetCondition(c19209531.setcon)
	e1:SetTarget(c19209531.settg)
	e1:SetOperation(c19209531.setop)
	c:RegisterEffect(e1)
	--monster effect
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCountLimit(1)
	e2:SetCondition(c19209531.atkcon)
	e2:SetOperation(c19209531.atkop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,19209532)
	e3:SetTarget(c19209531.reptg)
	e3:SetValue(c19209531.repval)
	e3:SetOperation(c19209531.repop)
	c:RegisterEffect(e3)
end
function c19209531.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209531.setfilter(c,type)
	return c:IsSetCard(0xb51) and c:IsType(type) and c:IsSSetable()
end
function c19209531.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209531.setfilter,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL) end
end
function c19209531.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c19209531.setfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL):GetFirst()
	if sc then Duel.SSet(tp,sc) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(sc)
	e1:SetOperation(c19209531.rmop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	sc:RegisterFlagEffect(19209531,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(19209531,0))
end
function c19209531.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(19209531)==0 then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c19209531.setfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP):GetFirst()
	if sc then Duel.SSet(tp,sc) end
	sc:RegisterFlagEffect(19209531,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(19209531,0))
end
function c19209531.chkfilter(c)
	return c:IsSetCard(0xb50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c19209531.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle()
		and Duel.IsExistingMatchingCard(c19209531.chkfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function c19209531.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c19209531.chkfilter,tp,LOCATION_EXTRA,0,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c19209531.repfilter(c,tp)
	return c:IsSetCard(0xb50) and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c19209531.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c19209531.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c19209531.repval(e,c)
	return c19209531.repfilter(c,e:GetHandlerPlayer())
end
function c19209531.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,19209531)
end
