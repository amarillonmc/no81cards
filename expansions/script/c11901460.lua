--罗星姬 银河
local s,id,o=GetID()
function s.initial_effect(c)
    --Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.synfilter),1)
	c:EnableReviveLimit()
    --Set Card
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) 
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sttg)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
    --Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.dstg)
	e2:SetOperation(s.dsop)
	c:RegisterEffect(e2)
end
function s.synfilter(c)
    return c:IsSetCard(0x409) and c:IsType(TYPE_SYNCHRO)
end
function s.stfilter(c)
    return c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
        and c:IsFaceup() and not c:IsForbidden()
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.stfilter,tp,0x30,0,1,nil) end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if val==0 then return end
    if val>2 then val=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.stfilter,tp,0x30,0,1,val,nil)
    local tc=g:GetFirst()
    while tc do
	    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(tc,tp,tp,0x08,POS_FACEUP,true) then
            local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetCode(EFFECT_CHANGE_TYPE)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		    e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		    tc:RegisterEffect(e1)
        end
        tc=g:GetNext()
	end
end
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,0,0x0c,nil,e)
	if chk==0 then return #g>0 end
    Duel.SetTargetCard(g)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #g>0 then
        Duel.Recover(tp,#g*100,REASON_EFFECT)
	end
end