--魔创炼金·卡莉欧斯特萝
function c72411490.initial_effect(c)
		aux.AddCodeList(c,72411270,72411500)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()
		--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72411490)
	e1:SetCost(c72411490.thcost)
	e1:SetTarget(c72411490.thtg)
	e1:SetOperation(c72411490.thop)
	c:RegisterEffect(e1)
	--search def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72411490,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72411491)
	e2:SetTarget(c72411490.target1)
	e2:SetOperation(c72411490.operation1)
	c:RegisterEffect(e2)
end
function c72411490.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c72411490.cfilter(c)
	return c:IsFaceup() and c:IsCode(72411270)
end
function c72411490.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCode(72411500)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c72411490.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) and Duel.IsExistingMatchingCard(c72411490.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) 
		and Duel.IsExistingMatchingCard(c72411490.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c72411490.thop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local gd=Duel.SelectMatchingCard(tp,c72411490.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	if Duel.Destroy(gd,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c72411490.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			tc:RegisterEffect(e1,true)
		end
	end
end
function c72411490.filter1(c,tp)
	return c:IsCode(72411270) and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c72411490.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c72411490.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c72411490.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) or  Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,c))then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c72411490.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsFaceup() and c:IsType(TYPE_XYZ) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD) 
			local gx=Duel.SelectMatchingCard(tp,aux.TURE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
			Duel.Overlay(c,gx)
		end
	end
end