--赌场的女王 茵薇迪雅
local s,id,o=GetID()
function s.initial_effect(c)
	--选择效果发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
    e1:SetCost(s.efcost)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)    
end
function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(5)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk.chkc)
	local b1=Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
    	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()==tp
    if chkc then return false end
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2})
	e:SetLabel(op)
	if op==1 then
    	e:SetCategory(CATEGORY_DESTROY)
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    elseif op==2 then
    	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
    if op==1 then
    	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    	if tg:GetCount()>0 then
        	Duel.Destroy(tg,REASON_EFFECT)
    	end
    elseif op==2 then
    	local tc=Duel.GetFirstTarget()        
        if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)       
        end
    end
end