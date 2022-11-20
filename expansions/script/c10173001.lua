--神树的指引
function c10173001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10173001.target)
	e1:SetOperation(c10173001.activate)
	c:RegisterEffect(e1)	
end
function c10173001.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c10173001.thfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c10173001.thfilter(c,e,tp,sc)
	return c:IsAbleToHand() and c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute()) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c10173001.tdfilter,tp,LOCATION_GRAVE,0,3,c,e,sc)
end
function c10173001.tdfilter(c,e,sc)
	return c:IsAbleToDeck() and c:IsRace(sc:GetRace()) and c:IsAttribute(sc:GetAttribute()) and c:IsCanBeEffectTarget(e) and c~=sc
end
function c10173001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c10173001.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10173001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectTarget(tp,c10173001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectTarget(tp,c10173001.thfilter,tp,LOCATION_GRAVE,0,1,1,sg:GetFirst(),e,tp,sg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectTarget(tp,c10173001.tdfilter,tp,LOCATION_GRAVE,0,3,99,tg:GetFirst(),e,sg:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),tp,LOCATION_GRAVE)
end
function c10173001.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex,sg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex,tg=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local ex,dg=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	dg=dg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetFirst():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and tg:GetFirst():IsRelateToEffect(e) and Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 and dg:GetCount()>0 then
	   Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
