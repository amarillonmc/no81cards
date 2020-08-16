--电拟神招 改 ～生如泡沫～
function c33701330.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33701330.cost)
	e1:SetTarget(c33701330.target)
	e1:SetOperation(c33701330.activate)
	c:RegisterEffect(e1)
end
function c33701330.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c33701330.filter(c,e,tp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local lv=c:GetOriginalLevel()
	return (c:IsSetCard(0x445) or c:IsSetCard(0x344c)) and g:CheckWithSumEqual(Card.GetLevel,lv,1,99)
end
function c33701330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33701330.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)   
end
function c33701330.activate(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c33701330.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local lv=tc:GetOriginalLevel()
	local g=g2:Filter(aux.TRUE,tc)
	local mat=g:SelectWithSumEqual(tp,Card.GetLevel,lv,1,99)
	tc:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	tc:CompleteProcedure()
end
	

