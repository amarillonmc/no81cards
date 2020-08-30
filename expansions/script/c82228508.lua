function c82228508.initial_effect(c)  
	--xyz summon  
	aux.AddXyzProcedure(c,nil,8,2)  
	c:EnableReviveLimit()  
	--disable
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228508,1))  
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(c82228508.discost)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)  
	e1:SetCountLimit(1)  
	e1:SetCondition(c82228508.discon)  
	e1:SetTarget(c82228508.distg)  
	e1:SetOperation(c82228508.disop)  
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetCountLimit(1,82228508)  
	e2:SetCondition(c82228508.thcon)  
	e2:SetTarget(c82228508.target)  
	e2:SetOperation(c82228508.thop)  
	c:RegisterEffect(e2)  
end 
function c82228508.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)  
end  
function c82228508.discon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()  
end  
function c82228508.disfilter(c)  
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsPosition(POS_FACEUP_ATTACK) and not (c:IsAttack(0) and c:IsDisabled())  
end  
function c82228508.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82228508.disfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82228508.disfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,c82228508.disfilter,tp,0,LOCATION_MZONE,1,1,nil)  
end  
function c82228508.disop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetValue(0)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)  
		e2:SetValue(0)  
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e2)  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET) 
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_DISABLE)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e3)  
		local e4=Effect.CreateEffect(c)  
		e4:SetType(EFFECT_TYPE_SINGLE)  
		e4:SetCode(EFFECT_DISABLE_EFFECT)  
		e4:SetValue(RESET_TURN_SET)  
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e4)  
	end  
end
function c82228508.thcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end  
function c82228508.thfilter(c,e,tp)  
	return c:IsSetCard(0x291) and not c:IsCode(82228508)
end   
function c82228508.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82228508.thfilter(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(c82228508.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,c82228508.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end 
function c82228508.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc and tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end  
end  
