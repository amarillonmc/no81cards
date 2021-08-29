--升阶魔法—进化之弧
function c82557936.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82557936)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c82557936.condition)
	e1:SetCost(c82557936.cost)
	e1:SetTarget(c82557936.target)
	e1:SetOperation(c82557936.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,82557836)
	e2:SetTarget(c82557936.mttg)
	e2:SetOperation(c82557936.mtop)
	c:RegisterEffect(e2)
end
function c82557936.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c82557936.cgfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToRemoveAsCost()
end
function c82557936.cefilter(c,tc,ct,e,tp)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0x829)
		and tc:IsCanBeXyzMaterial(c) and r>0 and ct>=r
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c82557936.cfilter(c,e,tp)
	local ct=Duel.GetMatchingGroupCount(c82557936.cgfilter,tp,LOCATION_GRAVE,0,nil)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) 
		and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c82557936.cefilter,tp,LOCATION_EXTRA,0,1,nil,c,ct,e,tp)
end
function c82557936.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local avail={}
	local availbool={}
	local ct=Duel.GetMatchingGroupCount(c82557936.cgfilter,tp,LOCATION_GRAVE,0,nil)
	local gfield=Duel.GetMatchingGroup(c82557936.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	for tc in aux.Next(gfield) do
		local gextra=Duel.GetMatchingGroup(c82557936.cefilter,tp,LOCATION_EXTRA,0,nil,tc,ct,e,tp)
		for ex in aux.Next(gextra) do
			local r=ex:GetRank()-tc:GetRank()
			if not availbool[r] then
				availbool[r]=true
				table.insert(avail,r)
			end
		end
	end
	local num=Duel.AnnounceNumber(tp,table.unpack(avail))
	e:SetLabel(num)
	local cost=Duel.SelectMatchingCard(tp,c82557936.cgfilter,tp,LOCATION_GRAVE,0,num,num,nil)
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c82557936.tgefilter(c,tc,e,tp,rank)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0x829)
		and tc:IsCanBeXyzMaterial(c) and r==rank
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c82557936.tgfilter(c,e,tp,rank)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) 
		and Duel.IsExistingMatchingCard(c82557936.tgefilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp,rank)
end
function c82557936.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557936.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557936.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c82557936.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82557936.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and tc:IsFaceup()
		and tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82557936.tgefilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp,e:GetLabel())
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
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c82557936.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c82557936.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c82557936.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x829)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c82557936.filter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c)
end
function c82557936.filter2(c,e)
	return c:IsType(TYPE_MONSTER) 
end
function c82557936.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c82557936.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557936.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82557936.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c82557936.mtop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82557936.filter2),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,tc,e)
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,g)
	end
end