--武色B-漆黑魔兽

local id=32000428
local zd=0x3c5
function c32000428.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,f1filter,f2filter,f3filter,false,false)
	
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c32000428.e1limit)
	c:RegisterEffect(e1)
	
	--NegateTargetEffect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c32000428.e2con)
	e2:SetOperation(c32000428.e2op)
	c:RegisterEffect(e2)
	
	--EquipWhenSpSum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id)
	e3:SetTarget(c32000428.e3tg)
	e3:SetOperation(c32000428.e3op)
	c:RegisterEffect(e3)
	
	--FreeDisable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69946549,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c32000428.e4tg)
	e4:SetOperation(c32000428.e4op)
	c:RegisterEffect(e4)
end

function f1filter(c)
    return c:IsSetCard(zd) and c:IsType(TYPE_FUSION)
end

function f2filter(c)
   return c:IsSetCard(zd) and c:IsType(TYPE_SPELL)
end

function f3filter(c)
   return c:IsSetCard(zd) and c:IsType(TYPE_TRAP)
end

--e1

function c32000428.e1limit(e,se,sp,st)
	return se:GetHandler():IsSetCard(zd) and se:GetHandlerPlayer()==e:GetHandlerPlayer()
end

--e2

function c32000428.gfilter(c,tp)
	return c:IsSetCard(zd) and c:IsControler(tp) 
    and (c:IsLocation(LOCATION_GRAVE) 
    or (c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFaceup()))
end

function c32000428.e2con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tp~=rp and g and g:IsExists(c32000428.gfilter,1,nil,tp)
end

function c32000428.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--e3


function c32000428.e3eqfilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER)
end

function c32000428.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000428.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function c32000428.e3op(e,tp,eg,ep,ev,re,r,rp)

    local counter
    for counter=1,3,1 do
    
        if not (Duel.IsExistingMatchingCard(c32000428.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then return end 
    
        if counter>1 and not Duel.SelectYesNo(tp,HINTMSG_EQUIP) 
        then return end
    
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	    local eqg=Duel.SelectMatchingCard(tp,c32000428.e3eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	    local etg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	    Duel.Equip(tp,eqg:GetFirst(),etg:GetFirst())
	
	    local c=eqg:GetFirst()
	    --equip limit
	    local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_EQUIP_LIMIT)
	    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	    e1:SetValue(true)
	    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    c:RegisterEffect(e1)
	
	end
end


--e4

function c32000428.e4disabfilter(c)
    return c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFaceup())
end

function c32000428.e4desfilter(c)
    return c:IsSetCard(zd) and c:IsDestructable() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end

function c32000428.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c32000428.e4disabfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c32000428.e4diabfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000428.e4op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
    end
    
end




