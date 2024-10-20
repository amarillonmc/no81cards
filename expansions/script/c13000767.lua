--大磁暴
local cm,m,ofs=GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
    --
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
    --
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
    if cm.call==nil then
		cm.call=true
        cm[0]=false
        cm[1]=false
        local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
    end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=false
    cm[1]=false
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe09)
end
function cm.cfilter2(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToDeckAsCost()
end
function cm.cfilter3(c)
	return not c:IsCode(m)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local a=c:GetCode()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and
	Duel.GetMatchingGroupCount(cm.cfilter2,tp,LOCATION_HAND,0,nil)>=1 and Duel.GetLocationCount(tp, LOCATION_SZONE)>0
    and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local ta=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoDeck(ta, nil, 2, REASON_COST)
    if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EFFECT_CHANGE_TYPE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
        e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
        c:RegisterEffect(e1)
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SUMMON)
		Duel.RegisterEffect(e2,tp)
    end
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS and cm[rp]==false and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    cm[rp]=true
	local c=e:GetHandler()
	local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if #g<=0 or not Duel.SelectYesNo(tp, aux.Stringid(m,1)) then return end
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end