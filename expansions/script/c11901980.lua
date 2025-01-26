--魔海的女王
local s,id,o=GetID()
function s.initial_effect(c)
    --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,s.matfilter,3,3)
	--effect gain
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.matfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0x1e,0,e:GetHandler())
	if chk==0 then return #g>0
        and #g==g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN) end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.spfilter(c,e,tp,st)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,true) and c:IsType(st)
        and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local flag=0
        local mg=e:GetHandler():GetMaterial()
        local st=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK
        if mg:FilterCount(Card.IsLinkType,nil,TYPE_FUSION)>0 then flag=flag+1 st=st-TYPE_FUSION end
        if mg:FilterCount(Card.IsLinkType,nil,TYPE_SYNCHRO)>0 then flag=flag+1 st=st-TYPE_SYNCHRO end
        if mg:FilterCount(Card.IsLinkType,nil,TYPE_XYZ)>0 then flag=flag+1 st=st-TYPE_XYZ end
        if mg:FilterCount(Card.IsLinkType,nil,TYPE_LINK)>0 then flag=flag+1 st=st-TYPE_LINK end
        e:SetLabel(st)
        return flag==3 and Duel.IsExistingMatchingCard(s.spfilter,tp,0x40,0,1,nil,e,tp,st) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.spfilter,tp,0x40,0,nil,e,tp,e:GetLabel())
	if #g>0 then
        Duel.Hint(3,tp,509)
        local sg=g:Select(tp,1,1,nil)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end