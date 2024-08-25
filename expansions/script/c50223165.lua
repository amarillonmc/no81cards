--天王数码兽 机械邪龙兽
function c50223165.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,c50223165.lcheck)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50223165,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,50223165)
	e1:SetTarget(c50223165.negtg)
	e1:SetOperation(c50223165.negop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50223165,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,50223166)
	e1:SetTarget(c50223165.sptg)
	e1:SetOperation(c50223165.spop)
	c:RegisterEffect(e1)
end
function c50223165.lcheck(g,lc)
	return g:GetClassCount(Card.GetSummonLocation)==g:GetCount()
end
function c50223165.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToGrave() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c50223165.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if seq==5 then
		seq=1
		else if seq==6 then
			seq=3
		end
	end
	local fid=tc:GetFieldID()
	if tc:IsRelateToEffect(e) then 
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(0,LOCATION_ONFIELD)
			e1:SetTarget(c50223165.distg)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(seq,fid)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetOperation(c50223165.disop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetLabel(seq)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c50223165.distg(e,c)
	local seq,fid=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
		and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c50223165.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if rp==1-tp and loc&LOCATION_ONFIELD~=0 and ((seq<=4 and seq==4-tseq) or (seq==5 and seq==tseq+1) or (seq==6 and seq==tseq-1))
	then
		Duel.NegateEffect(ev)
	end
end
function c50223165.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c50223165.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c50223165.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingTarget(c50223165.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c50223165.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c50223165.dfilter(c,tcseq)
	return (c:IsLocation(LOCATION_MZONE) and (c:GetSequence()==tcseq+1 or c:GetSequence()==tcseq-1))
		or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()==tcseq)
		or (tcseq==1 and c:GetSequence()==5) or (tcseq==3 and c:GetSequence()==6)
end
function c50223165.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local tcseq=tc:GetSequence()
			local g=Duel.GetMatchingGroup(c50223165.dfilter,tp,0,LOCATION_ONFIELD,nil,tcseq)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end