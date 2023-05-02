--闪光No.39 黄金狮子霍普雷
function c98920550.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,c98920550.ovfilter,aux.Stringid(98920550,0),2,nil)
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(c98920550.atkval)
	c:RegisterEffect(e5)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920550.discon)
	e3:SetCost(c98920550.discost)
	e3:SetTarget(c98920550.distg)
	e3:SetOperation(c98920550.disop)
	c:RegisterEffect(e3)
end
aux.xyz_number[98920550]=39 
function c98920550.ovfilter(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(52653092,56832966,86532744,56840427)
end
function c98920550.atkval(e,c)
	return e:GetHandler():GetEquipCount()
end
function c98920550.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98920550.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920550.eqfilter(c,tp)
	return c:IsSetCard(0x107e) and c:IsType(TYPE_MONSTER) and c.zw_equip_monster and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c98920550.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c98920550.eqfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND)
end
function c98920550.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c98920550.eqfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if not tc then return end
		tc.zw_equip_monster(tc,tp,c)
	end
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c98920550.efilter)
		c:RegisterEffect(e1)
end
function c98920550.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end