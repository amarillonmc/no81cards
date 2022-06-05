--梦绽
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400053,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c71400053.tg1)
	e1:SetCost(c71400053.cost1)
	e1:SetOperation(c71400053.op1)
	e1:SetCountLimit(1,71400053+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400053.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function c71400053.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=yume.YumeFieldCheck(tp,0,2,LOCATION_GRAVE) and Duel.IsPlayerCanDraw(tp,1)
	local ct=Duel.GetMatchingGroupCount(c71400053.filterlink1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local b2=yume.IsYumeFieldOnField(tp) and Duel.IsExistingMatchingCard(c71400053.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and ct>0 and g:GetCount()>0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71400053,0),aux.Stringid(71400053,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(71400053,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(71400053,1))+1
	end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1,op) else e:SetLabel(0,op) end
	if op==0 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
	end
end
function c71400053.op1(e,tp,eg,ep,ev,re,r,rp)
	local act,op=e:GetLabel()
	if op==0 then
		if not yume.ActivateYumeField(e,tp,nil,2) then return end
		Duel.BreakEffect()
		if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsSetCard(0x714) and Duel.SelectYesNo(tp,aux.Stringid(71400053,2)) and Duel.IsExistingMatchingCard(c71400053.filterns1,tp,LOCATION_HAND,0,1,nil) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,c71400053.filter2s,tp,LOCATION_HAND,0,1,1,nil)
			local sc=g:GetFirst()
			Duel.Summon(tp,sc,true,nil)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		if act==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local g=Duel.SelectMatchingCard(tp,c71400053.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.ResetFlagEffect(tp,15248873)
		local tc=g:GetFirst()
		if not tc then return end
		local te=tc:GetActivateEffect()
		local b1=tc:IsAbleToHand()
		if act==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
		Duel.BreakEffect()
		local ct=Duel.GetMatchingGroupCount(c71400053.filterlink1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,aux.ExceptThisCard(e))
		if tg:GetCount()>0 then Duel.SendtoGrave(tg,REASON_EFFECT) end
	end
end
function c71400053.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x7714) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function c71400053.filterlink1(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x714)
end
function c71400053.filterns1(c)
	return c:IsSetCard(0x714) and c:IsSummonable(true,nil)
end