--智障女神 阿库娅－(注：狸子DIY)
function c77770016.initial_effect(c)
    --Remove(神圣驱魔)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77770016,0))
	e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c77770016.cost)
	e1:SetTarget(c77770016.target)
	e1:SetOperation(c77770016.operation)
	c:RegisterEffect(e1)
		--summon(职业特性)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77770016,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c77770016.ntcon)
	c:RegisterEffect(e2)
		--immune(对天敌抗性)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77770016.efilter)
	c:RegisterEffect(e3)
		--immune(对天敌抗性2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77770016.efilter2)
	c:RegisterEffect(e4)
		--battle indestructable(对天敌抗性3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c77770016.batfilter)
	c:RegisterEffect(e5)
		--return control (神之怒)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c77770016.retcon)
	e6:SetTarget(c77770016.rettg)
	e6:SetOperation(c77770016.retop)
	c:RegisterEffect(e6)
	end
function c77770016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c77770016.filter(c)
	return c:IsRace(RACE_FIEND+RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TOKEN) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c77770016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c77770016.copyfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c77770016.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77770016.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c77770016.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
		
	end
end
function c77770016.ntfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c77770016.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77770016.ntfilter,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c77770016.efilter(e,te)
	return te:GetHandler():IsCode(4064256,34989413,74701381)
end
function c77770016.efilter2(e,te)
	return te:GetHandler():IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c77770016.batfilter(e,c)
	return c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c77770016.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c77770016.refilter(c)
	return c:GetControler()~=c:GetOwner()
end
function c77770016.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND+RACE_ZOMBIE)
end
function c77770016.tfilter(c)
	return not c:IsAbleToRemove()
end
function c77770016.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if chk==0 then
    local g=Duel.GetMatchingGroup(c77770016.filter,tp,0,LOCATION_MZONE,nil)
		return g:GetCount()>0 and not g:IsExists(c77770016.tfilter,1,nil)
	end
    local g=Duel.GetMatchingGroup(c77770016.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c77770016.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c77770016.filter,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end