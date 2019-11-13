function c125123082.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,125123082+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_CHAIN_END+TIMING_END_PHASE+TIMING_DAMAGE_STEP)
	e1:SetTarget(c125123082.target)
	e1:SetOperation(c125123082.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e4)
end
function c125123082.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c125123082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c125123082.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c125123082.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c125123082.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c125123082.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(125123082,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_BATTLE_DESTROYING)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetLabelObject(tc)
		e2:SetCondition(c125123082.shcon)
		e2:SetTarget(c125123082.shtg)
		e2:SetOperation(c125123082.shop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c125123082.shcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(125123082)~=0
end
function c125123082.shfilter(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c125123082.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c125123082.shfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c125123082.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c125123082.shfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end