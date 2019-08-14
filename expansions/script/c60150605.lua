--千夜 阴冷的笑容
function c60150605.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c60150605.discon)
    e3:SetTarget(c60150605.distg)
    e3:SetOperation(c60150605.disop)
    c:RegisterEffect(e3)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,60150605)
    e2:SetTarget(c60150605.sptg)
    e2:SetOperation(c60150605.spop)
    c:RegisterEffect(e2)
    local e22=e2:Clone()
    e22:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e22)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_REMOVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e4:SetCode(EVENT_TO_DECK)
    e4:SetCountLimit(1,6010605)
    e4:SetCondition(c60150605.descon)
    e4:SetTarget(c60150605.destg)
    e4:SetOperation(c60150605.desop)
    c:RegisterEffect(e4)
end
function c60150605.discon(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x3b21) then return false end
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and tp~=ep
end
function c60150605.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if not e:GetHandler():IsDestructable() then return false end
    if chk==0 then return true end
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c60150605.disop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if re:GetHandler():IsRelateToEffect(re) then
         if Duel.Destroy(eg,REASON_EFFECT)>0 then
            Duel.BreakEffect()
            Duel.Destroy(e:GetHandler(),REASON_EFFECT)
         end
    end
end
function c60150605.xyzlimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0x5b21)
end
function c60150605.filter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x3b21) and not c:IsCode(60150605) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) 
        or (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0))
end
function c60150605.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150605.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c60150605.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCountFromEx(tp)>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60150605.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif Duel.GetMZoneCount(tp)<=0 and Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60150605.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCountFromEx(tp)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c60150605.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60150605.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return not (c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)) 
        and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150605.filter2(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c60150605.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150605.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c60150605.filter2,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150605,1))
end
function c60150605.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c60150605.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end