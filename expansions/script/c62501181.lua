--团团圆圆 美好团子
function c62501181.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,c62501181.mfilter,4,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_HAND+LOCATION_MZONE+LOCATION_REMOVED,0,aux.ContactFusionSendToDeck(c))
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501181.splimit)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c62501181.imcon)
	e1:SetValue(c62501181.efilter)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c62501181.costchk)
	e2:SetOperation(c62501181.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLAG_EFFECT+62501181)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	--e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c62501181.damcost)
	e4:SetTarget(c62501181.damtg)
	e4:SetOperation(c62501181.damop)
	c:RegisterEffect(e4)
	--tango remove
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c62501181.regop)
	c:RegisterEffect(e5)
end
function c62501181.mfilter(c)
	return c:IsSetCard(0xea1) and c:IsFusionType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c62501181.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or se:GetHandler():IsSetCard(0xea1)
end
function c62501181.cfilter(c)
	return c:IsSetCard(0xea1) and c:IsFaceup()
end
function c62501181.imcon(e)
	return Duel.IsExistingMatchingCard(c62501181.cfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil)
end
function c62501181.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c62501181.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,62501181)
	return Duel.CheckLPCost(tp,ct*600)
end
function c62501181.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,600)
end
function c62501181.tdfilter(c)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup()
end
function c62501181.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501181.tdfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c62501181.tdfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c62501181.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
	Duel.SetChainLimit(c62501181.chainlm)
end
function c62501181.chainlm(e,ep,tp)
	return tp==ep
end
function c62501181.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TO_DECK)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501181.rmlimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501181.rmlimit(e,c,tp,r,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(62501181) and r==REASON_COST
end
function c62501181.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
