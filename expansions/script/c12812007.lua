--恋爱头脑战-伊井野弥子
local m=12812007
local cm=_G["c"..m]
function c12812007.initial_effect(c)
    aux.EnablePendulumAttribute(c)   
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.psplimit)
	c:RegisterEffect(e1)
	--special summon
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,12812107)
    e2:SetCondition(cm.sccon)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--special summon
end
function cm.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa73) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--效果1
function cm.sccon(e)
	return  Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0xa73)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0xa73) end
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(5)
		c:RegisterEffect(e2)
    end
end
--效果2
function cm.desfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT) and c:IsSetCard(0xa73)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local bg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        Duel.HintSelection(bg)
        Duel.SendtoHand(bg,nil,2,REASON_EFFECT)
        end
end