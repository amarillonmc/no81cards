--撕裂的悔恨
function c19210014.initial_effect(c)
	aux.AddCodeList(c,19210000)
	aux.AddSetNameMonsterList(c,0xb56)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19210014+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c19210014.target)
	e1:SetOperation(c19210014.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19210014,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c19210014.rmtg)
	e2:SetOperation(c19210014.rmop)
	c:RegisterEffect(e2)
end
function c19210014.tfilter(c,e,tp)
	return (c:IsSetCard(0xb56) or aux.IsSetNameMonsterListed(c,0xb56)) and c:IsFaceup() and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c19210014.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c19210014.spfilter(c,e,tp,tc)
	return (c:IsSetCard(0xb56) or aux.IsSetNameMonsterListed(c,0xb56))
		and not c:IsAttribute(tc:GetAttribute()) and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,tc)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0)
end
function c19210014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19210014.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c19210014.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c19210014.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c19210014.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sg=Duel.GetMatchingGroup(c19210014.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,tc)
	if not tc:IsRelateToChain() or tc:IsFacedown() or Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 or tc:IsReason(REASON_REDIRECT) or not tc:IsLocation(LOCATION_REMOVED) or #sg==0 then return end-- or Duel.GetMZoneCount(tp)<=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
end
function c19210014.rmfilter(c)
	return c:IsCode(19210000) and c:IsFaceup() and c:IsAbleToRemove()
end
function c19210014.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19210014.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19210014.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c19210014.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c19210014.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsType(TYPE_MONSTER) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and not tc:IsReason(REASON_REDIRECT) and tc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		Duel.ReturnToField(tc)
	end
end
