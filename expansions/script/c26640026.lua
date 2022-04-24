--交界的颜彩画手
local m=26640026
local cm=_G["c"..m]
function c26640026.initial_effect(c)
    aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(cm.sumcon)
	e0:SetOperation(cm.sumop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(cm.distg)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,26640026)
	e2:SetCost(aux.bfgcost)
    e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xe51) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
----灵摆效果
function cm.thfilter(c,tp)
	return (c:IsSetCard(0xe51) or c:IsSetCard(0xb81)) and c:IsAbleToRemoveAsCost()
end
function cm.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
----上级召唤手续
function cm.thnfilter(c,tp)
	return c:IsFaceup()
end
function cm.thhfilter(c,tp)
	return (c:IsSetCard(0xe51) or c:IsSetCard(0xb81)) and c:IsType(TYPE_MONSTER)
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroup(cm.thnfilter,tp,LOCATION_REMOVED,0,nil):GetCount()>=5
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thhfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thhfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>=5 then
		local sg=Duel.SelectMatchingCard(tp,cm.thhfilter,tp,LOCATION_REMOVED,0,1,1,nil)
        local tg=sg:GetFirst()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
       
	end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(cm.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not (c:IsSetCard(0xe51) or c:IsSetCard(0xb81) ) 
end