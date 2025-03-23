-- 渊灵统御者-溟渊座头鲸
function c10200013.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    -- 三色护航
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c10200013.con1)
	e1:SetOperation(c10200013.op1)
	c:RegisterEffect(e1)
    -- 特召除外
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10200013,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,10200014)
    e2:SetCondition(c10200013.con2)
    e2:SetTarget(c10200013.tg2)
    e2:SetOperation(c10200013.op2)
    c:RegisterEffect(e2)
    -- 墓地回收
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10200013,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,10200015)
    e3:SetCost(c10200013.cost3)
    e3:SetTarget(c10200013.tg3)
    e3:SetOperation(c10200013.op3)
    c:RegisterEffect(e3)
end
-- 1
function c10200013.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev<1 then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return rp==1-tp and p==tp and te and te:GetHandler():IsSetCard(0xe21)
		and Duel.GetFlagEffect(tp,10200013)==0
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function c10200013.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,10200013)==0 and Duel.SelectYesNo(tp,aux.Stringid(10200013,1)) then
		Duel.Hint(HINT_CARD,0,10200013)
		Duel.RegisterFlagEffect(tp,10200013,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
-- 2
function c10200013.con2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c10200013.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200013.op2(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
    local sg=Group.CreateGroup()
    if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10200013,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        sg:Merge(sg1)
    end
    if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10200013,4)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local sg2=g2:Select(tp,1,1,nil)
        Duel.HintSelection(sg2)
        sg:Merge(sg2)
    end
    if sg:GetCount()>0 then
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end
-- 3
function c10200013.filter3(c)
    return c:IsSetCard(0xe21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10200013.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(c10200013.filter3,tp,LOCATION_GRAVE,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c10200013.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c10200013.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
            and Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0
            and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,LOCATION_ONFIELD+LOCATION_HAND)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200013.op3(e,tp,eg,ep,ev,re,r,rp)
    local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
    if g1:GetCount()>0 and g2:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg1=g1:Select(tp,1,1,nil)
        Duel.HintSelection(sg1)
        local sg2=g2:RandomSelect(1-tp,1)
        Duel.HintSelection(sg2)
        sg1:Merge(sg2)
        Duel.Destroy(sg1,REASON_EFFECT)
    end
end