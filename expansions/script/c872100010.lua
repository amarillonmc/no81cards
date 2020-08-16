--永夜抄·老板娘
function c872100010.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c872100010.matfilter,1,1)
 --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(872100010,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,872100010)
	e5:SetTarget(c872100010.destg)
	e5:SetOperation(c872100010.desop)
	c:RegisterEffect(e5)
--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(872100010,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetCountLimit(1,872100011)
	e4:SetTarget(c872100010.sptg2)
	e4:SetOperation(c872100010.spop2)
	c:RegisterEffect(e4)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c872100010.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c872100010.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(872100010,0))
end
function c872100010.matfilter(c)
	return c:IsLinkSetCard(0xba1) and c:IsLevel(4)
end
function c872100010.thfilter(c)
	return c:IsSetCard(0xba1) and c:IsAbleToHand()
end
function c872100010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c872100010.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c872100010.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c872100010.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c872100010.spfilter(c,e,tp)
	return c:IsSetCard(0xba1) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c872100010.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c872100010.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c872100010.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c872100010.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
