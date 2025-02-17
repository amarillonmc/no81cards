--结界守护者 科瑞葛
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--barrier
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.sccon)
	e2:SetCost(cm.sccost)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function cm.actfilter(c,tp)
	return c:IsCode(11451544) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,cm.actfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.cfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.sabcheck(g)
	return g:GetFirst():GetAttribute()&g:GetNext():GetAttribute()>0
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return false end
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
	if chk==0 then return (b1 and g:CheckSubGroup(cm.sabcheck,2,2)) or (b2 and g:CheckSubGroup(aux.dabcheck,2,2)) end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if b1 and b2 then
		sg=g:SelectSubGroup(tp,aux.TRUE,false,2,2)
		if cm.sabcheck(sg) then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
		else
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_HAND)
		end
	elseif b1 then
		sg=g:SelectSubGroup(tp,cm.sabcheck,false,2,2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	elseif b2 then
		sg=g:SelectSubGroup(tp,aux.dabcheck,false,2,2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,1-tp,LOCATION_HAND)
	end
	Duel.SetTargetCard(sg)
end
function cm.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.tfilter,nil,e)
	if #g<2 then return end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsPlayerCanDraw(1-tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_HAND,1,nil)
	if ac:IsAttribute(bc:GetAttribute()) and (ac:GetAttribute()==bc:GetAttribute() or ((b1 or not b2) and Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0)) then
		if Duel.Draw(tp,2,REASON_EFFECT)==2 then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if Duel.Draw(1-tp,1,REASON_EFFECT)==1 then
			Duel.ShuffleHand(1-tp)
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil):Select(1-tp,2,2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end