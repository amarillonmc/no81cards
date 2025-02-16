--OneInAMillion
local s,id,o=GetID()
function s.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --back
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x30)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.ckfi1ter(c) 
	return c:GetSequence()==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0x01,0)>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.ckfi1ter,tp,0x01,0,nil)
    if #g>0 then
        local tc=g:GetFirst()
        Duel.MoveSequence(tc,SEQ_DECKTOP)
        Duel.ConfirmDecktop(tp,1)
        local ThCheck=false
        if tc:IsType(TYPE_RITUAL) and tc:IsAbleToHand() then
            if Duel.SendtoHand(tc,nil,0x40)>0 then
                Duel.ConfirmCards(1-tp,tc)
                ThCheck=true
            end
        end
        if not ThCheck then Duel.MoveSequence(tc,SEQ_DECKBOTTOM) end
    end
end
function s.rlfil(c) 
	return c:IsReleasable() and c:GetOriginalType()&TYPE_MONSTER>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rlfil,tp,0x06,0,1,nil)
        and e:GetHandler():IsAbleToHandAsCost() end 
    Duel.Hint(3,tp,500)
	local g=Duel.SelectMatchingCard(tp,s.rlfil,tp,0x0e,0,1,1,e:GetHandler()) 
	Duel.Release(g,REASON_COST) 
    Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function s.rlgck(g,sc,tp)  
	Duel.SetSelectedCard(g) 
	return g:CheckWithSumGreater(Card.GetLevel,sc:GetLevel())
        and g:FilterCount(Card.IsLocation,nil,0x04)<=1
        and Duel.GetMZoneCount(tp,g)>0 
end 
function s.rspfi1ter(c,e,tp)
    local g=Duel.GetMatchingGroup(s.matfilter,c:GetControler(),0x36,0,c)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
        and g:CheckSubGroup(s.rlgck,1,#g,c,tp)
end 
function s.matfilter(c)
	return ((c:IsLocation(0x32) and c:IsAbleToDeck())
        or (c:IsLocation(0x04) and c:IsReleasableByEffect()))
        and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rspfi1ter,tp,0x70,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,0x36,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.rspfi1ter,tp,0x70,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
        mg:RemoveCard(tc)
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local mat=mg:SelectSubGroup(tp,s.rlgck,false,1,#mg,tc,tp)
		if not mat then goto cancel end
		tc:SetMaterial(mat)
        local check=false
        if mat:FilterCount(Card.IsLocation,nil,0x0c)>0 then check=true end
        local mg1=mat:Filter(Card.IsLocation,nil,0x32)
        local mg2=mat:Filter(Card.IsLocation,nil,0x04)
		if #mg1>0 then Duel.SendtoDeck(mg1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) end
        if #mg2>0 then Duel.Release(mg2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL) end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
        if check then
            local g=Duel.GetFieldGroup(tp,0x1c,0x1c):Filter(Card.IsAbleToHand,nil)
            if #g>0 then
                Duel.Hint(3,tp,505)
                local sg=g:Select(tp,1,1,nil)
                Duel.HintSelection(sg)
                Duel.SendtoHand(sg,nil,0x40)
            end
        end
	end
end