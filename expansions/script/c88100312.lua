--迷影真王 渔人
function c88100312.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100312,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c88100312.condition)
	e1:SetCost(c88100312.cost)
	e1:SetTarget(c88100312.target)
	e1:SetOperation(c88100312.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100312,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,88100312)
	e2:SetCondition(c88100312.spcon)
	e2:SetTarget(c88100312.sptg)
	e2:SetOperation(c88100312.spop)
	c:RegisterEffect(e2)
end
c88100312.I_will_recover=true
function c88100312.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100312.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c88100312.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,88100312,0x5590,TYPES_EFFECT_TRAP_MONSTER,2000,1100,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88100312.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,88100312,0x5590,TYPES_EFFECT_TRAP_MONSTER,2000,1100,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP) then
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TUNER)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
	end
end
function c88100312.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100312.filter(c,e,tp)
	return c.I_will_recover and c:IsSetCard(0x5590) 
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x5590,TYPES_EFFECT_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute(),POS_FACEUP_DEFENSE)
		or c.Absolute_madness
			and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x5590,TYPES_EFFECT_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute(),POS_FACEUP))
end
function c88100312.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c88100312.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88100312.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88100312.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88100312.sfilter(c,e,tp)
	return c:IsRelateToEffect(e)
end
function c88100312.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return false end
	if tc then
		if tc.Absolute_madness then
			tc:AddMonsterAttribute(TYPE_TUNER+TYPE_EFFECT)
			Duel.SpecialSummon(tc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
		else
			tc:AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummon(tc,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
		end
	end
end