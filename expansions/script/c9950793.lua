--光之国-传说的战士
function c9950793.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950793+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9950793.cost)
	e1:SetTarget(c9950793.target)
	e1:SetOperation(c9950793.activate)
	c:RegisterEffect(e1)
end
function c9950793.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9950793.cfilter1(c,cg,e,tp)
	return cg:IsExists(c9950793.cfilter2,1,c,c,e,tp)
end
function c9950793.cfilter2(c,mc,e,tp)
	return Duel.IsExistingMatchingCard(c9950793.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,mc))
end
function c9950793.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9950793.filter(c,e,tp,mg)
	return c:IsCode(9950789,9951209,9950703,9951080) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c9950793.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA+LOCATION_DECK) and c9950793.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950793.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950793.filter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950793.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end

