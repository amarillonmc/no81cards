--梅古梅古 缄默之语
local m=33310256
local list={33310257,33310250}
local cm=_G["c"..m]
local dam=500
cm.name="梅古梅古 缄默之语"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_BATTLE_END)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetLabel(1)
	e3:SetCost(cm.spcost2)
	c:RegisterEffect(e3)
end
--Special Summon
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(list[1])
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and aux.dscon() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
--Special Summon
function cm.spfilter(c,e,tp)
	return c:IsCode(list[2]) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	return (phase>=PHASE_BATTLE_START and phase<=PHASE_BATTLE and aux.dscon())
		or phase==PHASE_MAIN1 or phase==PHASE_MAIN2
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=nil
	if e:GetLabel()==1 then c=e:GetHandler() end 
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local c=e:GetHandler()
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if e:GetLabel()==1 then
			local tc=g:GetFirst()
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetTargetRange(0,1)
			e2:SetValue(1)
			e2:SetCondition(cm.actcon)
			tc:RegisterEffect(e2,true)
			tc:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(m,3))
		end
	end
end
