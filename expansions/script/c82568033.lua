--升阶魔法-泰拉之力
function c82568033.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(82568033,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c82568033.target)
	e1:SetCondition(c82568033.condition)
	e1:SetCost(c82568033.cost)
	e1:SetOperation(c82568033.activate)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(82568033,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c82568033.target2)
	e2:SetCondition(c82568033.condition)
	e2:SetCost(c82568033.cost)
	e2:SetOperation(c82568033.activate2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(82568033,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMING_DESTROY+TIMING_END_PHASE)
	e3:SetCondition(c82568033.condition2)
	e3:SetCost(c82568033.cost)
	e3:SetTarget(c82568033.target3)
	e3:SetOperation(c82568033.activate3)
	c:RegisterEffect(e3)
	--Activate2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(82568033,3))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMING_DESTROY+TIMING_END_PHASE)
	e4:SetCondition(c82568033.condition2)
	e4:SetCost(c82568033.cost)
	e4:SetTarget(c82568033.target4)
	e4:SetOperation(c82568033.activate4)
	c:RegisterEffect(e4)
	if not c82568033.globle_check then
		c82568033.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c82568033.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c82568033.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSetCard(0x825) and tc:IsType(TYPE_XYZ) and tc:IsReason(REASON_DESTROY) then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,82568033,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,82568033,RESET_PHASE+PHASE_END,0,1) end
end
function c82568033.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,82568033)~=0  and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and   Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
end
function c82568033.filter1o(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c82568033.filter2o,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,c:GetRank()+2)
end
function c82568033.filter12o(c,e,tp)
	return c:IsType(TYPE_XYZ) 
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c82568033.filter2o,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1,c:GetRank()+2)
end
function c82568033.filter2o(c,e,tp,mc,rk1,rk2)
	return (c:IsRank(rk1) or c:IsRank(rk2)) and c:IsSetCard(0x825) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82568033.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c82568033.filter1o(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82568033.filter1o,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82568033.filter1o,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568033.activate3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568033.filter2o,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c82568033.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c82568033.filter12o(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82568033.filter12o,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c82568033.filter12o,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568033.activate4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568033.filter2o,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1,tc:GetRank()+2)
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
end
function c82568033.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) and   Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
end
function c82568033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c82568033.filter(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND)) or 
		   (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)) or
		   (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_EXTRA) and not c:IsFacedown())
end
function c82568033.xyzfilter(c,e,tp,mg)
	local rk=c:GetRank()
	return c:IsSetCard(0x825) and c:IsXyzSummonable(mg,2,2) and
	 Duel.IsExistingMatchingCard(c82568033.rankupfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,rk+2) 
	 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82568033.rankupfilter(c,e,tp,mc,rk,rk2)
	return (c:IsRank(rk) or c:IsRank(rk2)) and c:IsSetCard(0x825) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c82568033.rankupfiltertrue(c,e,tp,mc,rk,rk2)
	return (c:IsRank(rk) or c:IsRank(rk2)) and c:IsSetCard(0x825)  and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82568033.mfilter1(c,mg,exg)
	return mg:IsExists(c82568033.mfilter2,1,c,c,exg)
end
function c82568033.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c82568033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(c82568033.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c82568033.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if chk==0 then return Duel.GetTurnPlayer()==tp and Duel.IsPlayerCanSpecialSummonCount(tp,3)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and exg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c82568033.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local mg=Duel.GetMatchingGroup(c82568033.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c82568033.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c82568033.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c82568033.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	if sg1:GetCount()<2 then return end
	local tc=sg1:GetFirst()
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
		tc=sg1:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(c82568033.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,sg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ttc=xyzg:Select(tp,1,1,nil):GetFirst() 
		 e:SetLabelObject(ttc) end
	local ttc=e:GetLabelObject()
	 if  Duel.SpecialSummon(ttc,0,tp,tp,false,false,POS_FACEUP)==0  then return end 
	if not aux.MustMaterialCheck(ttc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568033.rankupfiltertrue,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ttc,ttc:GetRank()+1,ttc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		 Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(ttc))
		Duel.Overlay(sc,Group.FromCards(ttc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	Duel.Overlay(sc,sg1)

end
end
function c82568033.filter2(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND)) or 
		   (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)) or
		   (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_EXTRA) and not c:IsFacedown())
end
function c82568033.xyzfilter2(c,e,tp,mg2)
	local rk=c:GetRank()
	return c:IsSetCard(0x825) and c:IsXyzSummonable(mg2,3,3) and
	 Duel.IsExistingMatchingCard(c82568033.rankupfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1,rk+2) 
	 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c82568033.rankupfilter2(c,e,tp,mc,rk,rk2)
	return (c:IsRank(rk) or c:IsRank(rk2)) and c:IsSetCard(0x825) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
end
function c82568033.rankupfiltertrue2(c,e,tp,mc,rk,rk2)
	return (c:IsRank(rk) or c:IsRank(rk2)) and c:IsSetCard(0x825)  and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82568033.mfilter12(c,mg,exg)
	return mg:IsExists(c82568033.mfilter22,1,c,c,mg,exg)
end
function c82568033.mfilter22(c,mc,mg,exg)
	return mg:IsExists(c82568033.mfilter32,1,c,c,mc,exg)
end
function c82568033.mfilter32(c,mc1,mc2,exg)
	return c~=mc2 and exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc1,mc2),3,3)
end
function c82568033.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg2=Duel.GetMatchingGroup(c82568033.filter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local exg2=Duel.GetMatchingGroup(c82568033.xyzfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2)
	if chk==0 then return Duel.GetTurnPlayer()==tp and Duel.IsPlayerCanSpecialSummonCount(tp,3)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and exg2:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c82568033.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local mg=Duel.GetMatchingGroup(c82568033.filter2,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c82568033.xyzfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c82568033.mfilter12,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c82568033.mfilter22,1,1,tc1,tc1,mg,exg)
	local tc2=sg2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=mg:FilterSelect(tp,c82568033.mfilter32,1,1,tc2,tc2,tc1,exg)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	if sg1:GetCount()<3 then return end
	local tc=sg1:GetFirst()
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
		tc=sg1:GetNext()
	end
	Duel.SpecialSummonComplete()
	local xyzg=Duel.GetMatchingGroup(c82568033.xyzfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,sg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ttc=xyzg:Select(tp,1,1,nil):GetFirst() 
		 e:SetLabelObject(ttc) end
	local ttc=e:GetLabelObject()
	 if  Duel.SpecialSummon(ttc,0,tp,tp,false,false,POS_FACEUP)==0  then return end 
	if not aux.MustMaterialCheck(ttc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568033.rankupfiltertrue2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ttc,ttc:GetRank()+1,ttc:GetRank()+2)
	local sc=g:GetFirst()
	if sc then
		 Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(ttc))
		Duel.Overlay(sc,Group.FromCards(ttc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	Duel.Overlay(sc,sg1)

end
end