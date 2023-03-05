--生体躏融
local m=30005508
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_GRAVE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m+m)
	e51:SetTarget(cm.tthtg)
	e51:SetOperation(cm.tthop)
	c:RegisterEffect(e51)  
end
--Effect 1
function cm.stf(c)
	return c:IsSetCard(0x927) and c:IsType(TYPE_MONSTER)
end
function cm.thfilter(c)
	return cm.stf(c) and c:IsAbleToHand()
end
function cm.hf(c)
	if not c:IsOriginalSetCard(0x927) then return false end
	return not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	local c=e:GetHandler()
	if #g==0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)==0 or g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)==0 then return false end
	Duel.ConfirmCards(1-tp,g)
	local hg=Duel.GetOperatedGroup():Filter(cm.hf,nil)
	for tc in aux.Next(hg) do
		local id=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e51=Effect.CreateEffect(c)
		e51:SetDescription(aux.Stringid(m,1))
		e51:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
		e51:SetType(EFFECT_TYPE_QUICK_O)
		e51:SetCode(EVENT_FREE_CHAIN)
		e51:SetRange(LOCATION_HAND)
		e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e51:SetCountLimit(1,id)
		e51:SetCondition(cm.fscon)
		e51:SetTarget(cm.fstg)
		e51:SetOperation(cm.fsop)
		e51:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e51,true) 
		tc:RegisterFlagEffect(30005508,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
end
--Effect 2
function cm.thfilter2(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:IsType(TYPE_MONSTER) and b1 
		and c:IsAbleToHand()
end
function cm.tthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.thfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.tthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_DECK) then
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
--Hybrid Effect 
function cm.fscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPublic() and c:GetFlagEffect(30005508)>0
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end