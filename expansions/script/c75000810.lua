--
function c75000810.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xa751),1)
	c:EnableReviveLimit()  

	--position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000810,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75000810.postg)
	e2:SetOperation(c75000810.posop)
	c:RegisterEffect(e2)	
end

--
function c75000810.posfilter(c)
	return c:IsCanChangePosition() and c:IsSetCard(0xa751)
end
function c75000810.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75000810.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75000810.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c75000810.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c75000810.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) then 
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		Duel.BreakEffect()
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		if tc:IsPosition(POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(75000810,5))
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVING)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetOperation(c75000810.disop)
			e1:SetTargetRange(1,1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c75000810.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if Duel.GetFlagEffect(tp,75000810)==0 and Duel.SelectYesNo(tp,aux.Stringid(75000810,3)) then
		Duel.RegisterFlagEffect(tp,75000810,RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev,true)
	end
end