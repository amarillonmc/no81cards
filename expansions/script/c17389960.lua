--终烬本源
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,17389960)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.matfilter,4,4,true)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_MZONE,0,aux.ContactFusionSendToDeck(c))
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.optg)
	e1:SetOperation(s.opop)
	c:RegisterEffect(e1)	
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local code = tc:GetCode()
		Duel.RegisterFlagEffect(0,code+1,RESET_PHASE+PHASE_END,0,1)
	end
end

function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x5f51) and Duel.GetFlagEffect(0,c:GetCode()+1)>0
end

function s.cfilter(c)
	return s.matfilter(c) and c:IsAbleToDeckOrExtraAsCost()
end

function s.thfilter(c)
	return c:IsAbleToHand() and Duel.GetFlagEffect(0,c:GetCode()+1)>0
end

function s.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_MONSTER)
	local b2=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
	local b3=Duel.GetFlagEffect(tp,id+3)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	local b4=Duel.GetFlagEffect(tp,id+4)==0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b5=Duel.GetFlagEffect(tp,id+5)==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)	
	if chk==0 then return b1 or b2 or b3 or b4 or b5 
	end	
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1}, 
		{b2,aux.Stringid(id,2),2}, 
		{b3,aux.Stringid(id,3),3}, 
		{b4,aux.Stringid(id,4),4}, 
		{b5,aux.Stringid(id,5),5}) 
	e:SetLabel(op)
	Duel.RegisterFlagEffect(tp,id+op,RESET_PHASE+PHASE_END,0,1)
	Duel.SetChainLimit(aux.FALSE)
end

function s.opop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_MONSTER)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	elseif op==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	elseif op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.SetChainLimit(aux.FALSE)
		end
	end
end