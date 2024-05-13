--神碑の泉
local m=91030008
local cm=c91030008
function c91030008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.tg1)
	e2:SetOperation(cm.op1)
	c:RegisterEffect(e2)

end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_QUICKPLAY) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsSetCard(0x9d3) 
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return  Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 or (Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil))end
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
	local b2=Duel.IsPlayerCanDraw(tp)
	local b3=Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil)
	 local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2 and b3,aux.Stringid(m,1)})
	if op==1 then
	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(1,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
	e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
	e:GetHandler():RegisterFlagEffect(2,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0x9d3) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if c:GetFlagEffect(1)>0  then
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(Card.IsSetCard,1,nil,0x9d3) then
			if g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end   
		end
	end
	c:ResetFlagEffect(1)
	elseif c:GetFlagEffect(2)>0 then
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #sg==0 then return end
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	Duel.SortDecktop(tp,tp,ct)
	for i=1,ct do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),1)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	c:ResetFlagEffect(2)
	end
end
function cm.filter(c)
	return c:IsSetCard(0x9d3) and c:IsFaceup() and c:IsAbleToDeck() 
end

