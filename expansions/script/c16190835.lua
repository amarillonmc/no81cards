--训练特装★超跃星★萨菲·RX
local s,id,o=GetID()
function s.initial_effect(c)
	--适用效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.efcost)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--特殊召唤    
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.costfilter(c,tp)
	local lk=c:GetLink()
    local b1=Duel.IsPlayerCanDraw(tp,lk)
    local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	return c:IsSetCard(0xca0) and c:IsFaceup() and c:IsType(TYPE_LINK) and lk>0 and (b1 or b2) and c:IsAbleToRemoveAsCost()
end    
function s.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
    	if e:GetLabel()==100 then
    		return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,tp)
        else return false end
    end       
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
    e:SetLabelObject(tc)
    local lk=tc:GetLink()
    local tg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,lk)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,lk-1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tg,1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
    local lk=tc:GetLink()
    local c=e:GetHandler()
    local b1=Duel.IsPlayerCanDraw(tp,lk)
    local b2=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if lk<=0 or (not b1 and not b2) then return end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2})
    if op==1 then
    	local ct=Duel.Draw(tp,lk,REASON_EFFECT)
        if ct>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,ct-1,ct-1,nil)
			Duel.ShuffleHand(tp)
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		end
    elseif op==2 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tg=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,lk,nil)
		if tg:GetCount()<1 then return end
        Duel.HintSelection(tg)
		for tc in aux.Next(tg) do
			if tc:IsCanBeDisabledByEffect(e,false) then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
			end
		end
    end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
    local tc=Duel.GetOperatedGroup():GetFirst()
    e:SetLabelObject(tc)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    if tc:IsSetCard(0xca0) then
    	e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	local tc=e:GetLabelObject()
        if tc:IsSetCard(0xca0) and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) 
        	and aux.NecroValleyFilter()(tc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        	Duel.BreakEffect()
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end