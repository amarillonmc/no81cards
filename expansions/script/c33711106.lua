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
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetLabel(2)
	e12:SetCost(cm.cost)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetRange(LOCATION_GRAVE)
	e13:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e13:SetCost(cm.cost)
	e13:SetLabel(3)
	c:RegisterEffect(e13)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	c:CreateEffectRelation(e)
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsCanRemoveCounter(tp,0x1442,1,REASON_COST) then
		e:GetHandler():RemoveCounter(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
		if Duel.GetTurnPlayer()==1-tp then
			local disg=Duel.GetMatchingGroup(cm.disfilter,1-tp,LOCATION_HAND,0,c)
			local b1=( true )
			local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,1-tp,LOCATION_DECK,0,31,nil,1-tp,POS_FACEDOWN,REASON_COST) ) 
			local b3=( disg:GetClassCount(Card.GetCode)>3 )
			local op1=0
			if b1 and b2 and b3 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
			elseif b1 and b2 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
			elseif b1 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,1))
			elseif b2 then op1=Duel.SelectOption(1-tp,aux.Stringid(m,2))+1
			else return end
			if op1==0 or op2==0 or op3==0 then cm.selop1(e,1-tp,eg,ep,ev,re,r,rp) end
			if op1==1 or op2==1 or op3==1 then cm.selop2(e,1-tp,eg,ep,ev,re,r,rp) end
			if op1==2 or op2==2 or op3==2 then cm.selop3(e,1-tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function cm.disable(e,c)
	return c~=e:GetHandler() and  c:IsFaceup() 
end
function cm.disfilter(c)
	return c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	local c=e:GetHandler()
	local el=e:GetLabel()
	local b1=( true )
	local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,31,nil,tp,POS_FACEDOWN,REASON_COST) ) 
	local b3=( disg:GetClassCount(Card.GetCode)>3 )
	if chk==0 then 
		if el==1 then 
			return b1 or b2 or b3 
		elseif el==2 then
			return  ( b1 and b2 ) or ( b2 and b3 ) or (  b1 and b3 )
		elseif el==3 then
			return b1 and b2 and b3
		end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local el=e:GetLabel()
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	local c=e:GetHandler()
	local el=e:GetLabel()
	local b1=( true )
	local b2=( Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,31,nil,tp,POS_FACEDOWN,REASON_COST) ) 
	local b3=( disg:GetClassCount(Card.GetCode)>3 )
	local op1=-1
	local op2=-1
	local op3=-1
	local tt={aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3)}
	if el==1 then
		if b1 and b2 and b3 then op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		elseif b1 and b2 then op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then op1=Duel.SelectOption(tp,aux.Stringid(m,1))
		elseif b2 then op1=Duel.SelectOption(tp,aux.Stringid(m,2))+1
		else return end
	end
	if el==2 then 
		if b1 and b2 and b3 then 
			op1=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
			table.remove(tt,op1+1)
			op2=Duel.SelectOption(tp,table.unpack(tt))
			if op1==0 then op2=op1+1 end
			if op1==1 and op2==0 then op2=1 end
		elseif b1 then op1=0 
			if b2 then op2=1 
			elseif b3 then op2=2 
			end
		elseif b2 and b3 then op1=1 op2=2
		end
	end
	if el==3 and b1 and b2 and b3 then op1=0 op2=1 op3=2 end
	if op1==0 or op2==0 or op3==0 then cm.selop1(e,tp,eg,ep,ev,re,r,rp) end
	if op1==1 or op2==1 or op3==1 then cm.selop2(e,tp,eg,ep,ev,re,r,rp) end
	if op1==2 or op2==2 or op3==2 then cm.selop3(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.selop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local disg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g1=disg:SelectSubGroup(tp,aux.dncheck,true,4,4)
	Duel.ConfirmCards(1-tp,g1)
	Duel.SendtoGrave(g1,REASON_EFFECT)
	c:AddCounter(0x1442,1)
end
function cm.selop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Damage(tp,4200,REASON_EFFECT)
	c:AddCounter(0x1442,1)
end
function cm.selop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rm=Duel.GetDecktopGroup(tp,31)
	Duel.Remove(rm,POS_FACEDOWN,REASON_EFFECT)
	c:AddCounter(0x1442,1)
end