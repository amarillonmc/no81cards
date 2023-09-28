local m=53754012
local cm=_G["c"..m]
cm.name="失重屏风 明斯洛"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.GelidimenFilpSummon(c,cm.fscost,cm.fsop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FLIP))
	e1:SetCondition(cm.atkcon)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge1:SetOperation(cm.fscheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.fscheck(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.fscost(e,c,tp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local b1,b2=g:IsExists(Card.IsControler,1,nil,tp),g:IsExists(Card.IsControler,1,nil,1-tp)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) elseif b1 then op=0 else op=1 end
	if op==0 then g=g:Filter(Card.IsControler,nil,tp) else g=g:Filter(Card.IsControler,nil,1-tp) end
	local sg=g:RandomSelect(tp,1)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function cm.atkcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.atkval(e,c)
	local val1=Duel.GetCounter(0,1,1,0x153d)*300
	local val2=Duel.GetMatchingGroupCount(function(c)return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
	local val3=Duel.GetMatchingGroupCount(function(c)return c:GetFlagEffect(m)>0 end,0,LOCATION_MZONE,LOCATION_MZONE,nil)*700
	return math.max(val1,val2,val3)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	Duel.RegisterEffect(e1,tp)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.opfilter(c)
	return c:IsAbleToHand() or (c:IsFaceup() and c:IsCanTurnSet()) or (c:IsPosition(POS_FACEDOWN_ATTACK) and c:IsCanChangePosition())
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.opfilter,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	local tc=sg:GetFirst()
	local b1,b2=tc:IsAbleToHand(),(tc:IsFaceup() and tc:IsCanTurnSet()) or (tc:IsPosition(POS_FACEDOWN_ATTACK) and tc:IsCanChangePosition())
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,1190,1153) elseif b1 then op=0 else op=1 end
	if op==0 then Duel.SendtoHand(tc,nil,REASON_EFFECT) else Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
end
