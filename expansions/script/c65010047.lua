--幻梦迷境领主 眠眠铃
function c65010047.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,99,c65010047.lcheck)
	c:EnableReviveLimit() 
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c65010047.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65010047,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c65010047.target)
	e3:SetOperation(c65010047.operation)
	c:RegisterEffect(e3)
end
function c65010047.filter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,c:GetLink(),nil)
end
function c65010047.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c65010047.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c65010047.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c65010047.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,g:GetFirst():GetLink(),tp,LOCATION_HAND)
end
function c65010047.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,tc:GetLink(),tc:GetLink(),nil)
	   if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
function c65010047.disable(e,c)
	local seq=aux.MZoneSequence(c:GetSequence())
	return Duel.IsExistingMatchingCard(c65010047.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,seq)
end
function c65010047.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and seq1==4-seq2
end
function c65010047.lcheck(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

