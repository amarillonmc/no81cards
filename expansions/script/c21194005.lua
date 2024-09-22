--双炮弹丸枪管龙
function c21194005.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2,c21194005.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21194005)
	e1:SetCondition(c21194005.con)
	e1:SetTarget(c21194005.tg)
	e1:SetOperation(c21194005.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21194006)
	e2:SetTarget(c21194005.tg2)
	e2:SetOperation(c21194005.op2)
	c:RegisterEffect(e2)
end
function c21194005.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x102)
end
function c21194005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c21194005.q(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function c21194005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21194005.q,tp,0x12,0,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c21194005.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21194005.q,tp,0x12,0,nil,e,tp)
	if #g<=0 then return end
	local g1=g:Filter(Card.IsLocation,nil,2)
	local g2=g:Filter(Card.IsLocation,nil,0x10)
	if #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(21194005,0)) then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local sg=g1:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	if Duel.GetLocationCount(tp,4)<=0 then return end
	if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(21194005,1)) then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local sg=g2:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c21194005.w(c)
	return c:IsSetCard(0x102) and c:IsFaceup()
end
function c21194005.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21194005.w,tp,4,0,1,nil) and Duel.IsExistingMatchingCard(c21194005.q,tp,1,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c21194005.w,tp,4,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,1)
end
function c21194005.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c21194005.q,tp,1,0,1,1,nil,e,tp)	
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
	end
end