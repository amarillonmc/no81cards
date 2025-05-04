--蕾宗忍法斥候 堤米
local s,id,o=GetID()
function s.initial_effect(c)
	--①：自己主要阶段可以发动。从自己卡组中把1张「蕾宗忍」卡加入手卡。
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)  
	--②：双方回合才能发动。场上的这张卡回到手卡，那之后，可以让自己场上任意数量的卡回到持有者手卡（自己场上没有卡的场合，也能作为代替让对方场上1张卡回到卡组）。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	--e2:SetCost(s.cost)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsSetCard(0x705) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5
	if not b1 and not b2 then return end
	local op=nil
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	local p=op==0 and tp or 1-tp
	Duel.SortDecktop(tp,p,5)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end --Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	--local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local tg=g:CancelableSelect(tp,1,#g,nil)
			if tg and #tg>0 then
				Duel.HintSelection(tg)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			end
		elseif Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil)==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=g:CancelableSelect(tp,1,1,nil)
			if tg and #tg>0 then
				Duel.HintSelection(tg)
				Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end













