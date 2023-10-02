--厮杀之际
local this,id,ofs=GetID()
function this.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(this.spcon)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetRange(LOCATION_GRAVE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id+ofs)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetTarget(this.dtg)
    e3:SetOperation(this.dop)
    c:RegisterEffect(e3)
end
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD)
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,c:GetLocation())
    if c:IsLocation(LOCATION_GRAVE) then
        e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
        e:SetLabel(1)
    end
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)>0
    and e:GetLabel()>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
        if tc then
            Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
        end
    end
end
function this.dfilter1(c,tp)
    return c:IsDestructable() and c:IsFaceup()
    and Duel.IsExistingTarget(this.dfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function this.dfilter2(c)
    return c:IsDestructable() and c:IsFaceup()
end
function this.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(this.dfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,this.dfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,this.dfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function this.dop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetsRelateToChain()
    if #g~=2 then return end
    Duel.Destroy(g,REASON_EFFECT)
end
