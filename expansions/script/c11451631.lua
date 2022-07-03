--海燕
--21.09.02
local m=11451631
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.cost)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m+1,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(cm.condition1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m+2,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.condition2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	--mzone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m+3,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.condition3)
	e3:SetOperation(cm.operation3)
	c:RegisterEffect(e3)
	--szone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m+4,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(cm.condition4)
	e4:SetOperation(cm.operation4)
	c:RegisterEffect(e4)
	--grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m+5,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_GRAVE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(cm.condition5)
	e5:SetOperation(cm.operation5)
	c:RegisterEffect(e5)
	--extra
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m+6,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_MOVE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(cm.condition6)
	e6:SetOperation(cm.operation6)
	c:RegisterEffect(e6)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(cm.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.actlimit)
	c:RegisterEffect(e9)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then Duel.SendtoGrave(c,REASON_RULE) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,2))
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.cfilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsPreviousControler(tp) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(tp))
end
function cm.filter1(c)
	return c:IsSetCard(0x1979) and c:IsAbleToHand()
end
function cm.flag(e,tp,code)
	return e:GetHandler():GetFlagEffect(code)>0 or Duel.IsExistingMatchingCard(cm.ffilter,tp,0,LOCATION_MZONE,1,nil,code)
end
function cm.ffilter(c,code)
	return c:GetFlagEffect(code)>0 and c:IsHasEffect(11451675)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return cm.flag(e,tp,m+1) and eg:IsExists(cm.cfilter1,1,nil,tp)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.filter1,1-tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local hg=g:Select(1-tp,1,1,nil)
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(tp,hg)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.cfilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousControler(tp) and not (c:IsLocation(LOCATION_HAND) and c:IsControler(tp))
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return cm.flag(e,tp,m+2) and eg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(1-tp,1,REASON_EFFECT)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.cfilter3(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return cm.flag(e,tp,m+3) and eg:IsExists(cm.cfilter3,1,nil,tp)
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	Duel.RegisterEffect(e1,tp)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
	e:Reset()
end
function cm.cfilter4(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousControler(tp) and c:GetPreviousSequence()<5
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.cfilter4,nil,tp)
	if not cm.flag(e,tp,m+4) or #g==0 then return false end
	local lab=0
	for tc in aux.Next(g) do
		lab=lab|1<<tc:GetPreviousSequence()
	end
	e:SetLabel(lab)
	return true
end
function cm.desfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.operation4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local lab=e:GetLabel()
	local dg=Group.CreateGroup()
	for i=0,4 do
		if lab&(1<<i)~=0 then
			local g=Duel.GetMatchingGroup(cm.desfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)
			if #g>0 then dg:Merge(g) end
		end
	end
	Duel.Destroy(dg,REASON_RULE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(lab)
	e1:SetValue(cm.disval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.disval(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local lab=e:GetLabel()
	local val=0
	local table={1<<0|1<<8|1<<20|1<<28,1<<1|1<<9|1<<19|1<<27|1<<5|1<<22,1<<2|1<<10|1<<18|1<<26,1<<3|1<<11|1<<17|1<<25|1<<6|1<<21,1<<4|1<<12|1<<16|1<<24}
	for i=0,4 do
		local j=i
		if tp~=0 then j=4-i end
		if lab&(1<<i)~=0 then val=val+table[j+1] end
	end
	return val
end
function cm.cfilter5(c,tp)
	return c:IsPreviousControler(tp)
end
function cm.condition5(e,tp,eg,ep,ev,re,r,rp)
	return cm.flag(e,tp,m+5) and eg:IsExists(cm.cfilter5,1,nil,tp)
end
function cm.operation5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.cfilter6(c,tp)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsPreviousControler(tp)
end
function cm.condition6(e,tp,eg,ep,ev,re,r,rp)
	return cm.flag(e,tp,m+6) and eg:IsExists(cm.cfilter6,1,nil,tp)
end
function cm.operation6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if #tg>0 then
		local sg=tg:RandomSelect(tp,1)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
	Duel.RaiseEvent(e:GetHandler(),11451676,e,0,tp,tp,Duel.GetCurrentChain())
end