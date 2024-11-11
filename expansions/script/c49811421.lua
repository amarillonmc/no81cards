--封印の鎖
function c49811421.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811421,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,49811421)
	e3:SetCondition(c49811421.spcon)
	e3:SetCost(c49811421.cost)
	e3:SetTarget(c49811421.sptg)
	e3:SetOperation(c49811421.spop)	
	c:RegisterEffect(e3)
	--to deck and draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811421,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c49811421.tdcon)
	e4:SetTarget(c49811421.tdtg)
	e4:SetOperation(c49811421.tdop)
	c:RegisterEffect(e4)
end
function c49811421.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetCurrentChain()<=2
end
function c49811421.filter(c)
	return c:IsCode(49811421,8058240) and c:IsAbleToRemoveAsCost()
end
function c49811421.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811421.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c49811421.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	e:SetLabelObject(g:GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c49811421.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811421.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local nc=re:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	    if tc:IsType(TYPE_NORMAL) then
	    	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e1:SetTarget(c49811421.distg)
			e1:SetLabelObject(nc)
			e1:SetReset(RESET_PHASE+PHASE_END,1)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c49811421.discon)
			e2:SetOperation(c49811421.disop)
			e2:SetLabelObject(nc)
			e2:SetReset(RESET_PHASE+PHASE_END,1)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c49811421.distg(e,c)
	local nc=e:GetLabelObject()
	return c:IsOriginalCodeRule(nc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c49811421.discon(e,tp,eg,ep,ev,re,r,rp)
	local nc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(nc:GetOriginalCodeRule())
end
function c49811421.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c49811421.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c49811421.tdfilter(c,sc,attr)
	return c:IsAbleToDeck() and c:IsType(TYPE_NORMAL)
end
function c49811421.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811421.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811421.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c49811421.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end