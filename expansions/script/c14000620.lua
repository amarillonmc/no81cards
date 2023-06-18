--编码-零 信息异常
local m=14000620
local cm=_G["c"..m]
cm.named_with_CodeNull=1
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	local e_h=Effect.CreateEffect(c)
	e_h:SetType(EFFECT_TYPE_SINGLE)
	e_h:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e_h:SetCondition(cm.checkcon)
	c:RegisterEffect(e_h)
end
function cm.Code0(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CodeNull
end
function cm.hafilter(c)
	return cm.Code0(c) and c:IsType(TYPE_LINK) and c:IsFaceup()
end
function cm.checkcon(e)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CHAINING,true)
	if res then
		return trp~=e:GetHandlerPlayer() and Duel.IsExistingMatchingCard(cm.hafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
	end
end
function cm.etarget(e,c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.efcfilter(c)
	return c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsExists(cm.efcfilter,1,nil)
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return cm.Code0(tc)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetValue(cm.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end