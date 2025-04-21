--炼金工房精灵 莉拉·德西亚斯
function c75011010.initial_effect(c)
	aux.AddCodeList(c,12580477)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75011010)
	e1:SetTarget(c75011010.tgtg)
	e1:SetOperation(c75011010.tgop)
	c:RegisterEffect(e1)
	--spsummon-self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCountLimit(1,75011011)
	e2:SetCondition(c75011010.spcon)
	e2:SetTarget(c75011010.sptg)
	e2:SetOperation(c75011010.spop)
	c:RegisterEffect(e2)
end
function c75011010.tgfilter(c)
	return c:IsSetCard(0x75e) and c:IsAbleToGrave()
end
function c75011010.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75011010.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c75011010.tgfilter2(c)
	return c:IsCode(12580477) and c:IsAbleToGrave()
end
function c75011010.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c75011010.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c75011010.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c75011010.chkfilter(c,tp,rp)
	return c:IsPreviousControler(1-tp) and rp==tp
end
function c75011010.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75011010.chkfilter,1,nil,tp,rp)
end
function c75011010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c75011010.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c75011010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c75011010.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75011010,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),nil)
		end
	end
end
