--鹰身与幻之狮鹫
function c98920186.initial_effect(c)
	--fusion material
	aux.AddFusionProcCodeFun(c,76812113,{74852097,c98920186.mfilter},1,true,true)
	c:EnableReviveLimit()
--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920186,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920186.descon)
	e1:SetTarget(c98920186.destg)
	e1:SetOperation(c98920186.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c98920186.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
--cannot target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c98920186.indcon)
	e11:SetValue(aux.tgoval)
	c:RegisterEffect(e11)
	--indes
	local e2=e11:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
--atk down
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_FIELD)
	e21:SetCode(EFFECT_UPDATE_ATTACK)
	e21:SetRange(LOCATION_MZONE)
	e21:SetTargetRange(0,LOCATION_MZONE)
	e21:SetValue(c98920186.atkval)
	c:RegisterEffect(e21)
	local e2=e21:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920186,1))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c98920186.negcon)
	e4:SetCost(c98920186.negcost)
	e4:SetTarget(aux.nbtg)
	e4:SetOperation(c98920186.negop)
	c:RegisterEffect(e4)
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_SINGLE)
	e32:SetCode(EFFECT_MATERIAL_CHECK)
	e32:SetValue(c98920186.valcheck)
	e32:SetLabelObject(e4)
	c:RegisterEffect(e32)
end
function c98920186.mfilter(c)
	return c:IsSetCard(0x64)
end
function c98920186.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsFusionType,1,nil,TYPE_NORMAL) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98920186.chkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsAbleToRemove()
end
function c98920186.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c98920186.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c98920186.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c98920186.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil)
			and not Duel.IsExistingMatchingCard(c98920186.chkfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(c98920186.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c98920186.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920186.rmfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c98920186.cfilter(c)
	return c:IsCode(76812113)
end
function c98920186.indcon(e)
	return Duel.IsExistingMatchingCard(c98920186.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function c98920186.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_MZONE,0,nil,76812113)*-100
end
function c98920186.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and Duel.IsChainNegatable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c98920186.cfilter1(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsCode(76812113)
end
function c98920186.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920186.cfilter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920186.cfilter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c98920186.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end