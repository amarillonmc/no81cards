--既是恶魔也是淑女 爱妮慕丝
local s,id,o=GetID()
function s.initial_effect(c)
	--特召限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetRange(LOCATION_GRAVE)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--选择效果发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)            
end
function s.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function s.confilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(7)
end    
function s.spfilter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
    local seq=c:GetSequence()    
    local zone=0
    if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|(1<<(seq-1)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|(1<<(seq+1)) end    
	local ct=Duel.GetMatchingGroupCount(s.confilter,tp,LOCATION_GRAVE,0,nil)
	local b1=ct>=3 and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
	local b2=ct>=5 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
    	and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
    	e:SetCategory(CATEGORY_DESTROY)
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    elseif op==2 then
    	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
    end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
    if op==1 then
    	local tc=Duel.GetFirstTarget()        
        if tc:IsRelateToEffect(e) then
        	Duel.Destroy(tc,REASON_EFFECT)
    	end
    elseif op==2 then
    	local c=e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
    	local seq=c:GetSequence()    
    	local zone=0
    	if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then zone=zone|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then zone=zone|(1<<(seq+1)) end    
        if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
        if g:GetCount()>0 then
        	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
        end
    end
end