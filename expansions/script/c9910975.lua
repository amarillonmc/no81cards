--永夏的反魂
require("expansions/script/c9910950")
function c9910975.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910975+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910975.cost)
	e1:SetTarget(c9910975.target)
	e1:SetOperation(c9910975.activate)
	c:RegisterEffect(e1)
end
function c9910975.cfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c9910975.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910975.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9910975.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c9910975.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,5)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,1-tp,LOCATION_MZONE,0,1,nil,REASON_RULE)
		and g:GetCount()==5 and g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c9910975.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	local g=Duel.GetMatchingGroup(Card.IsReleasable,1-tp,LOCATION_MZONE,0,nil,REASON_RULE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		res=Duel.Release(sg,REASON_RULE)>0
		if res then
			local rg=Duel.GetDecktopGroup(1-tp,5)
			Duel.ConfirmCards(tp,rg)
			if #rg>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tg=rg:FilterSelect(tp,Card.IsAbleToRemove,1,2,nil,tp,POS_FACEDOWN)
				Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
				Duel.ShuffleDeck(1-tp)
			end
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
