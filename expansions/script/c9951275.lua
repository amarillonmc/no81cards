--fate·西杜丽
function c9951275.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,c9951275.mfilter,1,1)
	c:EnableReviveLimit()
   --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951275,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9951275)
	e1:SetCondition(c9951275.thcon)
	e1:SetTarget(c9951275.thtg)
	e1:SetOperation(c9951275.thop)
	c:RegisterEffect(e1)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951275,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,99512750)
	e2:SetCondition(c9951275.spcon)
	e2:SetTarget(c9951275.sptg)
	e2:SetOperation(c9951275.spop)
	c:RegisterEffect(e2)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951275.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951275.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951275,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951275,1))
end
function c9951275.mfilter(c)
	return c:IsLevelBelow(8) and c:IsLinkSetCard(0xba5) 
end
function c9951275.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9951275.thfilter(c)
	return c:IsSetCard(0x9ba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9951275.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9951275.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9951275.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9951275.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9951275.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9951275.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsReason(REASON_EFFECT) and rp==1-tp or c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp))
end
function c9951275.spfilter(c,e,tp)
	return c:IsSetCard(0x9ba5) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c9951275.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951275.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9951275.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9951275.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951275,2))
end
