--3d伊吕波
function c65130339.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,7)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130339,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65130339)
	e1:SetTarget(c65130339.mttg)
	e1:SetOperation(c65130339.mtop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65130339.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c65130339.indtg(e,c)
	return c:IsAttack(878) and c:IsDefense(1157) and c:IsFaceup()
end
function c65130339.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttack(878) and c:IsDefense(1157)
end
function c65130339.mtfilter(c,e)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c65130339.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c65130339.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e) end
end
function c65130339.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c65130339.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
		Duel.BreakEffect()
		local og=c:GetOverlayGroup():Filter(c65130339.spfilter,nil,e,tp)
		if og:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(65130339,2))then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=og:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end
end