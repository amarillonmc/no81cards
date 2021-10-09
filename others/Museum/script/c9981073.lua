--青色眼睛的海马
function c9981073.initial_effect(c)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981073.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981073,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981073)
	e1:SetCost(c9981073.thcost)
	e1:SetTarget(c9981073.thtg)
	e1:SetOperation(c9981073.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981073,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99810730)
	e1:SetTarget(c9981073.sptg2)
	e1:SetOperation(c9981073.spop2)
	c:RegisterEffect(e1)
	--Special Summon from Grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981073,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99810730)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9981073.sptg)
	e2:SetOperation(c9981073.spop)
	c:RegisterEffect(e2)
end
function c9981073.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981073,0))
end
function c9981073.filter2(c,e,tp)
	return c:IsLevelBelow(8) and c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981073.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9981073.filter2,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c9981073.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981073.filter2,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		g:AddCard(e:GetHandler())
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9981073.spfilter2(c,e,tp)
	return c:IsLevelBelow(8) and c:IsSetCard(0xdd) and not c:IsCode(9981073)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9981073.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9981073.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9981073.spfilter2,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9981073.spfilter2,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9981073.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c9981073.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9981073.thfilter(c,g)
	return c:IsAbleToHand() and g:IsContains(c)
end
function c9981073.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981073.thfilter,tp,0,LOCATION_ONFIELD,1,nil,cg) end
	local g=Duel.GetMatchingGroup(c9981073.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9981073.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c9981073.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981073,0))
end