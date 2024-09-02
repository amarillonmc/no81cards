--水仙·花信
function c16372012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16372012)
	e1:SetCondition(c16372012.spcon)
	e1:SetCost(c16372012.costoath)
	e1:SetTarget(c16372012.sptg)
	e1:SetOperation(c16372012.spop)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372012+100)
	e2:SetCondition(c16372012.setscon)
	e2:SetCost(c16372012.costoath)
	e2:SetTarget(c16372012.setstg)
	e2:SetOperation(c16372012.setsop)
	c:RegisterEffect(e2)
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372012.spellcon)
	e3:SetOperation(c16372012.posop)
	c:RegisterEffect(e3)
	--[[spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372012.spcon2)
	e3:SetOperation(c16372012.spop2)
	c:RegisterEffect(e3)]]
	Duel.AddCustomActivityCounter(16372012,ACTIVITY_SPSUMMON,c16372012.counterfilter)
end
function c16372012.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372012.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372012,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372012.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372012.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372012.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c16372012.filter2(c)
	return (c:IsFaceup() and not c:IsRace(RACE_PLANT)) or c:IsFacedown()
end
function c16372012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c16372012.filter1,tp,LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c16372012.filter2,tp,LOCATION_MZONE,0,1,nil)
end
function c16372012.thfilter(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c16372012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingMatchingCard(c16372012.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c16372012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372012.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c16372012.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372012.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372012.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil and Duel.MoveToField(c,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372012.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
		and not Duel.GetAttacker():IsRace(RACE_PLANT)
end
function c16372012.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16372012)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
--[[function c16372012.filter(c,e,tp,eg)
	local p=c:GetOwner()
	return c:IsRace(RACE_PLANT)
		and Duel.IsExistingMatchingCard(c16372012.spfilter,p,LOCATION_GRAVE,0,1,nil,e,p,eg)
end
function c16372012.spfilter(c,e,tp,eg)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not eg:IsContains(c)
end
function c16372012.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16372012.filter,1,nil,e,tp,eg)
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372012.cfilter1(c,e,tp,eg)
	local p=c:GetOwner()
	return c:IsRace(RACE_PLANT) and c:IsControler(tp)
		and Duel.IsExistingMatchingCard(c16372012.spfilter,p,LOCATION_GRAVE,0,1,c,e,p,eg)
end
function c16372012.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16372012)
	if eg:IsExists(c16372012.cfilter1,1,nil,e,tp,eg) then
		local tc=Duel.SelectMatchingCard(p,c16372012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if eg:IsExists(c16372012.cfilter1,1,nil,e,1-tp,eg) then
		local tc=Duel.SelectMatchingCard(p,c16372012.spfilter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,1-tp,eg):GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end]]