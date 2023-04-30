--逢华之魔妖-雪女不知火
function c98920051.initial_effect(c)
	c:SetUniqueOnField(1,0,98920051)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,99,c98920051.lcheck)
	c:EnableReviveLimit()
	 --act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c98920051.chainop)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920051)
	e1:SetTarget(c98920051.target)
	e1:SetOperation(c98920051.activate)
	c:RegisterEffect(e1)
end
function c98920051.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_SYNCHRO)
end
function c98920051.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRace(RACE_ZOMBIE) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(c98920051.chainlm)
	end
end
function c98920051.chainlm(e,rp,tp)
	return tp==rp
end
function c98920051.desfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO) and lv>0 and Duel.IsExistingMatchingCard(c98920051.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv,c)
end
function c98920051.spfilter(c,e,tp,lv,rc)
	if not (c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv+1,lv+2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
end
function c98920051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c98920051.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920051.desfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98920051.desfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920051.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98920051.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalLevel())
		if #sg>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end