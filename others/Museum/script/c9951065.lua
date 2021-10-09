--第五特异点·北美神话大战 合众为一
function c9951065.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9951065,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c9951065.sptg)
	e6:SetOperation(c9951065.spop)
	c:RegisterEffect(e6)
	--tribute summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951065,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9951065.sumtg)
	e3:SetOperation(c9951065.sumop)
	c:RegisterEffect(e3)
   --double tribute
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c9951065.dttg)
	e4:SetValue(c9951065.dtval)
	c:RegisterEffect(e4)
end
function c9951065.sumfilter(c)
	return c:IsSetCard(0xba5) and c:IsSummonable(true,nil,1)
end
function c9951065.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951065.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9951065.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951065.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil,1)
	end
end
function c9951065.spfilter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsLevelAbove(9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951065.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951065.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9951065.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951065.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951065.dttg(e,c)
	return c:IsSetCard(0xba5) and (c:IsFaceup() or c:IsControler(e:GetHandlerPlayer()))
end
function c9951065.dtval(e,c)
	return c:IsSetCard(0xba5) and c:IsControler(e:GetHandlerPlayer())
end