--工坊武器·轮盘重工
function c65820050.initial_effect(c)
	aux.AddCodeList(c,65820000,65820005)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65820050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65820050+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65820050.target)
	e1:SetOperation(c65820050.activate)
	c:RegisterEffect(e1)
	--除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65820050,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_HANDES+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65820050+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c65820050.setcon)
	e2:SetTarget(c65820050.settg)
	e2:SetOperation(c65820050.setop)
	c:RegisterEffect(e2)
end



function c65820050.spfilter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()
end
function c65820050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65820050.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED)
end
function c65820050.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65820050.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65820050.filter(c,e,tp)
	return c:IsCode(65820000,65820005) and c:IsFaceup()
end
function c65820050.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65820050.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c65820050.filter1(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function c65820050.nbfilter(c)
	return (aux.NegateAnyFilter(c) or c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)) and c:IsFaceup()
end
function c65820050.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c65820050.nbfilter(chkc) and c~=chkc end
	if chk==0 then return Duel.IsExistingTarget(c65820050.nbfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) and Duel.IsExistingMatchingCard(c65820050.filter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c65820050.nbfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c65820050.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,c65820050.filter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local c=e:GetHandler()
			Duel.AdjustInstantly()
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end