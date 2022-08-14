local m=25000015
local cm=_G["c"..m]
cm.name="喧哗与骚动"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil)
end
function cm.rfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsReleasableByEffect()
end
function cm.fselect(g,tp,c,scale)
	if scale==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(cm.GetScale,scale) and Duel.GetLocationCountFromEx(tp,tp,g,c)
end
function cm.filter(c,e,tp,g,f)
	return c:IsType(TYPE_PENDULUM) and c:IsFacedown() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(cm.fselect,2,99,tp,c,f(c))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,cm.GetScale)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg,cm.GetScale):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectSubGroup(tp,cm.fselect,false,2,99,tp,tc,tc:GetLeftScale()+tc:GetRightScale())
		if not mat or mat:GetCount()==0 then return end
		if Duel.Release(mat,REASON_EFFECT)==0 then return end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.GetScale(c)
	local x=c:GetLeftScale()+c:GetRightScale()
	if x>MAX_PARAMETER then return MAX_PARAMETER else return x end
end
