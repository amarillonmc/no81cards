--电子叠光网络
function c9950856.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950856+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950856.target)
	e1:SetOperation(c9950856.activate)
	c:RegisterEffect(e1)
 --Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950856,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c9950856.spcost)
	e2:SetTarget(c9950856.sptg)
	e2:SetOperation(c9950856.spop)
	c:RegisterEffect(e2)
end
function c9950856.filter(c,e,tp)
	return c:IsSetCard(0x1093) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950856.xyzfilter(c,mg)
	return c:IsSetCard(0x1093) and c:IsXyzSummonable(mg,3,3)
end
function c9950856.mfilter1(c,mg,exg)
	return mg:IsExists(c9950856.mfilter2,1,c,c,mg,exg)
end
function c9950856.mfilter2(c,mc,mg,exg)
	return mg:IsExists(c9950856.mfilter3,1,c,c,mc,exg)
end
function c9950856.mfilter3(c,mc1,mc2,exg)
	return c~=mc2 and exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc1,mc2),3,3)
end
function c9950856.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c9950856.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c9950856.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and mg:IsExists(c9950856.mfilter1,1,nil,mg,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c9950856.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c9950856.mfilter2,1,1,tc1,tc1,mg,exg)
	local tc2=sg2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=mg:FilterSelect(tp,c9950856.mfilter3,1,1,tc2,tc2,tc1,exg)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,3,0,0)
end
function c9950856.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950856.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9950856.filter2,nil,e,tp)
	if g:GetCount()<3 then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(c9950856.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c9950856.cfilter(c,e,tp)
	return c:IsSetCard(0x1093) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c9950856.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c9950856.spfilter(c,e,tp)
	return c:IsSetCard(0x1093) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950856.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c9950856.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950856.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950856.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950856.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950856.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950856.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
