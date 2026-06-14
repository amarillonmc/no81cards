--踏沙铁车 艾布拉姆斯
function c9910443.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c9910443.ovfilter,aux.Stringid(9910443,0))
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c9910443.atkcon)
	e2:SetValue(2500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9910443.descon)
	e3:SetCost(c9910443.descost)
	e3:SetTarget(c9910443.destg)
	e3:SetOperation(c9910443.desop)
	c:RegisterEffect(e3)
end
function c9910443.filter(c)
	return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and c:IsRace(RACE_MACHINE) or (c:IsLocation(LOCATION_SZONE) and bit.band(c:GetOriginalRace(),RACE_MACHINE)~=0)
end
function c9910443.ovfilter(c)
	local g=c:GetColumnGroup()
	g:AddCard(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and g:IsExists(c9910443.filter,3,nil)
end
function c9910443.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c9910443.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c9910443.rmfilter(c)
	return c:IsFaceupEx() and c:IsAbleToRemoveAsCost() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
		and c:IsRace(RACE_MACHINE) or (c:IsLocation(LOCATION_SZONE) and bit.band(c:GetOriginalRace(),RACE_MACHINE)~=0)
end
function c9910443.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt1=e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
	local opt2=Duel.IsExistingMatchingCard(c9910443.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,re:GetHandler())
	if chk==0 then return opt1 or opt2 end
	local result=0
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(9910443,1),aux.Stringid(9910443,2)) end
	if result==0 then
		e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910443.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,re:GetHandler())
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c9910443.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c9910443.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
