--动物朋友 青龙 ～孤高的水波～
function c33711102.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsSetCard,0x442),nil,3,99)
	c:EnableReviveLimit() 
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(LOCATION_OVERLAY,0)
	e1:SetTarget(c33711102.rmtg)
	e1:SetValue(LOCATION_HAND)
	c:RegisterEffect(e1)
	--be mat
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33711102,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,33711102)
	e2:SetCost(c33711102.bmcost)
	e2:SetTarget(c33711102.bmtg)
	e2:SetOperation(c33711102.bmop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c33711102.reptg)
	c:RegisterEffect(e3)
end
function c33711102.rmtg(e,c)
	return e:GetHandler():GetOverlayGroup():IsContains(c)
end
function c33711102.bmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sum=e:GetHandler():GetOverlayGroup():GetCount()
	if chk==0 then return e:GetHandler():GetOverlayCount()>0
		and e:GetHandler():CheckRemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,e:GetHandler():GetOverlayCount(),e:GetHandler():GetOverlayCount(),REASON_COST)
	local sum1=e:GetHandler():GetOverlayGroup():GetCount()
	e:SetLabel(sum-sum1)
end
function c33711102.bmfilter(c,mc)
	return c:IsCanBeXyzMaterial(c,mc) and c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER)
end
function c33711102.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c33711102.bmfilter,tp,LOCATION_DECK,0,nil,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=e:GetHandler():GetOverlayCount() and e:GetHandler():IsType(TYPE_XYZ) end
end
function c33711102.bmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not e:GetHandler():IsType(TYPE_XYZ) then return end
	local num=e:GetLabel()
	local rg=Duel.GetMatchingGroup(c33711102.bmfilter,tp,LOCATION_DECK,0,nil,e:GetHandler())
	local g=Group.CreateGroup()
	Duel.BreakEffect()
	for i=1,num do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		if tc then
			g:AddCard(tc)
			rg:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Overlay(e:GetHandler(),g)
end
function c33711102.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if true then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end