--血棉花
local m=43990094
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,43990094)
	e1:SetCondition(c43990094.spcon)
	e1:SetCost(c43990094.spcost1)
	e1:SetTarget(c43990094.sptg)
	e1:SetOperation(c43990094.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,43991094)
	e2:SetCondition(c43990094.drcon)
	e2:SetOperation(c43990094.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,43991094)
	e3:SetCondition(c43990094.drcon2)
	e3:SetOperation(c43990094.drop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1,43991094)
	e4:SetCondition(c43990094.drcon2)
	e4:SetOperation(c43990094.drop)
	c:RegisterEffect(e4)
	
end
function c43990094.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCost(c43990094.costchk)
	e2:SetOperation(c43990094.costop)
	Duel.RegisterEffect(e2,tp)
end
function c43990094.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,200)
end
function c43990094.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,200)
end
function c43990094.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_FUSION
end
function c43990094.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_ILLUSION)
end
function c43990094.cfilter1(c,e,tp)
	return c:IsRace(RACE_ILLUSION) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and c:IsPreviousPosition(POS_FACEUP) and c:IsLocation(0x70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c43990094.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(c43990094.cfilter1,1,nil,e,tp) and eg:GetCount()==1
end
function c43990094.cfilter2(c,tp)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c43990094.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990094.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c43990094.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c43990094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c43990094.cfilter1,nil,e,tp)
	if chk==0 then return ((c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemove()) or (not c:IsLocation(LOCATION_GRAVE))) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,0x70)
end
function c43990094.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c43990094.cfilter1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetActivateLocation()==LOCATION_GRAVE and c:IsAbleToRemove() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

