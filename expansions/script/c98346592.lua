--巫妖的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf7),aux.NonTuner(Card.IsSetCard,0xaf7),1)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(98346592,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c98346592.contg)
	e1:SetOperation(c98346592.conop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98346592,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98346592.rmcon)
	e2:SetTarget(c98346592.rmtg)
	e2:SetOperation(c98346592.rmop)
	c:RegisterEffect(e2)
end
function c98346592.confilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c98346592.contg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c98346592.confilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98346592.confilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c98346592.confilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c98346592.conop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:IsControlerCanBeChanged() then
		if tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0xaf7)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetValue(3000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.GetControl(tc,tp)
	end
end
function c98346592.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98346592.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsAbleToHand() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand and Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemove() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand and Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c98346592.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		if c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			if Duel.GetTurnPlayer()==tp then
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetCondition(c98346592.retcon)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
				e1:SetValue(Duel.GetTurnCount())
			else
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			end
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c98346592.retop)
			Duel.RegisterEffect(e1,tp)
			c:CreateEffectRelation(e1)
		end
	end
end
function c98346592.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():IsRelateToEffect(e)
end
function c98346592.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SpecialSummon(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
end