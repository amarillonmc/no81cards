local cm,m = GetID()
cm.eff,cm.ec = {},{}
function cm.initial_effect(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(function(e,c)
	return Duel.GetMatchingGroupCount(cm.f,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil,RACE_DRAGON)*200
    end)
    e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) tp=e:GetHandlerPlayer() return Duel.GetMatchingGroupCount(function(c) return c:IsCode(84569017) and c:IsFaceup() end,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)>0 end )
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and se:GetHandler():IsType(TYPE_MONSTER) and se:GetHandler():GetAttribute()&ATTRIBUTE_WIND~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	cm.tab = {g:GetFirst()}
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and cm.f(cm.tab[1]) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	cm.tab = nil
end
function cm.f(c)
    return (c:IsRace(RACE_AQUA) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_FISH))
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_REMOVED)<Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
	    if not cm.ec[tp] then
    		local e1=Effect.CreateEffect(e:GetHandler())
    		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    		e1:SetCondition(cm.con3)
    		e1:SetOperation(cm.op3)
    		Duel.RegisterEffect(e1,tp)
    		cm.ec[tp] = true
        end
		table.insert(cm.eff,tc)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	for _,c in ipairs(cm.eff) do
	    if aux.GetValueType(c) == "Card" then Duel.ReturnToField(c) end
	end
	e:Reset()
	cm.ec[tp] = nil
end