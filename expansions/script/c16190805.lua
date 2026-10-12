--苍炎之骑士＝兰斯洛特
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,s.matfilter1,s.matfilter2,true)
	--抽卡    
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.drcon)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--多次攻击    
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--无效    
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.distg)
	c:RegisterEffect(e3)
end
function s.matfilter1(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE)
end
function s.matfilter2(c,fc)
	return c:IsOnField() and c:IsControler(fc:GetControler())
end    
function s.distg(e,c)
    local tp=e:GetHandlerPlayer()
    local lg=e:GetHandler():GetColumnGroup()
    return c~=e:GetHandler() and lg:IsContains(c) and c:IsControler(1-tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
    re:GetHandler():RegisterFlagEffect(id,RESET_CHAIN,0,1)
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
        e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetFlagEffect(id)>0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.RegisterFlagEffect(tp,id,0,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    if Duel.GetFlagEffect(tp,id)>=2 and Duel.IsChainDisablable(ev) then
    	e:SetCategory(CATEGORY_DRAW+CATEGORY_DISABLE)
    	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
    end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 and Duel.GetFlagEffect(tp,id)>=2 and Duel.IsChainDisablable(ev)
    	and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
    	Duel.BreakEffect()
        Duel.NegateEffect(ev)
    end
end