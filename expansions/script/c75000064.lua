--「回响」纹章士-“慈悲王女”
function c75000064.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c75000064.lcheck)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000064,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75000064)
	e1:SetTarget(c75000064.cttg)
	e1:SetOperation(c75000064.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000064,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75000064+1)
	e2:SetCost(c75000064.spcost)
	e2:SetTarget(c75000064.sptg)
	e2:SetOperation(c75000064.spop)
	c:RegisterEffect(e2)
end
function c75000064.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c75000064.tfilter(c,p)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return (seq>0 and Duel.CheckLocation(p,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(p,LOCATION_MZONE,seq+1))
end
function c75000064.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c75000064.tfilter(chkc,1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c75000064.tfilter,tp,0,LOCATION_MZONE,1,nil,1-tp)
		and e:GetHandler():IsControlerCanBeChanged() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c75000064.tfilter,tp,0,LOCATION_MZONE,1,1,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c75000064.seqfilter(c,p,seq,loc)
	local sseq=c:GetSequence()
	if c:IsControler(1-p) then
		return loc==LOCATION_MZONE and c:IsLocation(LOCATION_MZONE)
			and (sseq==5 and seq==3 or sseq==6 and seq==1)
	end
	if c:IsLocation(LOCATION_SZONE) then
		return sseq<5 and (sseq==seq or loc==LOCATION_SZONE and math.abs(sseq-seq)==1)
	end
	if sseq<5 then
		return sseq==seq or loc==LOCATION_MZONE and math.abs(sseq-seq)==1
	else
		return loc==LOCATION_MZONE and (sseq==5 and seq==1 or sseq==6 and seq==3)
	end
end
function c75000064.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsControler(1-tp) then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1)) then
		local zone=0
		if seq>0 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq-1) then zone=bit.replace(zone,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(1-tp,LOCATION_MZONE,seq+1) then zone=bit.replace(zone,0x1,seq+1) end
		if Duel.GetControl(c,1-tp,0,0,zone)==0 then return end
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c75000064.seqfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c:GetControler(),c:GetSequence(),c:GetLocation())
		g:AddCard(c)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c75000064.cfilter(c,e,tp)
	return c:IsAttribute(0x30) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c75000064.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function c75000064.spfilter(c,e,tp,attr)
	return (c:IsSetCard(0x3751,0x6752) or c:IsCode(75000001)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsNonAttribute(attr)
end
function c75000064.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c75000064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c75000064.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c75000064.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(tc:GetAttribute())
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75000064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c75000064.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
