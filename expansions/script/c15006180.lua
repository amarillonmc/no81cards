local m=15006180
local cm=_G["c"..m]
cm.name="巡星兽 囚"
function cm.initial_effect(c)
	aux.AddCodeList(c,15006200)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.sp2con)
	e2:SetCost(cm.sp2cost)
	e2:SetTarget(cm.sp2tg)
	e2:SetOperation(cm.sp2op)
	c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.srfilter(c)
	return c:IsCode(15006200) and c:IsAbleToGrave()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			if e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.sp2filter(c,e,tp)
	return c:IsCode(15006200) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.sp2filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		--fusion
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,2))
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		e4:SetType(EFFECT_TYPE_QUICK_O)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetCountLimit(1)
		e4:SetHintTiming(0,TIMING_MAIN_END)
		e4:SetCondition(cm.fscon)
		e4:SetTarget(cm.fstg)
		e4:SetOperation(cm.fsop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
		--change type
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetCode(EFFECT_ADD_TYPE)
		e7:SetRange(LOCATION_MZONE)
		e7:SetValue(TYPE_EFFECT)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		--
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function cm.fscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsFaceupEx()
end
function cm.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsFaceupEx() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9f44) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
		and Duel.GetLocationCountFromEx(tp,tp,m,c)>0
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)
			end
		end
		return res
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,0)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end