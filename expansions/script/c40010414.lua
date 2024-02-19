--终结拳龙
local m=40010414
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,80280737,40010266)
	c:EnableReviveLimit()
	--Cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(cm.splimit)
	c:RegisterEffect(e4)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.remcost)
	e1:SetTarget(cm.remtg)
	e1:SetOperation(cm.remop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetCondition(cm.actcon)
	c:RegisterEffect(e2)
		--gain ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetCondition(cm.atkcon)
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return aux.AssaultModeLimit(e,se,sp,st) or se:GetHandler()==e:GetHandler()
end
function cm.atkcon(e)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)
	local ph=Duel.GetCurrentPhase()
	return ct>=15 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
end
function cm.atkval(e,c)
	--local c=e:GetHandler()
	local ct=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)
	return c:GetAttack()*(2^ct)
end
function cm.actcon(e)

	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-c:GetControler(),LOCATION_SZONE,PLAYER_NONE,0)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return ct>=10 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function cm.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,3,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,3,3,REASON_COST+REASON_DISCARD)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	if ct>=5 then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local zone=Duel.GetLocationCount(tp,LOCATION_ONFIELD,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_ONFIELD,PLAYER_NONE,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(Duel.GetLocationCount(tp,LOCATION_ONFIELD,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_ONFIELD,PLAYER_NONE,0))
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(40010266) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end