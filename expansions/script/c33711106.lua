--～自我收容的个人宇宙～
local m=33711106
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x1442)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e12=e1:Clone()
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetRange(LOCATION_HAND)
	e12:SetLabel(2)
	e12:SetCost(cm.cost)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetRange(LOCATION_GRAVE)
	e13:SetLabel(3)
	e13:SetCost(cm.cost)
	c:RegisterEffect(e13)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(cm.leacon)
	e6:SetOperation(cm.leaop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(e)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp,chk)
	
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanRemoveCounter(tp,0x1442,1,REASON_COST) then
		e:GetHandler():RemoveCounter(tp,0x1442,1,REASON_COST)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
function cm.disable(e,c)
	return c~=e:GetHandler() and c:IsFaceup() 
end
function cm.disfilter(c)
	return c:IsDiscardable()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	local c=e:GetHandler()
	local el=e:GetLabel()
	local b1=( true )
	local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,31,nil,tp,POS_FACEDOWN,REASON_EFFECT) ) 
	local b3=( disg:GetClassCount(Card.GetCode)>3 )
	if chk==0 then 
		if el==1 then
			return true
		elseif el==2 then
			return b2 or b3
		elseif el==3 then
			return b2 and b3
		end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local el=e:GetLabel()
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	local el=e:GetLabel()
	local b1=( true )
	local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,31,nil,tp,POS_FACEDOWN,REASON_COST) ) 
	local b3=( disg:GetClassCount(Card.GetCode)>3 )
	local op1=-1
	local op2=-1
	local op3=-1
	local tt={aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3)}
	if el==1 then
		if b2 and b3 then op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		elseif b2 then op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b3 then op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))*2
		else op1=0 end
	end
	if el==2 then 
		if b2 and b3 then
			op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
			table.remove(tt,op1+1)
			op2=Duel.SelectOption(tp,table.unpack(tt))
			if op1==0 then op2=op2+1 end
			if op1==1 and op2==1 then op2=2 end
		elseif b2 then op1=0 op2=1
		elseif b3 then op1=0 op2=2
		else return end
	end
	if el==3 and b1 and b2 and b3 then op1=0 op2=1 op3=2 end
	local ct=-1
	if (op1==0 or op2==0 or op3==0) and cm.selop1(e,tp,eg,ep,ev,re,r,rp) then ct=ct+1 end
	if (op1==1 or op2==1 or op3==1) and cm.selop2(e,tp,eg,ep,ev,re,r,rp) then ct=ct+1 end
	if (op1==2 or op2==2 or op3==2) and cm.selop3(e,tp,eg,ep,ev,re,r,rp) then ct=ct+1 end
	if ct>0 then
		c:AddCounter(0x1442,ct)
		c:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function cm.selop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=disg:SelectSubGroup(tp,aux.dncheck,false,4,4)
	Duel.ConfirmCards(1-tp,g1)
	return Duel.SendtoGrave(g1,REASON_EFFECT+REASON_DISCARD)~=0
end
function cm.selop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.Damage(tp,4200,REASON_EFFECT)~=0
end
function cm.selop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rm=Duel.GetDecktopGroup(tp,31)
	return Duel.Remove(rm,POS_FACEDOWN,REASON_EFFECT)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x1442)>0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.leacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and e:GetLabelObject():GetLabel()==1
end
function cm.leaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local disg=Duel.GetMatchingGroup(cm.disfilter,1-tp,LOCATION_HAND,0,c)
	local b1=( true )
	local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,31,nil,1-tp,POS_FACEDOWN,REASON_EFFECT) ) 
	local b3=( disg:GetClassCount(Card.GetCode)>3 )
	local op1=-1
	if b2 and b3 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b2 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b3 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,3))*2
	else op1=0 end
	if op1==0 then cm.selop1(e,1-tp,eg,ep,ev,re,r,rp) end
	if op1==1 then cm.selop2(e,1-tp,eg,ep,ev,re,r,rp) end
	if op1==2 then cm.selop3(e,1-tp,eg,ep,ev,re,r,rp) end
end
