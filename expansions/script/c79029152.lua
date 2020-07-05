--罗德岛·医疗干员-芙蓉
function c79029152.initial_effect(c)
	 aux.EnablePendulumAttribute(c)
	--scale up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26420373,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029152.cost)
	e1:SetCondition(c79029152.con)
	e1:SetOperation(c79029152.op)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029152.splimit)
	c:RegisterEffect(e2)   
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1264319,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029152.cost1)
	e3:SetOperation(c79029152.activate)
	c:RegisterEffect(e3)
	--recover conversion
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_REVERSE_RECOVER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c79029152.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029152.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029152.con(e,c)
	return e:GetHandler():GetRightScale()<13
end
function c79029152.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetValue(1)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
function c79029152.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029152.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(1264319,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c79029152.chain_target)
	e1:SetOperation(c79029152.chain_operation)
	e1:SetValue(aux.FilterBoolFunction(Card.IsSetCard,0xa900))
	Duel.RegisterEffect(e1,tp)
end
function c79029152.fil(c,e)
	return c:IsCode(79029166)
end
function c79029152.filter(c,e)
	return (c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)) or (c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_EXTRA) and c:IsPosition(POS_FACEUP))
end
function c79029152.chain_target(e,te,tp)
	if Duel.IsExistingMatchingCard(c79029152.fil,tp,LOCATION_MZONE,0,1,nil)
	then return Duel.GetMatchingGroup(c79029152.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK,LOCATION_MZONE,nil,te)
	else return Duel.GetMatchingGroup(c79029152.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_EXTRA,0,nil,te)
end
end
function c79029152.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end





