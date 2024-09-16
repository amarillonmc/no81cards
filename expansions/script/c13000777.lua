--夕阳感怀
local m=13000777
local cm=_G["c"..m]
function c13000777.initial_effect(c)
	aux.EnablePendulumAttribute(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.rptg)
	e1:SetOperation(cm.rpop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if chk==0 then return rg:CheckSubGroup(cm.fselect,2,2,tp) end
	local sg=rg:SelectSubGroup(tp,cm.fselect,true,2,2,tp)
	Duel.SendtoGrave(sg,REASON_COST)
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.fselect(g,tp)
	return g:GetClassCount(Card.GetAttribute)==#g
end
function cm.filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.spop)
	e1:SetCondition(cm.spcon)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local cg=g:GetFirst():GetColumnGroup()
		if #cg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local lg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
			Duel.SendtoGrave(lg,REASON_EFFECT)
		end
	end
end
function cm.filter2(c,g)
	return g:IsContains(c)
end
function cm.rpfilter(c,e,tp)
	return (c:IsCode(13000774) or c:IsCode(13000775) or c:IsCode(13000776)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rpfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then   
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.rpfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end