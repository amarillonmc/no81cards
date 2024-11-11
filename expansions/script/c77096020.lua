--鲜血升变
local m=77096020
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,77096005)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.f(c,e,tp)
	local ck1=c:IsCode(77096005)
	local ck2=c:IsFaceup()
	local ck3=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	if c:IsControler(tp) then
		return c:IsReleasable() and ck1 and ck3
	else
		return c:IsReleasable() and ck1 and ck2 and ck3
	end   
end
function cm.filter2(c,e,tp,mc)
	local ck1=c:IsAttribute(ATTRIBUTE_DARK)
	local ck2=c:IsRace(RACE_FIEND)
	local ck3=c:IsAttack(2999) and c:IsDefense(2999)
	local ck4=c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	local ck5=Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	return ck1 and ck2 and ck3 and ck4 and ck5
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(cm.f,1-tp,LOCATION_MZONE,0,nil,e,tp)
	g:Merge(g1)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return #g>0
	end
	local rg=g:FilterSelect(tp,cm.f,1,1,nil,e,tp)
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end