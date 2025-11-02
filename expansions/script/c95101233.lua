--暗黑能乐面具舞者 秦心
function c95101233.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),4,2)
	c:EnableReviveLimit()
	--change code
	aux.EnableChangeCode(c,95101209,LOCATION_MZONE,c95101233.cccon)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101233)
	e1:SetTarget(c95101233.eqtg)
	e1:SetOperation(c95101233.eqop)
	c:RegisterEffect(e1)
	--atk target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x34,0x34)
	e2:SetCondition(c95101233.effcon)
	e2:SetTarget(c95101233.efftg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c95101233.cccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c95101233.eqfilter(c)
	return c:IsAbleToChangeControler() and c:IsFaceup() and (c:GetOriginalType()&TYPE_MONSTER)==TYPE_MONSTER and not c:IsForbidden()
end
function c95101233.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c95101233.eqfilter,tp,0,LOCATION_ONFIELD,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,1-LOCATION_ONFIELD)
end
function c95101233.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c95101233.eqfilter,tp,0,LOCATION_ONFIELD,1,1,nil,c):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		if not Duel.Equip(tp,tc,c) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c95101233.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c95101233.eqlimit(e,c)
	return e:GetOwner()==c
end
function c95101233.effcon(e)
	return e:GetHandler():GetEquipTarget()
end
function c95101233.efftg(e,c)
	return c~=e:GetHandler()
end
