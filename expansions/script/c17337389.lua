--小国王
local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(s.acttg)
	e0:SetOperation(s.actop)
	c:RegisterEffect(e0)
	local e_limit=Effect.CreateEffect(c)
	e_limit:SetType(EFFECT_TYPE_SINGLE)
	e_limit:SetCode(EFFECT_EQUIP_LIMIT)
	e_limit:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e_limit:SetValue(s.eqlimit)
	c:RegisterEffect(e_limit)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.eqcon2) 
	e2:SetTarget(s.eqtg2)
	e2:SetOperation(s.eqop2)
	c:RegisterEffect(e2)
end
function s.eqfilter(c)
	if c:IsCode(17337388) then return true end
	local g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_MZONE,LOCATION_MZONE,nil,17337388)
	for tc in aux.Next(g) do
		if tc:GetLinkedGroup():IsContains(c) then return true end
	end
	return false
end
function s.eqlimit(e,c)
	return s.eqfilter(c)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and s.eqfilter(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,function(c) return c:IsFaceup() and s.eqfilter(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsCode(17337388)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
		and (not re or re:GetHandler()~=c)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local has_return_by_death = Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_ONFIELD,1,nil,17337399)
	if not has_return_by_death then
		Duel.SetChainLimit(s.chlimit)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(function(c) return c:IsCode(id) and not c:IsForbidden() end),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,function(c) return c:IsFaceup() and s.eqfilter(c) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tgc=tg:GetFirst()
		if tgc then
			Duel.Equip(tp,tc,tgc)
		end
	end
end