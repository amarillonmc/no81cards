--苍波的水将 库忒瑞亚
function c33200730.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c33200730.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200730,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,33200730)
	e1:SetCondition(c33200730.spcon)
	e1:SetTarget(c33200730.sptg)
	e1:SetOperation(c33200730.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200730,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,33200731)
	e2:SetCondition(c33200730.ccon)
	e2:SetTarget(c33200730.ctg)
	e2:SetOperation(c33200730.cop)
	c:RegisterEffect(e2)
end
function c33200730.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc32a)
end

--e1
function c33200730.spfilter(c)
	return c:IsSetCard(0xc32a) and c:IsFaceup() and c:IsAbleToRemove()
end
function c33200730.thfilter(c)
	return c:IsSetCard(0xc32a) and c:IsAbleToHand()
end
function c33200730.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33200730.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33200730.spfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c33200730.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c33200730.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c33200730.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(33200730,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c33200730.retcon)
		e1:SetOperation(c33200730.retop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		tc:RegisterFlagEffect(33200730,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
		Duel.RegisterEffect(e1,tp)
		if Duel.IsExistingMatchingCard(c33200730.thfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200730,2)) then
			local sg=Duel.SelectMatchingCard(tp,c33200730.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
			local thtc=sg:GetFirst()
			Duel.HintSelection(thtc)
			Duel.SendtoHand(thtc,nil,REASON_EFFECT)
		end
	end
end
function c33200730.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(33200730)~=0 and e:GetLabelObject():IsLocation(LOCATION_REMOVED)
end
function c33200730.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end

--e2
function c33200730.ccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c33200730.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32a,2)
end
function c33200730.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c33200730.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33200730.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c33200730.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x32a)
end
function c33200730.cop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x32a,2)
	end
end
