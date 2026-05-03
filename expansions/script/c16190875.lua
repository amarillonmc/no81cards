--超跃星★锚点变更协议
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--衍生物
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--不会成为对象
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0)
	e2:SetTarget(s.indtg)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--回卡组抽卡    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end
function s.costfilter(c,tp)
	return c:IsSetCard(0xca0) and c:IsType(TYPE_MONSTER) and c:GetAttribute()>0 and c:IsAbleToGraveAsCost()
    	and Duel.IsPlayerCanSpecialSummonMonster(tp,16190876,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,c:GetAttribute())
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
    	if e:GetLabel()==100 then
    		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil,tp)
        else return false end
    end       
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local atr=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,16190876,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_WARRIOR,atr) then
		local token=Duel.CreateToken(tp,16190876)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
        	local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atr)
			token:RegisterEffect(e1,true)        
        end
        Duel.SpecialSummonComplete()
	end    
end
function s.indtg(e,c)
	e:SetLabelObject(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xca0) and c:GetAttribute()>0
end
function s.indval(e,re,rp)
	local tc=e:GetLabelObject()
	return rp==1-e:GetHandlerPlayer() and re:GetHandler():GetAttribute()==tc:GetAttribute()
end
function s.tdfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0xca0) and c:IsAbleToDeck()
end    
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,5,nil)
	if g:GetCount()>0 then
    	Duel.HintSelection(g)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end