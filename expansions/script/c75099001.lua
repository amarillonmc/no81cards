--凛冽的圣冰 菲约尔姆
function c75099001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75099001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75099001)
	e1:SetCost(c75099001.cost)
	e1:SetTarget(c75099001.sptg)
	e1:SetOperation(c75099001.spop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75099001,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,75099002)
	e2:SetTarget(c75099001.cttg)
	e2:SetOperation(c75099001.ctop)
	c:RegisterEffect(e2)
c75099001.frozen_list=true
end
function c75099001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local b2=Duel.IsCanRemoveCounter(tp,1,1,0x1750,1,REASON_COST)
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(75099001,2),aux.Stringid(75099001,3))==0) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	else
		Duel.RemoveCounter(tp,1,1,0x1750,1,REASON_COST)
	end
end
function c75099001.spfilter(c,e,tp)
	return (c.frozen_list or c:IsSetCard(0x758)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75099001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75099001.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c75099001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75099001.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75099001.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc and bc:IsControler(1-tp) and bc:IsCanAddCounter(0x1750,1) end
end
function c75099001.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e0)
	end
	local bc=c:GetBattleTarget()
	if bc and bc:AddCounter(0x1750,1) and bc:GetFlagEffect(75099001)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c75099001.frcon)
		e1:SetValue(bc:GetAttack()*-1/4)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(bc:GetDefense()*-1/4)
		bc:RegisterEffect(e2)
		bc:RegisterFlagEffect(75099001,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c75099001.frcon(e)
	return e:GetHandler():GetCounter(0x1750)>0
end
