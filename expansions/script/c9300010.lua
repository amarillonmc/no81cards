--降阶魔法-牝堕之力
function c9300010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9300010+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9300010.target)
	e1:SetOperation(c9300010.activate)
	c:RegisterEffect(e1)
end
function c9300010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function c9300010.filter2(c,e,tp,mc,rk,rc,att)
	return c:IsRankBelow(rk-1) and c:IsRace(rc) and not c:IsAttribute(att) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9300010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9300010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9300010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	Duel.SelectTarget(tp,c9300010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9300010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetOverlayGroup()
	local rk=tc:GetRank()
	local g=Duel.GetMatchingGroup(c9300010.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,tc,rk,tc:GetRace(),tc:GetAttribute())
	if tc:GetOverlayCount()>0 and Duel.SendtoGrave(mg,REASON_EFFECT)~=0
		and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and rk>1
		and g:GetCount()>0 and not tc:IsImmuneToEffect(e) 
		and Duel.SelectYesNo(tp,aux.Stringid(9300010,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
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
	elseif tc:GetOverlayCount()==0 and c:IsRelateToEffect(e) then
			c:CancelToGrave()
			if Duel.Overlay(tc,Group.FromCards(c))~=0
				and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and rk>1
				and g:GetCount()>0 and not tc:IsImmuneToEffect(e) 
				and Duel.SelectYesNo(tp,aux.Stringid(9300010,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
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
	end
end