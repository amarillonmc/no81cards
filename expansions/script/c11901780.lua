--罗星 苍蝇座
local s,id,o=GetID()
function s.initial_effect(c)
    --SetCard(0x30)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x06)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
    e1:SetTarget(s.sttg)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.cicon)
	e2:SetTarget(s.citg)
	e2:SetOperation(s.ciop)
	c:RegisterEffect(e2)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.stfilter(c)
    return c:IsSetCard(0x409) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
        and c:IsFaceup() and not c:IsForbidden()
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(s.stfilter,tp,0x30,0,1,nil) end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
    local val=Duel.GetLocationCount(tp,LOCATION_SZONE)
    if val==0 then return end
    if val>2 then val=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.stfilter),tp,0x30,0,1,val,nil)
    local tc=g:GetFirst()
    while tc do
	    if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(tc,tp,tp,0x08,POS_FACEUP,true) then
            local e1=Effect.CreateEffect(e:GetHandler())
		    e1:SetCode(EFFECT_CHANGE_TYPE)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		    e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		    tc:RegisterEffect(e1)
        end
        tc=g:GetNext()
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
        and Duel.IsPlayerCanDraw(1-tp,#g) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=g:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=g:GetNext()
    end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,#g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler() 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,c,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then 
		local Dval=Duel.Draw(1-tp,#tg,0x40)
        local hg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x02,nil,tp,POS_FACEDOWN)
        if Dval==#tg and #hg>=Dval then
            Duel.ShuffleHand(1-tp)
            Duel.Hint(3,tp,503)
            local sg=hg:RandomSelect(tp,Dval)
            Duel.BreakEffect()
            Duel.Remove(sg,POS_FACEDOWN,0x40)
        end
	end 
end