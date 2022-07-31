--轮回世界 失欲
function c6162602.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(6162602,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,6162602)  
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e1:SetCondition(c6162602.condition) 
	e1:SetTarget(c6162602.target)  
	e1:SetOperation(c6162602.operation)  
	c:RegisterEffect(e1)  
end
function c6162602.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)  
end  
function c6162602.setfilter(c)  
	return c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(6162602) 
end  
function c6162602.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c6162602.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end  
end  
function c6162602.operation(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c6162602.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.SSet(tp,tc)~=0 then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)  
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1)  
	end  
end  