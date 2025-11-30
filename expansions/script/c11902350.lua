--飓风海劫“幻魔”幻想号
local s,id,o=GetID()
function s.initial_effect(c)
    --SetOrRemove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
    c:RegisterEffect(e1)
    --SpSum(0x10)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
    e2:SetCondition(s.con1)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(s.con2)
    c:RegisterEffect(e3)
    if not s.SetCheck then
	    local ek=Effect.CreateEffect(c) 
	    ek:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ek:SetCode(EVENT_CHAINING)
	    ek:SetOperation(s.ciop)
	    Duel.RegisterEffect(ek,tp)
    end
end
function s.rcCheck(c)
    return c:IsLocation(0x08)
       and not (c:IsHasEffect(EFFECT_REMAIN_FIELD)
        or c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP))
end
function s.ciop(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc and s.rcCheck(rc) then
        rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,nil,1,0)
    end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c,cid)
    return (c:IsCanTurnSet() or c:IsAbleToRemove(tp,POS_FACEDOWN))
        and c:GetFlagEffect(cid)==0
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x0c) and s.filter(chkc,id) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,0x0c,1,nil,id) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,0x0c,1,1,nil,id)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.SetChecking(c)
    return c:IsFaceup() and c:IsCanTurnSet() 
        and (c:IsLocation(0x04) or c:GetOriginalType()&TYPE_MONSTER==0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetFlagEffect(id)==0 then 
        if s.SetChecking(tc) then
            if tc:IsLocation(0x04) then
                Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
            else
                Duel.ChangePosition(tc,POS_FACEDOWN)
            end
        else
            Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
        end
	end
end
function s.cfi2ter(c)
	return c:IsFaceup() and c:IsSetCard(0x540b)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x04,0,1,nil)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfi2ter,tp,0x04,0,1,nil)
end
function s.desfilter(c,e)
	return c:IsRace(RACE_AQUA) and c:IsFaceup() and c:IsDestructable(e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0x04,0,1,nil,e)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	local g=Duel.GetFieldGroup(tp,0x04,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(3,tp,502)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0x04,0,nil,e)
	if g:GetCount()>0 then
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()  
        Duel.HintSelection(tg)
		if Duel.Destroy(tc,0x40)>0 and c:IsRelateToEffect(e) then
            Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end