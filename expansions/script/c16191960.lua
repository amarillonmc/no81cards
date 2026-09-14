--波与粒的境界
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)    
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c)	
	return c:IsFaceup() and c:IsSetCard(0x67b0) and c:IsType(TYPE_FUSION)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local ch=Duel.GetCurrentChain()
    if ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
    	e:SetCategory(CATEGORY_NEGATE+CATEGORY_SSET)
   	else
        e:SetCategory(CATEGORY_SSET)     
    end    
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    local ch=Duel.GetCurrentChain()
    local b1=aux.bpcon(e,tp,eg,ep,ev,re,r,rp) and not tc:IsHasEffect(EFFECT_DIRECT_ATTACK) 
    	and not tc:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK)
    local b2=ch>1 and Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER)==1-tp
    	and e:IsHasType(EFFECT_TYPE_ACTIVATE)
    local res=false
    if b1 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--直接攻击    
    	local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		--ep送墓        
        local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCountLimit(1)
		e2:SetOperation(s.regop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
        res=true
    end
    if b2 and Duel.IsChainNegatable(ch-1) then
    	if res then Duel.BreakEffect() end
    	Duel.NegateActivation(ch-1)
        res=true
    end
    if res then Duel.BreakEffect() end
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetOperation(s.setop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)          
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function s.setfilter(c)
	return c:IsCode(id) and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end