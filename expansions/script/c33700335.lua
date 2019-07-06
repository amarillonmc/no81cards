--阻抗神经 碧蓝雷贝卡
function c33700335.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5449),2,true)   
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700335,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,33700335)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c33700335.sptg)
	e1:SetOperation(c33700335.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c33700335.destg)
	e2:SetValue(c33700335.value)
	e2:SetOperation(c33700335.desop)
	c:RegisterEffect(e2)
end
function c33700335.repfilter(c)
	return c:IsRace(RACE_ROCK) and c:IsAbleToGrave()
end
function c33700335.dfilter(c,e)
	return c33700335.value(e,c)
end
function c33700335.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33700335.dfilter,1,nil,e) end
	return true
end
function c33700335.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsAbleToHand() and c:IsOnField() and c:IsSetCard(0x5449)
end
function c33700335.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33700335.dfilter,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_COST)
end
function c33700335.filter(c,e,tp,zone)
	return c:IsSetCard(0x5449) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c33700335.get_zone(c,tp)
	local zone=0
	local lg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return zone
end
function c33700335.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=c33700335.get_zone(e:GetHandler(),tp)
	if chk==0 then return zone>0
		and Duel.IsExistingMatchingCard(c33700335.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c33700335.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c33700335.get_zone(c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33700335.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,zone):GetFirst()
	if tc then
	   Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	   Duel.SpecialSummonComplete()
	end
end

