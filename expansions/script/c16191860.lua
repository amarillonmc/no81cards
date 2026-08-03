--幽秘的心之辉 夜上花
local s,id,o=GetID()
function s.initial_effect(c)
	--选择效果适用
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)   
	--破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.descon1)
    e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.descon2)
	c:RegisterEffect(e3)   
end
function s.spfilter(c,e,tp)
	return not c:IsCode(id) and c:IsSetCard(0x57b0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
    	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil,e,tp)
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id)<2
    else
    	con=Duel.GetFlagEffect(tp,id)<1
    end
	if chk==0 then return con and (b1 or b2) end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
    	and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil,e,tp)
    if not b1 and not b2 then return end    
	if not c:IsRelateToEffect(e) then return end
    local op=aux.SelectFromOptions(tp,
		{b1,1152,1},
		{b2,aux.Stringid(id,4),2})
    if op==1 then
    	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    elseif op==2 then
    	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
        	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133)
				or Duel.GetMatchingGroupCount(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)<2 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil,e,tp)
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)==2 then
            	Duel.AdjustAll()
            	local sg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil) 
            	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
                	Duel.BreakEffect()
                	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=sg:Select(tp,1,1,nil):GetFirst()
                    if not sc then return end
                    Duel.XyzSummon(tp,sc,nil)
            	end
            end            
        end
    end	
end
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c) 
        and c:IsAbleToDeckAsCost() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
    Duel.HintSelection(g)
    Duel.SendtoDeck(g,nil,0,REASON_COST)
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
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,7)) then break end
        local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        ct2=ct2-1
    end	
end
function s.tgfilter(c)
	return c:IsAbleToGrave() and c:IsFaceup() and c:IsSetCard(0x57b0) 
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,0,nil)
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con and sg:GetCount()>0 end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,0,nil)
    if sg:GetCount()<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local tg=sg:Select(tp,1,sg:GetCount(),nil)
    if tg:GetCount()<=0 then return end
    Duel.HintSelection(tg)
    if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
    	local oc=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
        local dg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
        if oc>0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,6)) then
        	Duel.BreakEffect()
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        	local g=dg:Select(tp,oc,oc,nil)
        	if g:GetCount()>0 then
        		Duel.HintSelection(g)
            	Duel.Destroy(g,REASON_EFFECT)
            end    
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