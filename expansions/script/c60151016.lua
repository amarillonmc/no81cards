--叛逆的魔女 晓美焰
function c60151016.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5b23),3,3)
	--spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c60151016.linklimit)
    c:RegisterEffect(e1)
	--disable and destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetCondition(c60151016.condition)
	e2:SetOperation(c60151016.disop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60151016.discon)
	e3:SetTarget(c60151016.distg)
	e3:SetOperation(c60151016.disop2)
	c:RegisterEffect(e3)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetCondition(c60151016.immcon)
	e5:SetValue(c60151016.efilter)
	c:RegisterEffect(e5)
    --effect gain
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c60151016.regcon)
    e4:SetOperation(c60151016.regop)
    c:RegisterEffect(e4)
end
function c60151016.linklimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c60151016.ccfilter2(c)
    return c:IsSetCard(0x5b23) and c:IsType(TYPE_XYZ)
end
function c60151016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1 and e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter2,nil)>0
end
function c60151016.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	Duel.NegateEffect(ev)
end
function c60151016.ccfilter3(c)
    return c:IsSetCard(0x5b23) and c:IsType(TYPE_LINK)
end
function c60151016.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and tp~=ep 
		and e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter3,nil)>0
end
function c60151016.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c60151016.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		local tc=eg:GetFirst()
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			tc:CancelToGrave()
		end
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c60151016.ccfilter(c)
    return c:IsSetCard(0x5b23) and c:IsRace(RACE_SPELLCASTER)
end
function c60151016.immcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<2 and e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter,nil)>0
end
function c60151016.efilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:IsHasType(EFFECT_TYPE_ACTIVATE) then return true end
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then return true end
end
function c60151016.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c60151016.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter,nil)>0 then
        c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60151016,0))
    end
    if e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter2,nil)>0 then
        c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60151016,1))
    end
    if e:GetHandler():GetMaterial():FilterCount(c60151016.ccfilter3,nil)>0 then
        c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60151016,2))
    end
end