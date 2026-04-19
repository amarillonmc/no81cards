--时隙乱流
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id+o)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xae5d) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local cg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,dg:GetCount(),e:GetHandler())
	local tc=cg:GetFirst()
	local ctype=0
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoHand(cg,nil,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,cg:GetCount(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,count,count,nil)
	if g:GetCount()==count then
		Duel.HintSelection(g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end
function s.filter1(c)
	return  c:GetFlagEffect(4879171)~=0
end
function s.thfilter(c)
	return c:IsSetCard(0xae5d) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
local b1=Duel.IsExistingMatchingCard(s.filter1,tp,0x3f,0x3f,1,nil)
local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
   local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,3)
		opval[off-1]=2
		off=off+1
	end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
if opval[op]==1 then

	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
local op=e:GetLabel()
 if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.filter1,tp,0x3f,0x3f,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	local turne=tc[tc]
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
   
end