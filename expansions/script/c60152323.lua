--支仓伊绪的恶作剧
function c60152323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60152323,5))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c60152323.target)
	e1:SetOperation(c60152323.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60152323,4))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60152323.e2tg)
	e2:SetOperation(c60152323.e2op)
	c:RegisterEffect(e2)
end
function c60152323.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c60152323.xyzspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank(),c:GetAttribute(),nil)
end
function c60152323.xyzspfilter(c,e,tp,rk,att,mc)
	return c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ) and c:IsRank(rk) and not c:IsAttribute(att)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and aux.MustMaterialCheck(mc,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c60152323.deckspfilter(c,e,tp)
	return c:IsSetCard(0xcb26) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60152323.xyzfilter1(c,tp)
	return c:IsCanOverlay()
end
function c60152323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60152323.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsExistingTarget(c60152323.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c60152323.deckspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c60152323.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c60152323.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c60152323.deckspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc1=g1:GetFirst()
	if not sc1 then return end
	Duel.SpecialSummonStep(sc1,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c60152323.xyzspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank(),tc:GetAttribute(),sc1)
	local sc2=g2:GetFirst()
	if sc2 then
		sc2:SetMaterial(Group.FromCards(sc1))
		Duel.Overlay(sc2,Group.FromCards(sc1))
		Duel.SpecialSummon(sc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc2:CompleteProcedure()
		local g=Duel.GetMatchingGroup(c60152323.xyzfilter1,tp,0,LOCATION_ONFIELD,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60152323,6)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=g:Select(tp,1,1,nil)
			Duel.Overlay(sc2,sg:GetFirst())
		end
	end
end
function c60152323.e2tgfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsSetCard(0xcb26) and c:IsType(TYPE_MONSTER)
end
function c60152323.e2tgfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcb26) and c:IsType(TYPE_XYZ)
end
function c60152323.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60152323.e2tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e) 
		and Duel.IsExistingMatchingCard(c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60152323.e2op(e,tp,eg,ep,ev,re,r,rp)
	local g0=Duel.GetMatchingGroup(c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,nil)
	if g0:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,6))
		local g1=Duel.SelectMatchingCard(tp,c60152323.e2tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60152301,7))
		local g2=Duel.SelectMatchingCard(tp,c60152323.e2tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.Overlay(tc2,g1)
	end
end