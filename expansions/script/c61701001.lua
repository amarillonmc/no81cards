--终末鸟
function c61701001.initial_effect(c)
	aux.AddCodeList(c,61701001)
	c:SetUniqueOnField(1,0,61701001)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c61701001.ovfilter,aux.Stringid(61701001,0),3,c61701001.xyzop)
	c:EnableReviveLimit()
	--overlay
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(61701001,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,61701001)
	e1:SetTarget(c61701001.ovtg)
	e1:SetOperation(c61701001.ovop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1152)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,61701002)
	e2:SetTarget(c61701001.sptg)
	e2:SetOperation(c61701001.spop)
	c:RegisterEffect(e2)
end
function c61701001.ovfilter(c)
	return c:IsLinkAbove(3) and c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701001.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,61701001)==0 end
	Duel.RegisterFlagEffect(tp,61701001,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c61701001.ofilter(c,e)
	return c:IsCode(61701013,61701014,61701015) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and c:IsFaceupEx() and not c:IsHasEffect(61701001)
end
function c61701001.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c61701001.ofilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c61701001.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c61701001.ofilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e):GetFirst()
		if tc then
			Duel.Overlay(c,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(61701001)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,tc:GetCode()))
			Duel.RegisterEffect(e1,tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function c61701001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c61701001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
