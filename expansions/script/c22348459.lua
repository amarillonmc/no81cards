--天使的堕临
local m=22348459
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348459+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22348459.cost)
	e1:SetTarget(c22348459.target)
	e1:SetOperation(c22348459.operation)
	c:RegisterEffect(e1)
	
end
function c22348459.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c22348459.costfilter(c,e,tp)
	return c:GetLevel()>0 and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c22348459.spfilter,tp,LOCATION_DECK,0,1,nil,c,e,tp)
end
function c22348459.spfilter(c,tc,e,tp)
	return c:GetLevel()==tc:GetLevel() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY) and c:GetAttack()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348459.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local jg=Duel.GetReleaseGroup(tp,true):Filter(c22348459.costfilter,nil,e,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and #jg>0
	end
	e:SetLabel(0)
	local g=jg:Select(tp,1,1,nil)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348459.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348459.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and g:GetFirst():GetAttack()>0 and  g:GetFirst():IsAttribute(ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		Duel.Recover(tp,g:GetFirst():GetAttack(),REASON_EFFECT)
	end
end