--罗星 幕状星云
local s,id,o=GetID()
function s.initial_effect(c)
    --SetSZone
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(0x06)  
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.htgtg)
	e1:SetOperation(s.htgop) 
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,0x08)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x30)
end
function s.Tdfi1ter(c)
	return c:IsSetCard(0x409) and c:IsAbleToDeck()
        and not (c:IsLocation(0x20) and c:IsFacedown())
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,0x08)>0 and c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
        local g=Duel.GetMatchingGroup(s.Tdfi1ter,tp,0x30,0,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.Hint(3,tp,507)
            local sg=g:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.SendtoDeck(sg,nil,1,0x40)
        end
	end
end
function s.cicon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,e:GetHandler(),ev)
	return g and #g>0 and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.citg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,e:GetHandler(),ev)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.GetFieldGroupCount(tp,0x0c,0x0c)>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=g:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=g:GetNext()
    end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,#g,tp,0x0c)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler() 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,c,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then
        local og=Duel.GetMatchingGroup(aux.TRUE,tp,0x0c,0x0c,nil)
        if #og>0 then
            Duel.Hint(3,tp,502)
            local sg=og:Select(tp,1,#tg,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,0x40)
        end
	end
end