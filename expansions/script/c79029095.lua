--罗德岛·狙击干员-蓝毒
function c79029095.initial_effect(c)
	--summon with 2 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c79029095.ttcon)
	e1:SetOperation(c79029095.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c79029095.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)	  
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCost(c79029095.dscost)
	e5:SetOperation(c79029095.dsop)
	e5:SetCountLimit(1,79029095)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetTarget(c79029095.target)
	e6:SetCondition(c79029095.condition)
	e6:SetOperation(c79029095.activate)
	e6:SetCountLimit(1,79029095)
	c:RegisterEffect(e6)
end  
function c79029095.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=2 and Duel.CheckTribute(c,2)
end
function c79029095.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,2,2)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c79029095.setcon(e,c,minc)
	if not c then return true end
	return false
end
function c79029095.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	x=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_HAND,0,2,2,nil)
	Duel.SendtoGrave(x,REASON_COST+REASON_DISCARD)
end
function c79029095.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	e2:SetTarget(c79029095.distarget)
	c:RegisterEffect(e2)
end
function c79029095.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function c79029095.condition(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_HAND+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_DECK) and Duel.IsChainNegatable(ev) and rc:GetControler()~=tp
end
function c79029095.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029095.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end



