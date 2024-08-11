local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53761005)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(s.con1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,id)
end
function s.costfilter(c)
	return c:IsCode(53761005) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local sel=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if sel==1 then Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST) else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function s.adfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function s.ovfilter(c,e,tp,ce)
	return (not ce or not c:IsImmuneToEffect(ce)) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,mc)
	return c:IsCode(53761001) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 then Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) end
	local flag=Duel.GetFlagEffectLabel(tp,id)
	local b1=c:IsLocation(LOCATION_HAND) and bit.band(flag,0x1)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local b2=c:IsLocation(LOCATION_MZONE) and bit.band(flag,0x2)==0 and Duel.IsExistingMatchingCard(s.adfilter,tp,0,LOCATION_MZONE,1,nil)
	local b3=c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and bit.band(flag,0x4)==0 and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,nil)
	if chk==0 then return (b1 or b2 or b3) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	local op=0
	if not c:IsLocation(LOCATION_MZONE) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		if c:IsLocation(LOCATION_HAND) then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
			Duel.SetFlagEffectLabel(tp,id,flag|0x1)
			op=op|0x1
		else
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
			Duel.SetFlagEffectLabel(tp,id,flag|0x4)
			op=op|0x4
		end
	else
		local sel=aux.SelectFromOptions(tp,{b2,aux.Stringid(id,3)},{b3,aux.Stringid(id,4)},{b2 and b3,aux.Stringid(id,5)})
		if sel==1 then
			e:SetCategory(0)
			Duel.SetFlagEffectLabel(tp,id,flag|0x2)
			op=op|0x2
		elseif sel==2 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			Duel.SetFlagEffectLabel(tp,id,flag|0x4)
			op=op|0x4
		elseif sel==3 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
			Duel.SetFlagEffectLabel(tp,id,flag|0x6)
			op=op|0x6
		end
	end
	Duel.SetTargetParam(op)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local res=0
	if op&0x1~=0 and c:IsRelateToEffect(e) then res=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
	local tg=Duel.GetMatchingGroup(s.adfilter,tp,0,LOCATION_MZONE,nil)
	if op&0x2~=0 and #tg>0 then
		if res~=0 then Duel.BreakEffect() end
		res=res+1
		for tc in aux.Next(tg) do
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(math.ceil(atk/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(math.ceil(def/2))
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
		end
	end
	if op&0x4~=0 and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,e) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,e):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
		if not sc then return end
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then Duel.Overlay(sc,mg) end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
