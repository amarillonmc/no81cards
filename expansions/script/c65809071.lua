--资源获取点·矿石坑
function c65809071.initial_effect(c)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(65809071,0))
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetOperation(c65809071.activate)
    c:RegisterEffect(e0)
    -- 墓地盖放
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(65809071,1))
    e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
    e2:SetCost(c65809071.cost2)
	e2:SetTarget(c65809071.tg2)
	e2:SetOperation(c65809071.op2)
	c:RegisterEffect(e2)
end
-- 1
function c65809071.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    if g:GetCount()==0 then return end
    if Duel.SelectYesNo(tp,aux.Stringid(65809071,0)) then
        Duel.ConfirmCards(tp,g)
        local sg=g:FilterSelect(tp,Card.IsFacedown,1,1,nil)
        if sg:GetCount()>0 then
            Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
            Duel.BreakEffect()
            Duel.SendtoDeck(sg:GetFirst(),tp,0,REASON_EFFECT+REASON_RETURN)
            Duel.ShuffleExtra(1-tp)
        end
        Duel.ShuffleExtra(1-tp)
    end
end
-- 2
function c65809071.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65809071.filter2(c)
	return c:IsSetCard(0xaa30) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65809071.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65809071.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65809071.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65809071.filter2),tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(65809071,2))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetDescription(aux.Stringid(65809071,2))
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
        e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
