--逆元构造 凛冽
function c79029810.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.NonTuner(Card.IsRace,RACE_MACHINE),1)
	c:EnableReviveLimit()  
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c79029810.sumsuc)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c79029810.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,79029810)
	e3:SetCondition(c79029810.discon)
	e3:SetCost(c79029810.discost)
	e3:SetTarget(c79029810.distg)
	e3:SetOperation(c79029810.disop)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e4:SetTarget(c79029810.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c79029810.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xa991) then
		flag=flag|1
	end
	e:GetLabelObject():SetLabel(flag)
end
function c79029810.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,79029810)>0 then return end
	local c=e:GetHandler()
	local ct=c:GetMaterial():GetCount()
	if ct*2>=c:GetLevel() then return end
	if Duel.IsPlayerCanDiscardDeck(e:GetHandlerPlayer(),ct*2) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()&1==1 and Duel.SelectEffectYesNo(tp,c) then 
		Duel.RegisterFlagEffect(tp,79029810,RESET_PHASE+PHASE_END,0,1)
		if Duel.DiscardDeck(tp,ct*2,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-(ct*2))
			e1:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c79029810.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029810.costfilter(c)
	return c:IsSetCard(0xa991) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c79029810.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029810.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029810.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029810.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029810.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c79029810.tgtg(e,c)
	return c:IsSetCard(0xa991) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end