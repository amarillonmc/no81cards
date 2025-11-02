--幻殇·玉龙·凤玉
function c11180010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,11180010)
	e1:SetCost(c11180010.spcost)
	e1:SetTarget(c11180010.sptg)
	e1:SetOperation(c11180010.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(11180010,ACTIVITY_SPSUMMON,c11180010.counterfilter)
end
function c11180010.counterfilter(c)
	return c:IsLevelAbove(3) or c:IsLinkAbove(3) or c:IsRankAbove(3)
end
function c11180010.splimit(e,c)
	return not (c:IsLevelAbove(3) or c:IsLinkAbove(3) or c:IsRankAbove(3))
end
function c11180010.costfilter(c,tp)
	return (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()) and Duel.GetMZoneCount(tp,c)>0
end
function c11180010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11180010.costfilter,tp,0xe,0,1,c,tp)
		and Duel.GetFlagEffect(tp,11180010)==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c11180010.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c11180010.costfilter,tp,0xe,0,1,1,c,tp)
	local tc=g:GetFirst()
	if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,1191,1192)==0) then
		Duel.SendtoGrave(tc,REASON_COST)
	else
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	end
	e:SetLabel(tc:GetType())
end
function c11180010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11180010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local type=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
		local ct=Duel.GetMatchingGroupCount(c11180010.mmzmfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(c11180010.opfilter,tp,LOCATION_DECK,0,1,nil,type) and (ct==1)
		local b2=Duel.IsExistingMatchingCard(c11180010.negfilter,tp,0xc,0xc,1,nil,type) and (ct>1)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(11180010,0)) then
			Duel.BreakEffect()
			if b1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local g=Duel.SelectMatchingCard(tp,c11180010.opfilter,tp,LOCATION_DECK,0,1,1,nil,type)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
						Duel.SendtoGrave(tc,REASON_EFFECT)
					else
						Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
					end
				end
			elseif b2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
				local g=Duel.SelectMatchingCard(tp,c11180010.negfilter,tp,0xc,0xc,1,1,nil,type)
				if #g>0 then 
					Duel.HintSelection(g)
				end
				local tc=g:GetFirst()
				if tc and tc:IsCanBeDisabledByEffect(e,false) then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e3)
					end
				end
			end
		end
	end
end
function c11180010.mmzmfilter(c)
	return c:GetSequence()<5
end
function c11180010.opfilter(c,type)
	return c:IsSetCard(0x3450,0x6450) and not c:IsType(type) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function c11180010.negfilter(c,type)
	return aux.NegateAnyFilter(c) and not c:IsType(type)
end