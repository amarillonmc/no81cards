--神代丰的铁骑 暴风铃鹿
function c64800103.initial_effect(c)
	aux.AddMaterialCodeList(c,64800097)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c64800103.matfilter1,nil,nil,c64800103.matfilter2,1,99)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800103,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c64800103.discon)
	e1:SetTarget(c64800103.distg)
	e1:SetOperation(c64800103.disop)
	c:RegisterEffect(e1)
end
function c64800103.matfilter1(c)
	return c:IsCode(64800097)
end
function c64800103.matfilter2(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSetCard(0x641a) and c:GetSummonLocation()==LOCATION_EXTRA)
end

--e1
function c64800103.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c64800103.eqfilter(c,tp)
	return c:IsCode(64800097) and not c:IsForbidden()
end
function c64800103.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c64800103.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c64800103.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64800103.eqfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,false) then return end  
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c64800103.eqlimit)
			tc:RegisterEffect(e1)
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c64800103.eqlimit(e,c)
	return e:GetOwner()==c
end