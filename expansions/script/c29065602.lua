--战械人形 SOPMODII
function c29065602.initial_effect(c)
	--special summon while equipped
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065602,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29065602)
	e2:SetTarget(c29065602.sptg)
	e2:SetOperation(c29065602.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29065602,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c29065602.rettg)
	e3:SetOperation(c29065602.retop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c29065602.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c29065602.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29065602.thfil(c)
	return c:IsCode(29065608) and c:IsAbleToHand()
end
function c29065602.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c29065602.thfil,tp,LOCATION_DECK,0,1,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29065602,0)) then
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c29065602.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad)
end
function c29065602.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c29065602.seqfilter(c,tp,p,seq,loc)
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if c:IsControler(1-tp) then
		if cseq<5 then
			cseq=4-cseq
		else
			cseq=11-cseq
		end
	end
	if loc==LOCATION_MZONE and seq<5 then
		local b1=c:IsControler(p) and cloc==LOCATION_SZONE and cseq==seq
		local b2=c:IsControler(p) and cloc==LOCATION_MZONE and cseq<5 and math.abs(cseq-seq)==1
		local b3=seq==1 and cseq==5 or seq==3 and cseq==6
		return b1 or b2 or b3
	end
	if loc==LOCATION_MZONE and seq>=5 then
		local b1=seq==5 and cloc==LOCATION_MZONE and cseq==1
		local b2=seq==6 and cloc==LOCATION_MZONE and cseq==3
		return b1 or b2
	end
	if loc==LOCATION_SZONE then
		local b1=c:IsControler(p) and cloc==LOCATION_MZONE and cseq==seq
		local b2=c:IsControler(p) and cloc==LOCATION_SZONE and math.abs(cseq-seq)==1
		return b1 or b2
	end
	return false
end
function c29065602.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local p=tc:GetControler()
		local seq=tc:GetSequence()
		local loc=tc:GetLocation()
		if loc==LOCATION_SZONE and seq>=5 then Duel.SendtoGrave(tc,REASON_EFFECT) return end
		if tc:IsControler(1-tp) then
			if seq<5 then
				seq=4-seq
			else
				seq=11-seq
			end
		end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and e:GetHandler():IsType(TYPE_FUSION) then
			local sg=Duel.GetMatchingGroup(c29065602.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,p,seq,loc)
			if #sg>0 then Duel.Destroy(sg,REASON_EFFECT) end
		end
	end
end
