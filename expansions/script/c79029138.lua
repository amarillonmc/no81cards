--黑钢国际·重装干员-雷蛇·反击电弧
function c79029138.initial_effect(c)  
	c:EnableReviveLimit()
	--Cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c79029138.condition)
	e2:SetOperation(c79029138.operation)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029138.destg)
	e3:SetOperation(c79029138.desop)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(4779091,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c79029138.spcon)
	e5:SetTarget(c79029138.sptg)
	e5:SetOperation(c79029138.spop)
	c:RegisterEffect(e5)  
end
c79029138.card_code_list={79029137}
c79029138.assault_name=79029043
function c79029138.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c79029138.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_REMOVED+LOCATION_OVERLAY)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c79029138.target)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)  
	c:RegisterEffect(e3)   
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
end
function c79029138.target(e,c)
	return c:IsLocation(LOCATION_MZONE)
end
function c79029138.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c79029138.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local x=g:GetCount()
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(698785,0)) then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c79029138.filter(c,e,tp)
	return c:IsCode(79029043) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c79029138.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c79029138.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c79029138.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c79029138.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029138.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end





























