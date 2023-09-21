--晶导算使 二极晶体管
local m=33201409
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201401") end,function() require("script/c33201401") end)
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	VHisc_JDSS.addcheck(c)
	--disable search
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_TO_HAND)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tdcon1)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e6=e1:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e6:SetCondition(cm.tdcon2)
	c:RegisterEffect(e6)
	--ignore
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(cm.econ)
	e3:SetTargetRange(0,1)
	e3:SetTarget(cm.sumlimit)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_TO_HAND_REDIRECT)
	e4:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e4:SetCondition(cm.econ)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_TO_DECK_REDIRECT)
	e5:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_GRAVE)
	e5:SetCondition(cm.econ)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
end
c33201409.SetCard_JDSS=true 

function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,33201408)
end

--e1
function cm.thfilter(c,code)
	return c.SetCard_JDSS and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function cm.tdfilter(c,tp)
	return c.SetCard_JDSS and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra() and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetCode()
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,code)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
	end
end

--e2
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()==0 then return end
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(re)
		e1:SetValue(cm.efilter)
		tc:RegisterEffect(e1)
	end
end
function cm.efilter(e,te)
	local ige=e:GetLabelObject()
	return te==ige
end

--e345
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33201401)~=0
end