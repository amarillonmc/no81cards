--节点圆环之理
local m=14000129
local cm=_G["c"..m]
cm.named_with_Circlia=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE+LOCATION_HAND+LOCATION_DECK)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--[[immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE+LOCATION_HAND+LOCATION_DECK)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)]]
end
function cm.CIR(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Circlia
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not re:GetHandler():IsCode(m)
end
function cm.matfilter(c)
	return c:IsFaceup() and cm.CIR(c)
end
function cm.filter(c,e,tp,mg)
	local lk=#mg
	return cm.CIR(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLinkBelow(lk)--and c:IsLinkSummonable(mg)
end
function cm.spfilter(c,e,tp)
	return cm.CIR(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE,0,nil)
	local b1=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local op,bool=0,false
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.efilter(e,te)
	return te:IsActivated() and te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end