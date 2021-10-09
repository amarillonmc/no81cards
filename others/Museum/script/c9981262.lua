--升阶魔法-ZEXAL变身！
function c9981262.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981262,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9981262.target)
	e1:SetOperation(c9981262.activate)
	c:RegisterEffect(e1)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,9981262)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c9981262.target2)
	e1:SetOperation(c9981262.activate2)
	c:RegisterEffect(e1)
end
function c9981262.filter1(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR)
		and Duel.IsExistingMatchingCard(c9981262.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9981262.filter2(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsType(TYPE_XYZ) and (c:IsRace(RACE_WARRIOR) or c:IsAttribute(ATTRIBUTE_LIGHT)) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c9981262.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9981262.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9981262.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9981262.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9981262.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981262.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981262,0))
end
function c9981262.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981262.xyzfilter(c,mg)
	return c:IsSetCard(0x7f) and c:IsXyzSummonable(mg,2,2)
end
function c9981262.mfilter1(c,mg,exg)
	return mg:IsExists(c9981262.mfilter2,1,c,c,mg,exg)
end
function c9981262.mfilter2(c,mc,mg,exg)
	return mg:IsExists(c9981262.mfilter3,1,c,c,mc,exg)
end
function c9981262.mfilter3(c,mc1,mc2,exg)
	return c~=mc2 and exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc1,mc2),2,2)
end
function c9981262.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c9981262.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c9981262.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,1)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetLocationCountFromEx(tp)>0
		and mg:IsExists(c9981262.mfilter1,1,nil,mg,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c9981262.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c9981262.mfilter2,1,1,tc1,tc1,mg,exg)
	local tc2=sg2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=mg:FilterSelect(tp,c9981262.mfilter3,1,1,tc2,tc2,tc1,exg)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c9981262.spfilter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981262.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9981262.spfilter2,nil,e,tp)
	if g:GetCount()<2 then return end
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
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c9981262.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981262,0))
end
