--风神录-土著神的顶点
function c9980084.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x3bc6),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980084,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99800840)
	e1:SetCondition(c9980084.damcon)
	e1:SetTarget(c9980084.damtg)
	e1:SetOperation(c9980084.damop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980084,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCountLimit(1,9980084)
	e2:SetCondition(c9980084.spcon)
	e2:SetTarget(c9980084.sptg)
	e2:SetOperation(c9980084.spop)
	c:RegisterEffect(e2)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980084,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99800841)
	e1:SetCondition(c9980084.sumcon)
	e1:SetTarget(c9980084.sumtg)
	e1:SetOperation(c9980084.sumop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980084.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980084.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980084,0))
end
function c9980084.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 and ep~=tp
end
function c9980084.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980084.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c9980084.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9980084.damfilter(c)
	return c:IsFusionSetCard(0x3bc6) and c:GetBaseAttack()>0 and c:IsAbleToGrave()
end
function c9980084.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980084.damfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c9980084.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9980084.damfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Damage(1-tp,math.ceil(g:GetFirst():GetBaseAttack()),REASON_EFFECT)
	end
end
function c9980084.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9980084.spfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980084.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980084.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9980084.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980084.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
