--思念的连结★超跃星★黛雅蒙多·D
local s,id,o=GetID()
function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_WARRIOR),3,5,s.lcheck)
	c:EnableReviveLimit()
	--特召限制    
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	--无效    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--全部攻击    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetCondition(s.exzcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--复制    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+o)
    e3:SetCost(s.copycost)
	e3:SetTarget(s.copytg)
	e3:SetOperation(s.copyop)
	c:RegisterEffect(e3)
end
function s.lkfilter(c)
	return c:IsLinkSetCard(0xca0) and c:IsLinkType(TYPE_LINK)
end    
function s.lcheck(g)
	return g:IsExists(s.lkfilter,2,nil)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(84815190,3))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
    	Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.exzcon(e)
	return e:GetHandler():GetSequence()>4
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.copyfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xca0) and c:IsLinkBelow(5) and not c:IsCode(id) and c:IsAbleToExtraAsCost()
    	and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))) then return false end
	local te=c.beyond_free_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
    	if e:GetLabel()==100 then
    		return Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
        else return false end
    end       
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.copyfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
    Duel.HintSelection(Group.FromCards(tc))
    Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
	local te=tc.beyond_free_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToEffect(e) then
		local te=tc.beyond_free_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end