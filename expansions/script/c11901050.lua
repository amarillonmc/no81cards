--噬星狂鲨 卡翠欧娜
local s,id,o=GetID()
function s.initial_effect(c)
    --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
    --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.setg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
    --atk up 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(s.atkcon) 
	e3:SetOperation(s.atkop) 
	c:RegisterEffect(e3)
    --destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(s.desreptg)
	c:RegisterEffect(e4)
end
function s.desfi1ter(c,e)
    local pl=c:GetControler()
    return c:GetColumnGroup():FilterCount(s.desfi2ter,nil,e,pl)>0
end
function s.desfi2ter(c,e,pl)
    return c:IsCanBeEffectTarget(e) and c:IsControler(1-pl)
end
function s.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.desfi1ter,tp,LOCATION_ONFIELD,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g1=Duel.SelectTarget(tp,s.desfi1ter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
    local g2=g1:GetFirst():GetColumnGroup():Filter(s.desfi2ter,nil,e,tp):Select(tp,1,1,nil)
    Duel.SetTargetCard(g2)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if #g==2 then Duel.Destroy(g,REASON_EFFECT) end
end
function s.ackfil(c) 
	return c:IsReason(REASON_EFFECT+REASON_BATTLE)
        and c:IsPreviousLocation(LOCATION_ONFIELD)
end 
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)   
	return eg:FilterCount(s.ackfil,nil)>0   
end 
function s.atkop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local ec=eg:FilterCount(s.ackfil,nil)
	if c:IsFaceup() and ec>0 then 
		Duel.Hint(HINT_CARD,0,id)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(ec*400) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1)
	end 
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetAttack()>=c:GetBaseAttack() and c:GetAttack()>=1000 end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(-1000) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		c:RegisterEffect(e1,true)
		return true
	else return false end
end