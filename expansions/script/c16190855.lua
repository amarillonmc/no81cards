--再迁跃★超跃星★伽妮特露比·FⅡ
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),2,3,s.lcheck)
	c:EnableReviveLimit()
	--卡组检索    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--战破耐性    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(s.exzcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--给与伤害
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
    s.beyond_free_effect=e3    
end
function s.lkfilter(c)
	return c:IsLinkSetCard(0xca0) and c:IsLinkType(TYPE_LINK)
end    
function s.lcheck(g)
	return g:IsExists(s.lkfilter,1,nil)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.thfilter(c)
	return c:IsSetCard(0xca0) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
    	and Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.exzcon(e)
	return e:GetHandler():GetSequence()>4
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
    Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
    local ch=Duel.GetCurrentChain()
    if ch>1 then
		local p,te,loc=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
		if p==1-tp and te:IsActiveType(TYPE_MONSTER) and loc&(LOCATION_HAND|LOCATION_GRAVE)>0 then
        	e:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
        end
    end            
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then
    	local ch=Duel.GetCurrentChain()
        if ch>1 then
			local p,te,loc=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_LOCATION)
			if p==1-tp and te:IsActiveType(TYPE_MONSTER) and loc&(LOCATION_HAND|LOCATION_GRAVE)>0
        		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        		Duel.BreakEffect()
        		Duel.NegateEffect(ch-1)
            end    
        end
    end
end