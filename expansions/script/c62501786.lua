--蚀痕无命 命定落印
function c62501786.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(62501786,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c62501786.excost)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c62501786.target)
	e1:SetOperation(c62501786.activate)
	c:RegisterEffect(e1)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SSET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501786)
	e4:SetTarget(c62501786.settg)
	e4:SetOperation(c62501786.setop)
	c:RegisterEffect(e4)
	c62501786.remove_event_effect=e4
end
function c62501786.tdfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckAsCost()
end
function c62501786.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c62501786.tdfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return #g>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	Duel.HintSelection(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c62501786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,62501786)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp,POS_FACEDOWN) and (Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 or not e:IsCostChecked()) and Duel.GetFlagEffect(tp,62501786+1)==0
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(62501786,1)},
		{b2,aux.Stringid(62501786,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.RegisterFlagEffect(tp,62501786,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(0)
		if e:IsCostChecked() then
			Duel.DisableShuffleCheck()
			Duel.Remove(Duel.GetDecktopGroup(tp,3),POS_FACEDOWN,REASON_COST)
		end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
		Duel.RegisterFlagEffect(tp,62501786+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function c62501786.efilter(e)
	local ct=#c62501786.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501786.effect_list[ct+1]=e end
	return false
end
function c62501786.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsSetCard(0xea4) or c:IsControler(1-tp) then return false end
	local te=c.remove_event_effect
	if not te then return false end
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501786.effect_list={}
	c:IsOriginalEffectProperty(c62501786.efilter)
	for _,te in ipairs(c62501786.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end]]
	e:SetCostCheck(check)
	return res
end
function c62501786.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
		Duel.SortDecktop(tp,tp,3)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,POS_FACEDOWN):GetFirst()
		if not tc then return end
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)==0 or not c62501786.cfilter(tc,e,tp,eg,ep,ev,re,r,rp) or not Duel.SelectYesNo(tp,aux.Stringid(62501786,3)) then return end
		--[[c62501786.effect_list={}
		tc:IsOriginalEffectProperty(c62501786.efilter)
		local e_list={}
		for _,te in ipairs(c62501786.effect_list) do
			local tg=te:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501786.effect_list,i) end
		end
		local te=e_list[1]
		if #e_list>1 then
			local des_list={}
			for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
			local op=Duel.SelectOption(tp,table.unpack(des_list))
			te=e_list[op+1]
		end
		c62501786.effect_list={}]]
		local te=tc.remove_event_effect
		--copy
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		e:SetProperty(0)--Original Property
	end
end
function c62501786.setfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501786) and c:IsSSetable()--
end
function c62501786.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501786.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c62501786.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c62501786.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(62501786,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(62501786,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
end
