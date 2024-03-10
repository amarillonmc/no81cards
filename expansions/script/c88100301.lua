--迷影策士 遮面鬼
function c88100301.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88100301,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c88100301.condition)
	e1:SetCost(c88100301.cost)
	e1:SetTarget(c88100301.target)
	e1:SetOperation(c88100301.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88100301,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88100301.spcon)
	e2:SetTarget(c88100301.sptg)
	e2:SetOperation(c88100301.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88100301,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c88100301.thcon)
	e3:SetTarget(c88100301.thtg)
	e3:SetOperation(c88100301.thop)
	c:RegisterEffect(e3)
end
c88100301.I_will_recover=true
function c88100301.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c88100301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,88100301,0x5590,TYPES_EFFECT_TRAP_MONSTER,1800,300,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88100301.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,88100301,0x5590,TYPES_EFFECT_TRAP_MONSTER,1800,300,4,RACE_SPELLCASTER,ATTRIBUTE_WIND,POS_FACEUP_DEFENSE) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c88100301.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER)
end
function c88100301.filter(c,e,tp)
	return not c:IsCode(88100301) and c.I_will_recover and c:IsSetCard(0x5590) 
		and (Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x5590,TYPES_EFFECT_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute(),POS_FACEUP_DEFENSE)
		or c.Absolute_madness
			and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x5590,TYPES_EFFECT_TRAP_MONSTER,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute(),POS_FACEUP))
end
function c88100301.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c88100301.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c88100301.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88100301.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88100301.sfilter(c,e,tp)
	return c:IsRelateToEffect(e)
end
function c88100301.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c88100301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c88100301.thfilter(c)
	return c:IsSetCard(0x5590) and not c:IsCode(88100301) and c:IsAbleToHand()
end
function c88100301.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88100301.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88100301.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88100301.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end