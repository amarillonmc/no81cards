--斗魂觉醒·卡莉丝塔
local m=91861570
local cm=c91861570
function c91861570.initial_effect(c)
	aux.AddLinkProcedure(c,nil,3,6,cm.lcheck)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(cm.immcon)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCondition(cm.atkcon)
	e5:SetOperation(cm.atkop)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(cm.acop1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.accon)
	e1:SetOperation(cm.acop2)
	c:RegisterEffect(e1)
end
function cm.lfilter(c)
	return  c:IsLinkSetCard(0x870)
end
function cm.lcheck(g)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if re:GetHandler()~=e:GetHandler()  then
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if  c:GetFlagEffect(m)>=3 then 
		c:ResetFlagEffect(m)
		if tog==nil then
		local tog=Group.CreateGroup()
		tog:AddCard(re:GetHandler()) 
		else tog:AddCard(re:GetHandler()) end
		tog:KeepAlive()
		e:SetLabelObject(tog)
end
		Duel.RaiseEvent(tog,EVENT_CUSTOM+m,e,0,0,0,0) 
		Debug.Message(eg:GetCount())
		Debug.Message(eg:GetFirst():GetCode())
	end
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	if  e:GetHandler():GetFlagEffect(m)>=3 then
	local tog=e:GetLabelObject()
	return		 Duel.RaiseEvent(tog,EVENT_CUSTOM+m,e,0,0,0,0) 
end
function cm.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(m)
end
function cm.atkfilter(c)
	return c:IsFaceup()
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		e6:SetValue(200)
		tc:RegisterEffect(e6)
		tc=g:GetNext()
	end
end
function cm.atktg(e,c)
	return  e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
