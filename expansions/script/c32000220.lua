--红锈龙 吞灭龙

local id=32000220
local zd=0xff6
function c32000220.initial_effect(c)
    c:SetUniqueOnField(1,0,id)
	--XyzSummon
	aux.AddXyzProcedureLevelFree(c,c32000220.xyzfilter,c32000220.xyzcheck,3,3)
	c:EnableReviveLimit()
	--AdXyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c32000220.e1tg)
	e1:SetCondition(c32000220.e1con)
	e1:SetOperation(c32000220.e1op)
	c:RegisterEffect(e1)
	
	--DisableOP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c32000220.e2cost)
	e2:SetTarget(c32000220.e2tg)
	e2:SetOperation(c32000220.e2op)
	c:RegisterEffect(e2)

	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,zd))
	e3:SetValue(c32000220.e3atkval)
	c:RegisterEffect(e3)
end

--XyzSummon
function c32000220.xyzfilter(c)
	return c:IsLevelAbove(0)
end

function c32000220.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount() and g:IsExists(Card.IsSetCard,1,nil,zd)
end

--e1
function c32000220.e1con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()<=1 and not re:GetHandler():IsCode(id)
end 

function c32000220.filter(c)
	return c:IsCanOverlay()
end

function c32000220.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000220.filter,tp,0,LOCATION_GRAVE,1,nil) end
	
end
function c32000220.e1op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local tc=Duel.SelectMatchingCard(tp,c32000220.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end

--e2
function c32000220.e2filter(c)
	return not c:IsDisabled() and c:IsFaceup()
end
function c32000220.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) end
	 Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT)
end
function c32000220.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000220.e2filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c32000220.e2filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c32000220.e2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c32000220.e2filter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(0,1)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end

--e3

function c32000220.e3atkval(e,c)
	return Duel.GetOverlayCount(e:GetHandlerPlayer(),1,0)*100
end





