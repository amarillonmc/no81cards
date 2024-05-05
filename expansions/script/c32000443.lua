--武色通道

local id=32000443
local zd=0x3c5
function c32000443.initial_effect(c)
    --act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c32000443.e0con)
	c:RegisterEffect(e0)
	
    --activeDraw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(c32000443.e1cost)
	e1:SetTarget(c32000443.e1tg)
	e1:SetOperation(c32000443.e1op)
	c:RegisterEffect(e1)
	
	--SetDAndRByRemoveSelf
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(c32000443.e2cost)
	e2:SetTarget(c32000443.e2tg)
	e2:SetOperation(c32000443.e2op)
	c:RegisterEffect(e2)
	
	
end

--e0

function c32000443.e0confilter(c)
    return c:IsSetCard(zd) and c:IsFaceup()
end

function c32000443.e0con(e)
	return Duel.IsExistingMatchingCard(c32000443.e0confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end

--e1

function c32000443.e1rmfilter(c)
    return c:IsAbleToRemoveAsCost() and c:IsSetCard(zd)
end

function c32000443.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c32000443.e1rmfilter,tp,LOCATION_GRAVE,0,2,nil) end
   
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32000443.e1rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
   Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_EFFECT)
end

function c32000443.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)  end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c32000443.e1op(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--e2

function c32000443.e2setfilter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c32000443.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_COST)
end

function c32000443.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000443.e2setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end 
end

function c32000443.e2op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000443.e2setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SSET)
	local g=Duel.SelectMatchingCard(tp,c32000443.e2setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	local c=e:GetHandler()
	local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
end




