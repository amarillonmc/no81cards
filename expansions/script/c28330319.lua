--放课后梦想盛开！
function c28330319.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c28330319.target)
	e1:SetOperation(c28330319.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28330319,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)--EFFECT_FLAG_DELAY
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28330319.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28330319.thtg)
	e2:SetOperation(c28330319.thop)
	c:RegisterEffect(e2)
end
function c28330319.chkfilter(c)
	return c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28330319.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c28330319.chkfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetAttribute)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28330319.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28330319.chkfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetAttribute)<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:SelectSubGroup(tp,aux.dabcheck,false,3,3)
	if #cg==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local sg=cg:RandomSelect(1-tp,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=sg:Select(tp,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
	--sg:Sub(tg)
	--Duel.SendtoGrave(sg,REASON_EFFECT)
end
function c28330319.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
end
function c28330319.tfilter(c)
	return c:IsLevel(4) and c:IsAbleToDeck() and c:IsAbleToHand()
end
function c28330319.gcheck(sg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x286)
end
function c28330319.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c28330319.tfilter,tp,LOCATION_GRAVE,0,nil):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(c28330319.gcheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c28330319.gcheck,false,3,3)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,2,0,LOCATION_GRAVE)
end
function c28330319.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local tg,atk=g:Filter(Card.IsSetCard,nil,0x286):GetMaxGroup(Card.GetAttack)
	local tc=tg:GetFirst()
	if tc then
		if #tg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			tc=tg:Select(tp,1,1,nil):GetFirst()
		end
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		g:RemoveCard(tc)
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
