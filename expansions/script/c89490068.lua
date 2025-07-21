--灼经-「位阶超越」
local s,id,o=GetID()
function s.initial_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.sptgexfilter(c,e,tp,tc)
	return c:IsRace(tc:GetRace()) and c:IsRank(tc:GetLink()+1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:IsType(TYPE_XYZ)
end
function s.sptgfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsSetCard(0xc31) and c:IsCanOverlay() and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(s.sptgexfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.sptgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingTarget(s.sptgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.sptgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.ofilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsCanOverlay()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp)<=0 or not sc:IsRelateToChain() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.sptgexfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sc)
	local tc=sg:GetFirst()
	if not tc then return end
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	if s.ofilter(sc,e) then
		local og=Group.FromCards(sc)
		local xg=sc:GetLinkedGroup()
		if xg:FilterCount(s.ofilter,nil,e)==#xg and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then og:Merge(xg) end
		Duel.Overlay(tc,og)
	end
end
