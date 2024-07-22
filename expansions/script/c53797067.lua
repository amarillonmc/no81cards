local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.tdcon)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 and g:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.tgfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and g:IsContains(c) and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if og:IsContains(c) then
			for tc in aux.Next(Group.__sub(og,c)) do tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID()) end
		end
		local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
		if #og>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=tg:Select(tp,1,1,nil):GetFirst()
			if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,c:GetFieldID()) end
		end
	end
end
function s.trigfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsControler(tp)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(s.trigfilter,1,nil,tp)==1 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsDiscardable() end
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end
function s.tdfilter(c,fid)
	local res=false
	for _,flag in ipairs({c:GetFlagEffectLabel(id)}) do if flag==fid then res=true end end
	return res and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler():GetFieldID()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,c:GetFieldID()):GetFirst()
	local res=0
	if tc:IsExtraDeckMonster() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then res=Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT) else
		if Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0 then
			res=Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
		else res=Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT) end
	end
	if res>0 and tc:IsLocation(LOCATION_DECK) then
		local ct=c:GetFlagEffectLabel(id+500)
		if not ct then c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1,1) else c:SetFlagEffectLabel(id+500,ct+1) end
	end
	local dct=(c:GetFlagEffectLabel(id+500) or 0)*2
	if dct>0 and Duel.IsPlayerCanDraw(tp,dct) and c:IsRelateToEffect(e) and c:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		Duel.BreakEffect()
		if Duel.Draw(tp,dct,REASON_EFFECT)~=0 then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
	end
end
