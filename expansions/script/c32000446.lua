--武色连战

local id=32000446
local zd=0x3c5
function c32000446.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	
	--ActInSetTurn
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e0)
			
    --active
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	
	--RemoveWhenOpSumSpSumOrActMonster
	--RemoveWhenCainingOpMonsterAct
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c32000446.e2con)
	e2:SetTarget(c32000446.e2tg)
	e2:SetOperation(c32000446.e2op)
	c:RegisterEffect(e2)
	
	--RemoveWhenCainingOpSumSpSum
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c32000446.e3con)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	--SetSelfByRemoveSMP3
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,id)
	e5:SetCost(c32000446.e5cost)
	e5:SetTarget(c32000446.e5tg)
	e5:SetOperation(c32000446.e5op)
	c:RegisterEffect(e5)
end



--e2

function c32000446.e2confilter(c)
    return c:IsSetCard(zd) and c:IsFaceup()
end


function c32000446.e2con(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if rp~=1-tp then return false end
	return re:GetHandler():IsType(TYPE_MONSTER)
end

function c32000446.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32000446.e2confilter,tp,LOCATION_ONFIELD,0,2,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
   
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFILED)
end

function c32000446.e2op(e,tp,eg,ep,ev,re,r,rp)
  
	if not (Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)) then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	
end

--e3

function c32000446.e3con(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=eg:GetFirst()
	return tc:IsControler(1-tp)
end

--e5

function c32000446.e5filter(c)
    return c:IsSetCard(zd) and c:IsAbleToRemoveAsCost()
end

function c32000446.e5cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c32000446.e5filter,tp,LOCATION_GRAVE,0,3,c) end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32000446.e5filter,tp,LOCATION_GRAVE,0,3,3,c)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_COST)
end

function c32000446.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0.then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp) end
end


function c32000446.e5op(e,tp,eg,ep,ev,re,r,rp)    
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end







