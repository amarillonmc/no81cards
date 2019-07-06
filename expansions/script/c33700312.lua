--慧心花姬 苍
local m=33700312
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x1449),2,2)
	c:EnableReviveLimit()   
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--atk target change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.at)
	e2:SetOperation(cm.ao)
	c:RegisterEffect(e2)
end
function cm.at(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==1-tp end
end
function cm.ao(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	local tf=(at and Duel.IsExistingTarget(cm.afilter,tp,LOCATION_MZONE,0,1,at,Duel.GetAttacker()))
	if not tf or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	   Duel.NegateAttack()
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	   local g=Duel.SelectMatchingCard(tp,cm.afilter,tp,LOCATION_MZONE,0,1,1,at,Duel.GetAttacker())
	   Duel.HintSelection(g)
	   Duel.ChangeAttackTarget(g:GetFirst())
	end
end
function cm.afilter(c,tc)
	return (c:IsSetCard(0x1449) or c:IsSetCard(0x3449)) and c:IsFaceup() and c:IsCanBeBattleTarget(tc)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():IsLocation(LOCATION_MZONE)
end
function cm.filter(c,e,tp,zone)
	return c:IsSetCard(0x1449) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end


