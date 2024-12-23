--幻龙兽“龙神”巴哈姆特
local s,id,o=GetID()
function s.initial_effect(c)
    --xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,s.xyzcheck,2,99)
    --direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
    --change  
	local e2=Effect.CreateEffect(c) 
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
        and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnPlayer()==e:GetHandler():GetSummonPlayer() end)
    e2:SetTarget(s.cgtg)
	e2:SetOperation(s.pscg) 
	c:RegisterEffect(e2)
    --negate
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
function s.lvrk(c) 
	if c:IsLevelAbove(1) then 
	return c:GetLevel() 
	elseif c:IsRankAbove(1) then 
	return c:GetRank() 
	else return nil end 
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) or c:IsXyzType(TYPE_SYNCHRO)
end
function s.xyzcheck(g)
	return g:GetClassCount(s.lvrk)==1
end
function s.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.SetChainLimit(aux.FALSE)
end
function s.pscg(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	Duel.SkipPhase(Duel.GetTurnPlayer(),ph,RESET_PHASE+ph,1)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and Duel.IsChainNegatable(ev) and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,0x40) and Duel.NegateActivation(ev) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0e,nil)
       	if #g>0 then
            Duel.BreakEffect()
            Duel.Hint(3,tp,504)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.SendtoGrave(sg,0x400)
        end
	end
end