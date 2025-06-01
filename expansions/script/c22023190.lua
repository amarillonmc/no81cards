--大黑天的饭团
function c22023190.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023190+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023190.rectg)
	e1:SetOperation(c22023190.recop)
	c:RegisterEffect(e1)
end
function c22023190.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023190.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rec=Duel.GetMatchingGroupCount(c22023190.filter1,tp,LOCATION_MZONE,0,nil)*500
	if chk==0 then return rec>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c22023190.filter(c)
	return c:IsFaceup() and c:IsCode(22023120)
end
function c22023190.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023190.recop(e,tp,eg,ep,ev,re,r,rp)
	rec=Duel.GetMatchingGroupCount(c22023190.filter1,tp,LOCATION_MZONE,0,nil)*500
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local tg1=Duel.GetMatchingGroupCount(c22023190.filter1,tp,LOCATION_MZONE,0,nil)
	local tg2=Duel.GetMatchingGroupCount(c22023190.filter,tp,LOCATION_ONFIELD,0,nil)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and tg1>0 and tg2>0 and Duel.SelectYesNo(tp,aux.Stringid(22023190,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,c22023190.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			e1:SetValue(rec)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
			e2:SetValue(rec)
			tc:RegisterEffect(e2)
		end
	end
end
