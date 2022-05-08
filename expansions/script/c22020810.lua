--人理之基 齐格弗里德
function c22020810.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c22020810.eqtg)
	e1:SetOperation(c22020810.eqop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020810,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetCondition(c22020810.eqcon)
	e2:SetTarget(c22020810.disable)
	c:RegisterEffect(e2)
end
function c22020810.filter(c,ec)
	return c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function c22020810.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c22020810.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22020810.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22020810.filter),tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if not (tc and Duel.Equip(tp,tc,c)) then return end
	local atk=math.ceil(tc:GetTextAttack()/2)
	local def=math.ceil(tc:GetTextDefense()/2)
	if atk<0 then atk=0 end
	if def<0 then def=0 end
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22020810.eqlimit)
	tc:RegisterEffect(e1)
end
function c22020810.eqlimit(e,c)
	return e:GetOwner()==c
end
function c22020810.disable(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c22020810.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg:GetCount()>0
end