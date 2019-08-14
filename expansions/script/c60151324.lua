--后光 圣白莲
function c60151324.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),12,2,c60151324.ovfilter,aux.Stringid(60151324,0),3,c60151324.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151324,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151324.descon)
	e1:SetTarget(c60151324.destg)
	e1:SetOperation(c60151324.desop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151324,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c60151324.thcost)
	e2:SetOperation(c60151324.thop)
	c:RegisterEffect(e2)
	--equip effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c60151324.tgvalue)
	e4:SetCondition(c60151324.con)
	c:RegisterEffect(e4)
end
function c60151324.ovfilter(c)
	return c:IsFaceup() and c:GetCode()~=60151324 and (c:GetLevel()==12 or c:GetRank()==12) and c:IsSetCard(0xcb23)
end
function c60151324.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60151324.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151324.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function c60151324.filter(c)
	return true
end
function c60151324.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151324,3))
		local sg=Duel.SelectMatchingCard(tp,c60151324.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,ft,ft,nil)
		local tc=sg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,e:GetHandler(),false,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_EQUIP_LIMIT)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(c60151324.eqlimit2)
			tc:RegisterEffect(e3)
			tc=sg:GetNext()
		end
		Duel.EquipComplete()
	end
end
function c60151324.eqlimit2(e,c)
	return e:GetOwner()==c
end
function c60151324.cfilter(c)
	return c:IsSetCard(0xcb23)
end
function c60151324.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c60151324.cfilter,1,nil)
end
function c60151324.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
		and c:GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		e:SetLabel(0)
	end
	if tc:IsType(TYPE_SPELL) then
		e:SetLabel(1)
	end
	if tc:IsType(TYPE_TRAP) then
		e:SetLabel(2)
	end
end
function c60151324.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetValue(c60151324.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetValue(c60151324.aclimit2)
	else e1:SetValue(c60151324.aclimit3) end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c60151324.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c60151324.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function c60151324.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function c60151324.cfilter2(c)
	return c:IsSetCard(0xcb23) and c:IsType(TYPE_XYZ)
end
function c60151324.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c60151324.cfilter2,1,nil)
end
function c60151324.tgvalue(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c60151324.con(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg:IsSetCard(0xcb23) and tg:IsType(TYPE_MONSTER)
end