--传奇布里
function c25800062.initial_effect(c)
		   --link summon
	aux.AddLinkProcedure(c,nil,2,2,c25800062.lcheck)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800062,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,25800062)
	e1:SetCondition(c25800062.hspcon)
	e1:SetTarget(c25800062.sumtg)
	e1:SetOperation(c25800062.sumop)
	c:RegisterEffect(e1)
end
function c25800062.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x211)
end
----
function c25800062.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c25800062.filter(c,e,sp)
	return  c:IsSetCard(0x6211)  and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c25800062.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25800062.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c25800062.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c25800062.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end