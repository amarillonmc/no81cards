--一人千面·亚森
function c40006887.initial_effect(c)
	c:SetUniqueOnField(1,0,40006887)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()   
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40006887,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c40006887.tecon)
	e1:SetTarget(c40006887.eqtg)
	e1:SetOperation(c40006887.eqop)
	c:RegisterEffect(e1)
	--spsummon link
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006887,1))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40006887)
	e2:SetCost(c40006887.spcost)
	e2:SetTarget(c40006887.sptg)
	e2:SetOperation(c40006887.spop)
	c:RegisterEffect(e2)  
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40006887,2))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c40006887.negcon)
	e3:SetTarget(c40006887.negtg)
	e3:SetOperation(c40006887.negop)
	c:RegisterEffect(e3)
	--spsummon count limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c40006887.eqcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c40006887.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c40006887.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c40006887.cfilter,1,nil,zone) and eg:GetCount()>0
end

function c40006887.tecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40006887.filter(c)
	return not c:IsCode(40006887) and c:IsSetCard(0xdf1d) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40006887.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40006887.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40006887.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c40006887.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40006887,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40006887.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<g:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c40006887.eqlimit)
		tc:RegisterEffect(e1)
		tc=g:GetNext()  
	end
	Duel.EquipComplete()
end
function c40006887.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40006887.costfilter(c,ec)
	return c:IsFaceup() and c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function c40006887.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006887.costfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40006887.costfilter,tp,LOCATION_SZONE,0,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c40006887.filter2(c)
	return not c:IsForbidden() and c:IsType(TYPE_MONSTER)
end
function c40006887.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40006887.filter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c40006887.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c40006887.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c40006887.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c40006887.eqlimit2)
		tc:RegisterEffect(e1)
	end
end
function c40006887.eqlimit2(e,c)
	return e:GetOwner()==c
end
function c40006887.negcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and eg:GetCount()>0
end
function c40006887.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c40006887.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
function c40006887.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(40006887,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c40006887.cefilter1(c)
	return c:IsType(TYPE_LINK)
end
function c40006887.econ1(e)
	local c=e:GetHandler()
	local eg=c:GetEquipGroup()
	return e:GetHandler():IsExtraLinkState() and #eg>0
end
function c40006887.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c40006887.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(40006888,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c40006887.cefilter(c)
	return c:IsType(TYPE_LINK)
end
function c40006887.econ2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40006887.cefilter,tp,LOCATION_MZONE,0,5,nil)
end