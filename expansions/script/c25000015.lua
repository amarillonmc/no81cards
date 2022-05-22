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
	e2:SetCountLimit(1)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.rfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsReleasableByEffect()
end
function cm.fselect(g,tp,c,scale)
	if scale==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(cm.GetScale,scale) and Duel.GetLocationCountFromEx(tp,tp,g,c) and ((c:IsType(TYPE_FUSION) and aux.dncheck(g)) or (c:IsType(TYPE_SYNCHRO) and g:IsExists(Card.IsType,1,nil,TYPE_TUNER)) or (c:IsType(TYPE_XYZ) and g:GetClassCount(Card.GetLevel)==1))
end
function cm.filter(c,e,tp,g,f)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(cm.fselect,2,99,tp,c,f(c))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
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
		Duel.Release(mat,REASON_EFFECT)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) then
			local g=mat:Filter(Card.IsCanOverlay,nil)
			if #g>0 then Duel.Overlay(tc,g) end
		end
	end
end
function cm.GetScale(c)
	local x=c:GetLeftScale()+c:GetRightScale()
	if x>MAX_PARAMETER then return MAX_PARAMETER else return x end
end
