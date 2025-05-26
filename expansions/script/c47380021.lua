--黄金螺旋-三角“21”
local s,id=GetID()
function s.negate(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) or rp~=1-tp then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te or p~=tp then return false end
	return te:GetHandler():IsSetCard(0xcc13)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.spsummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,id-1000)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.rmfilter(c,tp,lv)
    if not c:IsType(TYPE_MONSTER) or not (c:GetLevel()>1 or c:GetLink()>1) then return false end
    if not c:IsAbleToRemove() or not (Duel.GetLocationCountFromEx(tp,tp,c)>0) then return false end
    return c:GetLevel()==lv+1 or c:GetLevel()==lv-1 or c:GetLink()==lv+1 or c:GetLink()==lv-1
end
function s.rmfilter2(c,lv)
    return c:GetLevel()==lv or c:GetLink()==lv
end
function s.fselect(g,lv)
    return g:IsExists(s.rmfilter2,1,nil,lv+1) and g:IsExists(s.rmfilter2,1,nil,lv-1) and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function s.tgfilter(c)
    return (c:GetLevel()>0 or c:GetLink()>0) and c:IsFaceup() and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp)
    return c:IsCode(47380005) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return s.tgfilter(chkc) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)>0 then
        local lv=0
        if tc:IsType(TYPE_LINK) then
            lv=tc:GetLink()
        else
            lv=tc:GetLevel()
        end
        local rg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,tc,tp,lv)
        if lv>1 and #rg>0 and rg:CheckSubGroup(s.fselect,2,2,lv) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local g=rg:SelectSubGroup(tp,s.fselect,false,2,2,lv)
            if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and Duel.GetLocationCountFromEx(tp)>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
                local tg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
                if #tg>0 then
                    local sc=tg:GetFirst()
                    if Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
                        sc:CompleteProcedure()
                    end
                end
            end
         end
    end
end
function s.initial_effect(c)
	s.negate(c)
    s.spsummon(c)
end
