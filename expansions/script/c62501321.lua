--御巫的连环舞
function c62501321.initial_effect(c)
	--activate
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	c:SetUniqueOnField(1,0,62501321)
	--effect indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetCondition(c62501321.eqcon)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501321,2))
	e3:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,62501321)
	e3:SetTarget(c62501321.sptg)
	e3:SetOperation(c62501321.spop)
	c:RegisterEffect(e3)
end
function c62501321.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and not ec:IsSetCard(0x18d)
end
function c62501321.spfilter(c,e,tp,ec,chk)
	return c:IsSetCard(0x18d) and c:GetOriginalCodeRule()~=ec:GetOriginalCodeRule() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501321.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	if chk==0 then return ec and Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c62501321.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,ec,0) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,ec) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c62501321.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c62501321.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,ec,1):GetFirst()
	if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 or not e:GetHandler():IsRelateToChain() then end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc or not Duel.Equip(tp,e:GetHandler(),tc) or not ec:IsLocation(LOCATION_MZONE) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(62501321,0)) and Duel.Equip(tp,ec,sc,false) then
		--Add Equip limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetLabelObject(sc)
		e1:SetValue(c62501321.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end
function c62501321.eqlimit(e,c)
	return e:GetHandler():GetEquipTarget()==e:GetLabelObject()
end
