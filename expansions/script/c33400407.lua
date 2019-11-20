--鸢一折纸 魔王之影
function c33400407.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400407,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c33400407.eqcon)
	e2:SetTarget(c33400407.eqtg)
	e2:SetOperation(c33400407.eqop)
	c:RegisterEffect(e2)
	 --negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33400407.discon)
	e3:SetCost(c33400407.discost)
	e3:SetTarget(c33400407.distg)
	e3:SetOperation(c33400407.disop)
	c:RegisterEffect(e3)
end
function c33400407.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400407.filter(c,e,tp,ec)
	return ((c:IsSetCard(0x6343) and c:IsType(TYPE_EQUIP)) or c:IsSetCard(0x5343)) and c:CheckUniqueOnField(tp)
end
function c33400407.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400407.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,0,0,0,0)
end
function c33400407.eqop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400407.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0  then return false end
	local g=Duel.GetMatchingGroup(c33400407.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	local tc=g1:GetFirst() 
	 Duel.Equip(tp,tc,e:GetHandler())
   if tc:IsSetCard(0x5343) then
	   local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c33400407.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)	 
   end
end
function c33400407.eqlimit(e,c)
	 return e:GetOwner()==c
end

function c33400407.discon(e,tp,eg,ep,ev,re,r,rp)
	local zg=e:GetHandler():GetEquipGroup()
	return (zg:IsExists(Card.IsSetCard,1,nil,0x6343) or zg:IsExists(Card.IsSetCard,1,nil,0x5343)) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c33400407.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function c33400407.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33400407.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,c33400407.disfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Destroy(g2,REASON_EFFECT)
end
function c33400407.disfilter(c)
	return c:IsSetCard(0x5343) or c:IsSetCard(0x6343) or c:IsSetCard(0x5342)
end