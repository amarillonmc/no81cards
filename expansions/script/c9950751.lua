--罗马·愚人节花嫁尼禄
function c9950751.initial_effect(c)
 --tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950751,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9950751)
	e2:SetCost(c9950751.thcost)
	e2:SetTarget(c9950751.thtg)
	e2:SetOperation(c9950751.thop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950751,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,99507510)
	e1:SetTarget(c9950751.target)
	e1:SetOperation(c9950751.operation)
	c:RegisterEffect(e1)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950751.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950751.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950751,0))
end
function c9950751.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9950751.thfilter(c)
	return c:IsSetCard(0xcba8) and not c:IsCode(9950751) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9950751.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950751.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950751.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950751.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9950751.filter(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsSetCard(0xba5) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c9950751.exfilter,tp,LOCATION_EXTRA,0,1,nil,lv+1,e,tp)
end
function c9950751.exfilter(c,lv,e,tp)
	return c:IsSetCard(0xcba8) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9950751.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950751.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9950751.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9950751.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950751.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	local rg=Group.FromCards(c,tc)
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9950751.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel()+1,e,tp)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
