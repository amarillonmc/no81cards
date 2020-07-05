--饥饿捕食花园
function c79029559.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029559,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029559.atktg)
	e2:SetOperation(c79029559.atkop)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029559,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,79029559)
	e3:SetCost(c79029559.spcost)
	e3:SetTarget(c79029559.sptg)
	e3:SetOperation(c79029559.spop)
	c:RegisterEffect(e3)
	--funsion 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(79029559,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE+LOCATION_SZONE)
	e4:SetCountLimit(1,88345676)
	e4:SetCost(c79029559.cost)
	e4:SetOperation(c79029559.activate)
	c:RegisterEffect(e4)
end
function c79029559.atfil(c)
	return (c:IsSetCard(0x10f3) or c:IsSetCard(0x1046)) and c:IsType(TYPE_FUSION)
end
function c79029559.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029559.atfil,tp,LOCATION_MZONE,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,c79029559.atfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,0,0)
end
function c79029559.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetMaterial():GetSum(Card.GetAttack)/2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e1)
end
function c79029559.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1041,10,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1041,10,REASON_COST)
end
function c79029559.spfil(c,e,tp)
	return (c:IsSetCard(0x10f3) or c:IsSetCard(0x1046)) and c:IsType(TYPE_FUSION)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029559.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end 
	if chk==0 then return Duel.IsExistingMatchingCard(c79029559.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and loc~=0 and Duel.GetLocationCountFromEx(tp)>0 end
	local tc=Duel.SelectMatchingCard(tp,c79029559.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,tc,1,0,0)
end
function c79029559.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79029559.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c79029559.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(58199906,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHAIN_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c79029559.chain_target)
	e1:SetOperation(c79029559.chain_operation)
	e1:SetValue(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	Duel.RegisterEffect(e1,tp)
end
function c79029559.filter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c79029559.chain_target(e,te,tp)
	return Duel.GetMatchingGroup(c79029559.filter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,nil,te)
end
function c79029559.chain_operation(e,te,tp,tc,mat,sumtype)
	if not sumtype then sumtype=SUMMON_TYPE_FUSION end
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(tc,sumtype,tp,tp,false,false,POS_FACEUP)
	e:Reset()
end