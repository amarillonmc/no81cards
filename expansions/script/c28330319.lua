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
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetProperty(EFFECT_FLAG_DELAY)
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
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
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
function c28330319.thfilter(c)
	return c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28330319.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28330319.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetCurrentChain()==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c28330319.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28330319.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
