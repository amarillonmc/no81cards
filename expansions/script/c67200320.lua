--结天缘狩 抗争之阶
function c67200320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200320,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c67200320.condition)
	e1:SetCost(c67200320.cost)
	e1:SetTarget(c67200320.target(EVENT_CHAINING))
	e1:SetOperation(c67200320.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(c67200320.target(EVENT_FREE_CHAIN))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON)
	e3:SetTarget(c67200320.target(EVENT_SUMMON))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	e4:SetTarget(c67200320.target(EVENT_FLIP_SUMMON))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetTarget(c67200320.target(EVENT_SPSUMMON))
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TO_HAND)
	e6:SetTarget(c67200320.target(EVENT_TO_HAND))
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetTarget(c67200320.target(EVENT_ATTACK_ANNOUNCE))
	c:RegisterEffect(e7)
end
--
function c67200320.actfilter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c67200320.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c67200320.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c67200320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c67200320.filter(c,event)
	if not (c:GetType()==TYPE_TRAP and c:IsSetCard(0x671) and c:IsAbleToHandAsCost() and not c:IsCode(67200320)) then return false end
	local te=c:CheckActivateEffect(false,true,false)
	return te and te:GetCode()==event
end
function c67200320.target(event)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				if e:GetLabel()==0 then return false end
				e:SetLabel(0)
				return Duel.IsExistingMatchingCard(c67200320.filter,tp,LOCATION_GRAVE,0,1,nil,event)
			end
			e:SetLabel(0)
			local _GetCurrentChain=Duel.GetCurrentChain
			Duel.GetCurrentChain=function() return _GetCurrentChain()-1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,c67200320.filter,tp,LOCATION_GRAVE,0,1,1,nil,event)
			local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
			Duel.GetCurrentChain=_GetCurrentChain
			Duel.SendtoHand(g,nil,REASON_COST)
			Duel.ConfirmCards(1-tp,g)
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
			Duel.ClearOperationInfo(0)
		end
end
function c67200320.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end


