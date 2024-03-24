--迷影赛博特 齿轮
function c88100310.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100310,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88100310)
	e1:SetCondition(c88100310.condition)
	e1:SetCost(c88100310.cost)
	e1:SetTarget(c88100310.target)
	e1:SetOperation(c88100310.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100310,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88100310.spcon)
	e2:SetCost(c88100310.spcost)
	e2:SetTarget(c88100310.sptg)
	e2:SetOperation(c88100310.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88100310,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,88200310)
	e3:SetCondition(c88100310.spcon2)
	e3:SetTarget(c88100310.sptg2)
	e3:SetOperation(c88100310.spop2)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(88100310,ACTIVITY_SPSUMMON,c88100310.counterfilter)
end
c88100310.I_will_recover=true
function c88100310.counterfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE) or c:IsSetCard(0x5590)
end
function c88100310.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c88100310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88100310.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c88100310.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100310.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(88100310,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c88100310.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88100310.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5590) or c:IsLocation(LOCATION_GRAVE)
end
function c88100310.spfilter(c,e,tp)
	return c:IsCode(88100310) and Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE)
end
function c88100310.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88100310.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88100310.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88100310.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c88100310.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
		 and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100310.spfilter2(c,e,tp)
	return c:IsCode(88100310) and Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE)
end
function c88100310.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE)
		and Duel.IsExistingMatchingCard(c88100310.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c88100310.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,88100310,0x5590,TYPES_EFFECT_TRAP_MONSTER,1900,200,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	if Duel.SpecialSummonStep(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c88100310.spfilter2,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
		local tc=g:GetFirst()
		if tc then
			tc:AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		end
	end
	Duel.SpecialSummonComplete()
end