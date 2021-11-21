--天命托宣
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150006,"TENMEITAKUSENN")
function c16150006.initial_effect(c)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return rk.check(c,"OUMEI") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsSetCard(0xccd) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(2)
	return true
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b=Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
	if chk==0 then
		return a
	end
	if a and b and e:GetLabel()==2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		e:SetLabel(1)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local thg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if thg:GetCount()>0 then
		Duel.SendtoHand(thg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
	end
	if flag==1 and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
		local thg2=g:RandomSelect(tp,1)
		Duel.SendtoHand(thg2,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg2)
	end
end

