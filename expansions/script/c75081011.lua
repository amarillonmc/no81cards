--罪秽恶镰 赫拉尔
function c75081011.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75081011,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75081011)
	e1:SetCondition(c75081011.con1)
	e1:SetCost(c75081011.cost1)
	e1:SetTarget(c75081011.thtg)
	e1:SetOperation(c75081011.thop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c75081011.con2)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081011,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,75081011)
	e3:SetCondition(c75081011.con1)
	e3:SetCost(c75081011.cost2)
	e3:SetTarget(c75081011.thtg)
	e3:SetOperation(c75081011.thop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c75081011.con2)
	c:RegisterEffect(e4)
	if not c75081011.global_check then
		c75081011.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c75081011.spcheckop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c75081011.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc and tc:IsType(TYPE_MONSTER) do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),75081011,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
	
function c75081011.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081011)==0 
end
function c75081011.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75081011)~=0 
end
function c75081011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081011 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c75081011.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c75081011.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x75c) and c:IsRankBelow(6) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c75081011.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.ReturnToField(tc)~=0 and Duel.GetFlagEffect(tp,75081012)==0 and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(c75081011.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc) and Duel.SelectYesNo(tp,aux.Stringid(75081011,0)) then
		Duel.RegisterFlagEffect(tp,75081012,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081011.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
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
--
function c75081011.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==75081011 then
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(c75081011.retcon1)
		e1:SetOperation(c75081011.retop1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		c:RegisterFlagEffect(75081011,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
end
function c75081011.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081011)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081011.spfilter(c,e,tp)
	return c:IsSetCard(0x75c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75081011.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75081011.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(tp,75081013)==0 and Duel.SelectYesNo(tp,aux.Stringid(75081011,1)) then
		Duel.RegisterFlagEffect(tp,75081013,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c75081011.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--
function c75081011.thfilter(c)
	return c:IsSetCard(0x75c) and c:IsAbleToHand()
end
function c75081011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75081011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75081011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75081011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end