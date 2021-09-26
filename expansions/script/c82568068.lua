--王棋升变—黑青怒火
function c82568068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82568068)
	e1:SetTarget(c82568068.xyztg)
	e1:SetOperation(c82568068.xyzop)
	c:RegisterEffect(e1)
end
function c82568068.tkfilter(c)
	return (c:IsType(TYPE_XYZ) or c:IsCode(82567812)) and c:IsFaceup()
end
function c82568068.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsType(TYPE_XYZ) or chkc:IsCode(82567812)) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568068.tkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568068.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c82568068.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return false end
	c:CancelToGrave()
	Duel.Overlay(tc,Group.FromCards(c))
	--rank up/down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568068,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c82568068.cost)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetTarget(c82568068.target)
	e1:SetOperation(c82568068.operation)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82568068,0))
	
end
function c82568068.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568068.filter(c,e,tp,mc)
	return c:IsRankBelow(5) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
		and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c82568068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c82568068.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82568068.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82568068.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local tc=g:GetFirst()
		if tc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()>0 then
				Duel.Overlay(tc,mg)
			end
			tc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(tc,Group.FromCards(c))
			if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			tc:AddCounter(0x5825,3)
			end
		end
	end
end