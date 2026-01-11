--虹彩偶像舞台 深渊焰火
function c9910365.initial_effect(c)
	aux.AddCodeList(c,9910363)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9910365.activate)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9910365.sumlimit)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9910365)
	e3:SetTarget(c9910365.sptg)
	e3:SetOperation(c9910365.spop)
	c:RegisterEffect(e3)
end
function c9910365.thfilter(c)
	return c:IsCode(9910363) and c:IsAbleToHand()
end
function c9910365.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910365.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910365,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910365.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c9910365.thfilter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0x5951) and c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function c9910365.gselect(g,e,tp)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.IsExistingMatchingCard(c9910365.spfilter,tp,LOCATION_HAND,0,1,nil,#g,e,tp)
end
function c9910365.spfilter(c,lv,e,tp)
	return c:IsSetCard(0x5951) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910365.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9910365.thfilter2(chkc,e) end
	local g=Duel.GetMatchingGroup(c9910365.thfilter2,tp,LOCATION_ONFIELD,0,nil,e)
	if chk==0 then return #g>0 and g:CheckSubGroup(c9910365.gselect,1,#g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c9910365.gselect,false,1,#g,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910365.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.AdjustAll()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910365.spfilter,tp,LOCATION_HAND,0,1,nil,ct,e,tp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9910365.spfilter,tp,LOCATION_HAND,0,1,1,nil,ct,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
