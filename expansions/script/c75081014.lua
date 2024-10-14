--罪秽之死神 赫尔
function c75081014.initial_effect(c)
	--revive
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,75081014)
	e0:SetCondition(c75081014.spcon1)
	e0:SetCost(c75081014.spcost)
	e0:SetTarget(c75081014.sptg)
	e0:SetOperation(c75081014.spop)
	c:RegisterEffect(e0)
end
--
function c75081014.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c75081014.cfilter2(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER)
end
function c75081014.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c75081014.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75081014.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,tp)
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(75081014,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(og)
		e1:SetCondition(c75081014.retcon)
		e1:SetOperation(c75081014.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081014.retfilter(c,fid)
	return c:GetFlagEffectLabel(75081014)==fid
end
function c75081014.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c75081014.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c75081014.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x75c) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c75081014.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75081014.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c75081014.retfilter,nil,e:GetLabel())
	local ssg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
	if ssg:GetCount()>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75081014,2))
		local tc=ssg:Select(tp,1,1,nil):GetFirst()
		if Duel.ReturnToField(tc)~=0 and Duel.GetFlagEffect(tp,75081008)==0 and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c75081014.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(75081014,1)) then
			Duel.RegisterFlagEffect(tp,75081008,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,c75081014.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			local sc=g1:GetFirst()
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
	else
		--g1:DeleteGroup()
		local tc=sg:GetFirst()
		while tc do
			if tc:IsPreviousLocation(LOCATION_MZONE) then
				if Duel.ReturnToField(tc)~=0 and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c75081014.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(75081014,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g2=Duel.SelectMatchingCard(tp,c75081014.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
					local sc=g2:GetFirst()
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
			else
				if Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(c75081014.thfilter,tp,LOCATION_DECK,0,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(75081014,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local ssg=Duel.GetMatchingGroup(c75081014.thfilter,tp,LOCATION_DECK,0,nil):Select(tp,1,1,nil)
					if Duel.SendtoHand(ssg,nil,REASON_EFFECT)~=0 and ssg:GetFirst():IsLocation(LOCATION_HAND) then
						Duel.ConfirmCards(1-tp,ssg)
						Duel.ShuffleHand(tp)
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local gg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
						Duel.Destroy(gg,REASON_EFFECT)
					end
				end
			end
			tc=sg:GetNext()
		end
	end
end
--
function c75081014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75081014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

