local m=15004414
local cm=_G["c"..m]
cm.name="织炎鸟-煌星翼"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	c:EnableReviveLimit()
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,15004414)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_WINDBEAST) and c:IsLinkAttribute(ATTRIBUTE_FIRE)
end
function cm.descfilter(c,e,tp,ec)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceup() and c:IsControler(tp) and ec:GetLinkedGroup():IsContains(c) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,nil)
end
function cm.spfilter(c,e,tp,sc,g)
	return c:IsSetCard(0xaf31) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((sc and not c:IsCode(sc:GetCode())) or (g and g:FilterCount(Card.IsCode,nil,c:GetCode())<g:GetCount()))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ag=eg:Filter(cm.descfilter,nil,e,tp,e:GetHandler())
	if chk==0 then return eg:IsExists(cm.descfilter,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,ag,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:Filter(cm.descfilter,nil,e,tp,e:GetHandler())
	if #ag>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		ag=ag:Select(tp,1,1,nil)
	end
	local tc=ag:GetFirst()
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetMZoneCount(tp)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc,nil):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end