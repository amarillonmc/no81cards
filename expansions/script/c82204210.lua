local m=82204210
local cm=_G["c"..m]
cm.name="川尻忍"
function cm.initial_effect(c)
	aux.AddCodeList(c,82204200)
	--spsummon proc  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1) 
	--lvup  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCost(cm.cost)  
	e2:SetOperation(cm.operation)  
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))	
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,82214210)  
	e3:SetTarget(cm.sttg)  
	e3:SetOperation(cm.stop)  
	c:RegisterEffect(e3) 
end
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local p=tc:GetControler()
	if Duel.Remove(tc,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		e1:SetLabel(p)
		e1:SetLabelObject(tc)  
		e1:SetCountLimit(1)  
		e1:SetOperation(cm.retop)  
		Duel.RegisterEffect(e1,tp)
	end
end  
function cm.retop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SendtoHand(e:GetLabelObject(),e:GetLabel(),nil)
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsFaceup() and c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_LEVEL)  
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)  
		e1:SetValue(2)  
		e1:SetReset(RESET_EVENT+0x1ff0000)  
		c:RegisterEffect(e1)  
	end  
end  
function cm.stfilter(c)  
	return c:IsCode(82204200) or c:IsCode(82204204) and c:IsSSetable()  
end  
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_DECK,0,1,nil) end  
end  
function cm.stop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SSet(tp,g)  
	end  
end  