--罗星 加利福尼亚星云
local s,id,o=GetID()
function s.initial_effect(c)
    --SynMonserSpSum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
    e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --negate
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.spfilter(c,e,tp,val)
	return c:IsSetCard(0x409) and c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(val+6)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.Starfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x409)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local mat=Duel.GetMatchingGroupCount(s.Starfilter,tp,0x08,0,nil)
        return Duel.IsExistingMatchingCard(s.spfilter,tp,0x40,0,1,nil,e,tp,mat) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local mat=Duel.GetMatchingGroupCount(s.Starfilter,tp,0x08,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x40,0,1,1,nil,e,tp,mat)
	if #g>0 then
        local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then tc:CompleteProcedure() end
    end
end
function s.fi1ter(c)
	return c:IsLocation(0x04) and c:IsFaceup()
end
function s.fi2ter(c,e)
	return c:IsRelateToEffect(e) and s.fi1ter(c)
end
function s.fi3ter(c,g)
	return c:IsSetCard(0x409) and c:IsSynchroSummonable(nil,g) 
end
function s.cicon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        or not re:GetHandler():IsSetCard(0x409) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(s.fi1ter,nil)
    g:AddCard(e:GetHandler())
	return g and Duel.IsExistingMatchingCard(s.fi3ter,tp,0x40,0,1,nil,g)
        and e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function s.citg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(s.fi1ter,nil)
	local tc=tg:GetFirst()
    while tc do
	    tc:CreateEffectRelation(e)
        tc=tg:GetNext()
    end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local c=e:GetHandler() 
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(s.fi2ter,c,e)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and #tg>0 then
        tg:AddCard(c)
		local g2=Duel.GetMatchingGroup(s.fi3ter,tp,0x40,0,nil,tg)
        if #g2>0 then
            Duel.Hint(3,tp,509)
            local sg=g2:Select(tp,1,1,nil)
            Duel.SynchroSummon(tp,sg:GetFirst(),nil,tg)
        end
	end
end