--永不褪却的心之辉
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
end
function s.tdfilter(c)
	return c:IsSetCard(0x57b0) and c:IsAbleToDeck()
end    
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
    if not Duel.IsPlayerCanDraw(tp,1) then loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED end
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.fdfilter(c)
	return (c:IsOnField() and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
    if not Duel.IsPlayerCanDraw(tp,1) then loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter),tp,loc,0,e:GetHandler())
    if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,g:GetCount(),nil)
	if sg:GetCount()<=0 then return end
    local sg1=sg:Filter(Card.IsFacedown,nil)
    local sg2=sg:Filter(s.fdfilter,nil)
    if sg1:GetCount()>0 then
    	Duel.ConfirmCards(1-tp,sg1)
    end
    if sg2:GetCount()>0 then
    	Duel.HintSelection(sg2)
    end
    Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
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
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then break end
        local ctg1=Duel.GetDecktopGroup(tp,ct1)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
        local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        ct1=ct1-1
    end	
    for i=1,ct2 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then break end
        local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
        local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        ct2=ct2-1
    end	
    local cg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    Duel.BreakEffect()
    local hc=cg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)
    local mc=cg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
    local gc=cg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
    local res=false
    if hc>0 then
    	res=Duel.Draw(tp,hc,REASON_EFFECT)
    end
    if mc>0 then
    	if res then Duel.BreakEffect() end
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(s.discon)
		e1:SetOperation(s.disop)
    	e1:SetLabel(mc)
        e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
        res=true
    end
    if gc>0 then    	
        local dt=math.floor(gc/2)
        local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
        if dt>0 and tg:GetCount()>=dt and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
        	if res then Duel.BreakEffect() end
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
            local bg=tg:Select(tp,dt,dt,nil)
            if bg:GetCount()<=0 then return end
            Duel.HintSelection(bg)
            Duel.SendtoDeck(bg,nil,2,REASON_EFFECT)
        end
    end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetFlagEffect(tp,id)<e:GetLabel()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)	
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
        Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	end        
end