--寻星术的传情
function c9910382.initial_effect(c)
	aux.AddCodeList(c,9910376)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910382+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910382.cost)
	e1:SetTarget(c9910382.target)
	e1:SetOperation(c9910382.activate)
	c:RegisterEffect(e1)
end
function c9910382.costfilter(c)
	return aux.IsCodeListed(c,9910376) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9910382.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9910382.costfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9910382.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910382.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c9910382.thfilter(c)
	return aux.IsCodeListed(c,9910376) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910382.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local dr=Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c9910382.thfilter,p,LOCATION_DECK,0,nil)
	if dr~=0 and Duel.GetFlagEffect(p,9910382)==0 and Duel.GetFieldGroupCount(p,LOCATION_EXTRA,0)==0
		and Duel.IsExistingMatchingCard(Card.IsCode,p,LOCATION_GRAVE,0,1,nil,9910376)
		and g:GetCount()>0 and Duel.SelectYesNo(p,aux.Stringid(9910382,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.RegisterFlagEffect(p,9910382,0,0,1)
	end
end
