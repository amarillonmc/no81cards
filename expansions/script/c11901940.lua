--幻龙兽“龙姬”龙女仆
local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
	aux.AddXyzProcedure(c,nil,8,2)  
	c:EnableReviveLimit()
    --SpSum(0x01)
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) 
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end)
    e1:SetTarget(s.sptg)  
	e1:SetOperation(s.spop)  
	c:RegisterEffect(e1)
    --Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(function(e) 
	    local ph=Duel.GetCurrentPhase()
	    return Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
            and (ph<PHASE_BATTLE_START or ph>PHASE_BATTLE) end)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
    --BattleStart
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
    e3:SetCondition(function(e)
	    return Duel.GetTurnPlayer()~=e:GetHandler():GetControler() end)
    e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x40a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():GetOverlayCount()>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x01,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,0x40) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    Duel.Hint(3,tp,509)
	    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0x01,0,1,1,nil,e,tp)
	    if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
        return e:GetHandler():GetOverlayCount()>0 and #g>0
    end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,0x40) then
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
       	if #g>0 then
            Duel.Hint(3,tp,504)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.SendtoGrave(sg,0x400)
        end
        local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetCode(EFFECT_UPDATE_ATTACK)
	    e1:SetTargetRange(0,LOCATION_MZONE)
	    e1:SetValue(-1000)
	    e1:SetReset(RESET_PHASE+PHASE_END)
	    Duel.RegisterEffect(e1,tp)
	end
end