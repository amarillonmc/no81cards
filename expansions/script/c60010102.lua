--快速施法
function c60010102.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(60010102,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c60010102.handcon)
	c:RegisterEffect(e0) 
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60010102.cfmtg)
	e1:SetOperation(c60010102.cfmop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60010102,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60010102.sptg)
	e2:SetOperation(c60010102.spop)
	c:RegisterEffect(e2)   
end
function c60010102.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x634) and c:IsType(TYPE_RITUAL)
end
function c60010102.handcon(e)
	return Duel.IsExistingMatchingCard(c60010102.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--
function c60010102.cfmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x634)
end
function c60010102.cfmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c60010102.cfmfilter,tp,LOCATION_ONFIELD,0,1,c) end
end
function c60010102.cfmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c60010102.cfmfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	if g:GetCount()>0 then   
		local tg=g:GetFirst()
		tg:RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
		tg:RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
		tg:RegisterFlagEffect(60010095,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60010095,2))
	end
end
--
function c60010102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60010102.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end