--曜日卿
function c60159939.initial_effect(c)
	--special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60159939,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c60159939.e1con)
    e1:SetOperation(c60159939.e1op)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetOperation(c60159939.e2op)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60159939,1))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCost(c60159939.e3cost)
    e3:SetTarget(c60159939.e3tg)
    e3:SetOperation(c60159939.e3op)
    c:RegisterEffect(e3)
	--cannot set
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_MSET)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(1,1)
    e4:SetTarget(aux.TRUE)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e5)
    local e6=e4:Clone()
    e6:SetCode(EFFECT_CANNOT_TURN_SET)
    c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e7:SetTarget(c60159939.e7limit)
    c:RegisterEffect(e7)
end
function c60159939.e1con(e,c)
    if c==nil then return true end
	local tp=c:GetControler()
    return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)>0
        and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)>0
        and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)>Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
end
function c60159939.e1op(e,tp,eg,ep,ev,re,r,rp,c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(c60159939.e1opfilter)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end
function c60159939.e1opfilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60159939.e2op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)>0 then
        local g2=Duel.GetOperatedGroup()
		local tc=g2:GetFirst()
		while tc do
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsFaceup() then Duel.SendtoGrave(tc,REASON_EFFECT) end
			tc=g2:GetNext()
		end
    end
end
function c60159939.adval(e,c)
    local g=Duel.GetMatchingGroup(c60159939.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()==0 then 
        return 100
    else
        local tg,val=g:GetMaxGroup(Card.GetAttack)
        return val+100
    end
end
function c60159939.e3costfilter(c)
    return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c60159939.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60159939.e3costfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local s=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	if s>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then s=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60159939.e3costfilter,tp,LOCATION_ONFIELD,0,1,s,nil)
    Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c60159939.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,60159932)
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c60159939.e3op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,60159932)
    local tc=g:GetFirst()
    if tc then
        Duel.ShuffleDeck(tp)
        Duel.MoveSequence(tc,0)
        Duel.ConfirmDecktop(tp,1)
		Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
    end
end
function c60159939.e7limit(e,c,sump,sumtype,sumpos,targetp)
    return bit.band(sumpos,POS_FACEDOWN)>0
end