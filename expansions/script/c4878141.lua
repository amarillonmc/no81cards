local m=4878141
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(cm.settg)
    e1:SetOperation(cm.setop)
    c:RegisterEffect(e1)
end
function cm.setfilter(c)
    return c:IsSetCard(0x48f) and c:IsSSetable() and c:IsType(TYPE_TRAP) and not c:IsCode(m)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
	 if Duel.IsPlayerAffectedByEffect(tp,4878130) then
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
   end
end
function cm.setfilter1(c,g)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and g:IsContains(c)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	   local cg=c:GetColumnGroup()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
   Duel.SSet(tp,tc)
   if Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,cg) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
   local g1=Duel.SelectMatchingCard(tp,cm.setfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,cg)
   local tc1=g1:GetFirst()
   if  tc1:IsFaceup() and tc1:GetAttack()>0 then
        Duel.Recover(tp,tc1:GetAttack(),REASON_EFFECT)
    end
   end
       if Duel.IsPlayerAffectedByEffect(tp,4878130) then
    Duel.Draw(tp,1,REASON_EFFECT)
   end
end