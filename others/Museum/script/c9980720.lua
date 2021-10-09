--蔡徐鲲
function c9980720.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980720.sumsuc)
	c:RegisterEffect(e8)
	--bounce and summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980720,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980720)
	e1:SetTarget(c9980720.target)
	e1:SetOperation(c9980720.operation)
	c:RegisterEffect(e1)
end
function c9980720.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980720,0))
end 
function c9980720.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToHand()
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9980720.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c9980720.spfilter(c,e,tp,tc)
	return c:IsType(TYPE_NORMAL) and c:IsLevel(tc:GetLevel())
		and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980720.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9980720.thfilter(chkc,e,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9980720.thfilter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9980720.thfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9980720.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9980720.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980720,0))
		end
	end
end
