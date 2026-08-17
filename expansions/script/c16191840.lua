--不凋的心之辉 石莲
local s,id,o=GetID()
function s.initial_effect(c)
	--选择效果适用
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)   
	--无效    
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.discon1)
    e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.discon2)
	c:RegisterEffect(e3)   
end
function s.thfilter(c)
	return c:IsSetCard(0x57b0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id)<2
    else
    	con=Duel.GetFlagEffect(tp,id)<1
    end
	if chk==0 then return con and (b1 or b2) end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    if not b1 and not b2 then return end    
	if not c:IsRelateToEffect(e) then return end
    local op=aux.SelectFromOptions(tp,
		{b1,1152,1},
		{b2,aux.Stringid(id,4),2})
    if op==1 then
    	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    elseif op==2 then
    	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
        end
    end	
end
function s.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c) 
        and c:IsAbleToDeckAsCost() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
    Duel.HintSelection(g)
    Duel.SendtoDeck(g,nil,0,REASON_COST)
    Duel.ConfirmCards(1-tp,c)
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
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then break end
        local ctg1=Duel.GetDecktopGroup(tp,ct1)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        ct1=ct1-1
    end	
    for i=1,ct2 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,6)) then break end
        local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        ct2=ct2-1
    end	
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con and sg:GetCount()>0 end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
end
function s.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(sc))
		if not sc:IsCanBeDisabledByEffect(e) then return end
		Duel.NegateRelatedChain(sc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		sc:RegisterEffect(e2)
		if sc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			sc:RegisterEffect(e3)
		end
        Duel.AdjustInstantly(sc)
        if Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
            Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local tc=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			Duel.HintSelection(Group.FromCards(tc))
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)            
		end            
	end
end
--
Corflos={}
cor=Corflos
function Corflos.RanuticusFilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsAllTypes(TYPE_XYZ+TYPE_MONSTER) or c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER))
    	and c:IsOriginalSetCard(0x57b0)
end
function Corflos.IsCanBeQuickEffect(c,tp,code)
	return Duel.IsPlayerAffectedByEffect(tp,code)~=nil and Corflos.RanuticusFilter~=nil and Corflos.RanuticusFilter(c)
end