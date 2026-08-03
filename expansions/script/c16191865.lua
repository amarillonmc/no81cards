--含苞的心之辉 芈祢
local s,id,o=GetID()
function s.initial_effect(c)
	--检测
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_DRAW)
    e0:SetRange(0xff)
    e0:SetCondition(s.regcon)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)   
	--特殊召唤
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)   
	--抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(s.drcost)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=0
end    
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end    
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id)<2
    else
    	con=Duel.GetFlagEffect(tp,id)<1
    end
	if chk==0 then return con and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.mtfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function s.xyzfilter(c,mg)
	return c:IsSetCard(0x57b0) and c:IsXyzSummonable(mg)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	Duel.AdjustAll()
        local mg=Duel.GetMatchingGroup(s.mtfilter,tp,LOCATION_MZONE,0,nil)
        local sg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
        if mg:GetCount()>0 and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        	Duel.BreakEffect()
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sc=sg:Select(tp,1,1,nil):GetFirst()
            Duel.XyzSummon(tp,sc,mg,1,6)
        end
	end
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.tdfilter(c)
	return c:IsSetCard(0x57b0) and c:IsAbleToDeck()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con and Duel.IsPlayerCanDraw(tp,2) 
    	and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil) end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil)
	if g:GetCount()<=0 then return end
    Duel.HintSelection(g)
    Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
    local rg=Duel.GetOperatedGroup()
	local kg=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local ct1=kg:FilterCount(Card.IsControler,nil,tp)
	local ct2=kg:FilterCount(Card.IsControler,nil,1-tp)
	if ct1>0 then
		if ct1>1 then
			Duel.SortDecktop(tp,tp,ct1)
		end
	end
	if ct2>0 then
		if ct2>1 then
			Duel.SortDecktop(tp,1-tp,ct2)
		end
	end
    for i=1,ct1 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then break end
        local ctg1=Duel.GetDecktopGroup(tp,ct1)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
        local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        ct1=ct1-1
    end	
    for i=1,ct2 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then break end
        local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
        local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        ct2=ct2-1
    end	
	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if oc<=0 then return end
    Duel.BreakEffect()
    Duel.Draw(tp,2,REASON_EFFECT)
end