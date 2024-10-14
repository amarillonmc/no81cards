--死之王女 埃尔
function c75081007.initial_effect(c)
	--revive
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCountLimit(1,75081007)
	e0:SetCost(c75081007.spcost)
	e0:SetCondition(c75081007.spcon1)
	e0:SetTarget(c75081007.sptg)
	e0:SetOperation(c75081007.spop)
	c:RegisterEffect(e0)
	local e2=e0:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c75081007.spcon2)
	c:RegisterEffect(e2)
	if not c75081007.global_check then
		c75081007.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c75081007.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end  
end
function c75081007.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsControler,1,nil,tp) then return Duel.RegisterFlagEffect(tp,75081007,RESET_PHASE+PHASE_END,0,1) end
end
function c75081007.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081007)==0 
end
function c75081007.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081007)~=0 
end
function c75081007.cfilter2(c,tp)
	return c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER)
end
function c75081007.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c75081007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,2,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c75081007.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,c,tp)
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(75081007,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
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
		e1:SetCondition(c75081007.retcon)
		e1:SetOperation(c75081007.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081007.retfilter(c,fid)
	return c:GetFlagEffectLabel(75081007)==fid
end
function c75081007.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c75081007.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c75081007.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x75c) and c:IsRankBelow(6) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c75081007.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c75081007.retfilter,nil,e:GetLabel())
	local ssg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE)
	if ssg:GetCount()>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75081007,2))
		local tc=ssg:Select(tp,1,1,nil):GetFirst()
		if Duel.ReturnToField(tc)~=0 and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c75081007.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(75081007,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c75081007.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
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
	else
		g:DeleteGroup()
		local tc=sg:GetFirst()
		while tc do
			if tc:IsPreviousLocation(LOCATION_MZONE) then
				if Duel.ReturnToField(tc)~=0 and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c75081007.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(75081007,1)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local g=Duel.SelectMatchingCard(tp,c75081007.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
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
			else
				if Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)~=0  and Duel.SelectYesNo(tp,aux.Stringid(75081007,0)) then
					local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
					local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)
					if g:GetCount()>0 and g1:GetCount()>0 then
						local sg=g:RandomSelect(tp,1)
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
						local sg2=g1:Select(tp,1,1,nil)
						sg:Merge(sg2)
						Duel.Destroy(sg,REASON_EFFECT)
					end
				end
			end
			tc=sg:GetNext()
		end
	end
end
--
function c75081007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c75081007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
