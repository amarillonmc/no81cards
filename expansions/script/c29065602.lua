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
	e3:SetDescription(aux.Stringid(29065602,2))
	e3:SetCategory(CATEGORY_DESTROY)
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
	return c:IsSetCard(0x7ad) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c29065602.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local g=Duel.GetMatchingGroup(c29065602.thfil,tp,LOCATION_DECK,0,1,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29065602,0)) then
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	end
end
function c29065602.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x7ad)  
end
function c29065602.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	if c:IsType(TYPE_FUSION) then
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
	else
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0) 
	end
end
function c29065602.tgfil1(c,seq,tc)
	local loc=tc:GetPreviousLocation()
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return cseq==seq or (cloc==loc and math.abs(cseq-seq)==1)
end

function c29065602.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Destroy(tc,REASON_EFFECT)
	local seq=tc:GetPreviousSequence()
	local g1=Duel.GetMatchingGroup(c29065602.tgfil1,tp,0,LOCATION_ONFIELD,nil,seq,tc)
	if c:IsType(TYPE_FUSION) and g1:GetCount()>0 then
	Duel.Destroy(g1,REASON_EFFECT)
	end 
end
























