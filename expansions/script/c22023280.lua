--星之航海家-旅行者
function c22023280.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023280+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22023280.target)
	e1:SetOperation(c22023280.activate)
	c:RegisterEffect(e1)
end
function c22023280.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local gc=g:GetCount()
	if chk==0 then return gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc and Duel.IsPlayerCanDraw(tp,gc) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c22023280.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local gc=g:GetCount()
	if gc>0 and g:FilterCount(Card.IsAbleToRemove,nil)==gc then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
			Duel.Draw(tp,oc,REASON_EFFECT)
		end
		local g1=Duel.GetOperatedGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ct=g:FilterCount(c22023280.cfilter,nil)
		local cg=Duel.GetMatchingGroup(c22023280.filter,tp,LOCATION_DECK, 0,nil,e,tp)
		if ct>1 and ft>0 and cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22023280,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22023280.filter(c,e,sp)
	return c:IsSetCard(0x3ff1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22023280.cfilter(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end