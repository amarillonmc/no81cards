local m=82206052
local cm=_G["c"..m]
cm.name="植占师32-回转"
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck) 
	--spsummon condition  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)  
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)  
	e0:SetValue(aux.linklimit)  
	c:RegisterEffect(e0)  
	--immune  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(cm.efilter)  
	c:RegisterEffect(e1) 
	--to deck 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCost(cm.cost) 
	e3:SetTarget(cm.tg)  
	e3:SetOperation(cm.op)  
	c:RegisterEffect(e3)
	--destroy  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_DESTROY)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e4:SetCode(EVENT_PHASE+PHASE_END)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetCountLimit(1)  
	e4:SetCondition(cm.descon)  
	e4:SetTarget(cm.destg)  
	e4:SetOperation(cm.desop)  
	c:RegisterEffect(e4)  
end
function cm.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_PLANT)  
end  
function cm.efilter(e,te)  
	local c=e:GetHandler()  
	local ec=te:GetHandler() 
	if ec:IsHasCardTarget(c) or (te:IsHasType(EFFECT_TYPE_ACTIONS) and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and c:IsRelateToEffect(te)) then return false end  
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil,REASON_RULE) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,c,REASON_RULE) end  
	local g1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil,REASON_RULE)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,c,REASON_RULE)   
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO) 
	local tg=Group.CreateGroup()
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil,REASON_RULE) 
	tg:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF) 
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,c,REASON_RULE)  
	tg:Merge(g2)
	Duel.HintSelection(tg)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_RULE)~=0 then
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(1000)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsRelateToEffect(e) then  
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)  
	end  
end  