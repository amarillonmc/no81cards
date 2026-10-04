--蚀痕无命 刻印
function c62501756.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c62501756.target)
	e1:SetOperation(c62501756.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501756)
	e2:SetTarget(c62501756.thtg)
	e2:SetOperation(c62501756.thop)
	c:RegisterEffect(e2)
	c62501756.remove_event_effect=e2
end
function c62501756.efilter(e)
	local ct=#c62501756.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501756.effect_list[ct+1]=e end
	return false
end
function c62501756.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xea4) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)) then return false end
	e:SetCostCheck(false)
	c62501756.effect_list={}
	c:IsOriginalEffectProperty(c62501756.efilter)
	for _,te in ipairs(c62501756.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c62501756.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and (Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or not e:IsCostChecked()) and Duel.GetFlagEffect(tp,62501756)==0
	local b2=e:IsCostChecked() and Duel.IsExistingMatchingCard(c62501756.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and Duel.GetFlagEffect(tp,62501756+1)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(62501756,0)},
		{b2,aux.Stringid(62501756,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_REMOVE)
		if e:IsCostChecked() then
			Duel.DisableShuffleCheck()
			Duel.Remove(Duel.GetDecktopGroup(tp,3),POS_FACEDOWN,REASON_COST)
		end
		Duel.RegisterFlagEffect(tp,62501756,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,c62501756.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
		Duel.SetTargetCard(sg)
		Duel.RegisterFlagEffect(tp,62501756+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function c62501756.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil):GetFirst()
		if not tc then return end
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(62501756,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(c62501756.retcon)
			e1:SetOperation(c62501756.retop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		if not tc then return end
		c62501756.effect_list={}
		tc:IsOriginalEffectProperty(c62501756.efilter)
		local e_list={}
		for _,te in ipairs(c62501756.effect_list) do
			local tg=te:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501756.effect_list,i) end
		end
		local te=e_list[1]
		if #e_list>1 then
			local des_list={}
			for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
			local op=Duel.SelectOption(tp,table.unpack(des_list))
			te=e_list[op+1]
		end
		c62501756.effect_list={}
		--copy
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		e:SetProperty(0)--Original Property
	end
end
function c62501756.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(62501756)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function c62501756.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	else--if tc:IsPreviousLocation(LOCATION_MZONE) then
		Duel.ReturnToField(tc)
	end
end
function c62501756.thfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501756) and c:IsFacedown() and c:IsAbleToHand()
end
function c62501756.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501756.thfilter,tp,LOCATION_REMOVED,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c62501756.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c62501756.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,1):GetFirst()
	if not tc then return end
	--Duel.HintSelection(Group.FromCards(tc))
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	--if not tc:IsLocation(LOCATION_HAND) or not Duel.SelectYesNo(tp,aux.Stringid(62501756,2)) then return end
end
