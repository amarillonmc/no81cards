--珊海环的真珠龙 哈里奥斯
function c67200519.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200519.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()	 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200519,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200519)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_TOGRAVE)
	e1:SetTarget(c67200519.target)
	e1:SetOperation(c67200519.activate)
	c:RegisterEffect(e1) 
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c67200519.actlimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3) 
	local e4=e2:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4) 
end
function c67200519.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200519.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c67200519.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c67200519.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingTarget(c67200519.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200519.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67200519.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
--

function c67200519.actlimit(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:GetSummonLocation()==LOCATION_GRAVE
end


