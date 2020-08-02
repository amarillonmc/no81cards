local m=31400056
local cm=_G["c"..m]
cm.name="星兹大师巫女"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	e1:SetDescription(aux.Stringid(m,0))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	e2:SetDescription(aux.Stringid(m,1))
	c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xd2) and c:IsLevelAbove(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function cm.filterdes(c,e,tp,n)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0) and Duel.IsExistingMatchingCard(cm.filtersp,tp,LOCATION_DECK,0,1,nil,e,tp,c) and ((c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=n) or (c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=(n+1)))
end
function cm.filtersp(c,e,tp,tc)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and not c:IsRace(tc:GetRace()) and not c:IsLevel(tc:GetLevel()) and not c:IsAttribute(tc:GetAttribute()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	local num=0
	if tc:IsLocation(LOCATION_HAND) then
		num=1
	end
	local g=Duel.GetMatchingGroup(cm.filterdes,tp,LOCATION_HAND+LOCATION_MZONE,0,tc,e,tp,num)
	if Duel.IsExistingMatchingCard(cm.filtersp,tp,LOCATION_DECK,0,1,nil,e,tp,tc) and (tc:IsLocation(LOCATION_MZONE) or (tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) then
		g:AddCard(tc)
	end
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local num=0
	if tc:IsLocation(LOCATION_HAND) then
		num=1
	end
	local g=Duel.GetMatchingGroup(cm.filterdes,tp,LOCATION_HAND+LOCATION_MZONE,0,tc,e,tp,num)
	if Duel.IsExistingMatchingCard(cm.filtersp,tp,LOCATION_DECK,0,1,nil,e,tp,tc) and (tc:IsLocation(LOCATION_MZONE) or (tc:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) then
		g:AddCard(tc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local des=g:Select(tp,1,1,nil):GetFirst()
	if des then
		Duel.Destroy(des,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=Duel.SelectMatchingCard(tp,cm.filtersp,tp,LOCATION_DECK,0,1,1,nil,e,tp,des)
			local sp=spg:GetFirst()
			if sp then
				Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		if tc:IsLocation(LOCATION_HAND) then
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end