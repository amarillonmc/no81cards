--降阶魔法-净化型异晶人的魔力
function c98920714.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920714)
	e1:SetCost(c98920714.cost)
	e1:SetTarget(c98920714.target)
	e1:SetOperation(c98920714.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(98920714,ACTIVITY_SPSUMMON,c98920714.counterfilter)
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920714,0))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98920714)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c98920714.tdtg)
	e2:SetOperation(c98920714.tdop)
	c:RegisterEffect(e2)
end
function c98920714.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_XYZ)
end
function c98920714.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98920714,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920714.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c98920714.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function c98920714.filter1(c,e,tp)
	local no=aux.GetXyzNumber(c)
	local ect=c98920714 and Duel.IsPlayerAffectedByEffect(tp,98920714) and c98920714[tp]
	return no and no>=101 and no<=107 and c:IsSetCard(0x1048)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not ect or ect>1 or c:IsLocation(LOCATION_GRAVE))
		and Duel.IsExistingMatchingCard(c98920714.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,no)
end
function c98920714.filter2(c,e,tp,mc,no)
	return aux.GetXyzNumber(c)==no and c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c98920714.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	local ect=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc+LOCATION_EXTRA end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetFlagEffect(tp,98920714)==0 and loc~=0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c98920714.filter1,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c98920714.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98920714)~=0 then return end
	Duel.RegisterFlagEffect(tp,98920714,0,0,0)
	local loc=0
	local ect=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0 and (ect==nil or ect>1) then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920714.filter1),tp,loc,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if not aux.MustMaterialCheck(tc1,tp,EFFECT_MUST_BE_XMATERIAL) then return end
		local no=aux.GetXyzNumber(tc1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c98920714.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc1,no)
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
			tc2:SetMaterial(g1)
			Duel.Overlay(tc2,g1)
			Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc2:CompleteProcedure()
		end
	end
end
function c98920714.tdfilter(c)
	return c:IsSetCard(0x1048) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra()
end
function c98920714.filter(c)
	return not c:IsCode(98920714) and (c:IsSetCard(0x175) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x176) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY))
end
function c98920714.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920714.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920714.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c98920714.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c98920714.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c98920714.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c98920714.filter,tp,LOCATION_DECK,0,1,1,nil)
		local tc1=g:GetFirst()
		if tc1 then
		   if tc1:IsAbleToHand() and Duel.SelectOption(tp,1190,aux.Stringid(98920714,2))==0 then
			   Duel.SendtoHand(tc1,nil,REASON_EFFECT)
			   Duel.ConfirmCards(1-tp,tc1)
		   else
			   Duel.ShuffleDeck(tp)
			   Duel.MoveSequence(tc1,SEQ_DECKTOP)
			   Duel.ConfirmDecktop(tp,1)
		   end
	   end
	end
end