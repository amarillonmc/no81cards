--暗黑战斗暴龙兽
function c9951591.initial_effect(c)
 --draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9951591)
	e1:SetCondition(c9951591.drcon)
	e1:SetTarget(c9951591.drtg)
	e1:SetOperation(c9951591.drop)
	c:RegisterEffect(e1)
	  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951591,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DISCARD)
	e2:SetTarget(c9951591.sptg2)
	e2:SetOperation(c9951591.spop2)
	c:RegisterEffect(e2)
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951591,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c9951591.target)
	e1:SetOperation(c9951591.operation)
	c:RegisterEffect(e1)
   --handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951591,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c9951591.condition)
	e1:SetTarget(c9951591.target2)
	e1:SetOperation(c9951591.operation2)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951591.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951591.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951591,0))
end
function c9951591.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c9951591.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c9951591.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c9951591.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9951591.drcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(c9951591.cfilter,1,e:GetHandler(),tp)
end
function c9951591.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c9951591.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9951591.filter(c)
	return c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsCode(9951591) and c:IsAbleToHand()
end
function c9951591.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951591.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function c9951591.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951591.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,Card.IsAttribute,1,1,REASON_EFFECT+REASON_DISCARD,nil,ATTRIBUTE_DARK)
end
function c9951591.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9951591.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end