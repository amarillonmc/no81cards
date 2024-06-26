--跨越噩梦回廊
function c67200762.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200762,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,67200762+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c67200762.condition)
	e1:SetCost(c67200762.cost)
	e1:SetTarget(c67200762.target(EVENT_CHAINING))
	e1:SetOperation(c67200762.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_END,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetTarget(c67200762.target(EVENT_FREE_CHAIN))
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SUMMON)
	e3:SetTarget(c67200762.target(EVENT_SUMMON))
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON)
	e4:SetTarget(c67200762.target(EVENT_FLIP_SUMMON))
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetTarget(c67200762.target(EVENT_SPSUMMON))
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TO_HAND)
	e6:SetTarget(c67200762.target(EVENT_TO_HAND))
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetTarget(c67200762.target(EVENT_ATTACK_ANNOUNCE))
	c:RegisterEffect(e7)	
	--to hand
	local e8=Effect.CreateEffect(c)
	--e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	--e8:SetCode(EVENT_FREE_CHAIN)
	--e8:SetCountLimit(1,67200762)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c67200762.lktg)
	e8:SetOperation(c67200762.lkop)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(67200755,1))
	--e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_REMOVE)
	--e9:SetCountLimit(1,67200762)
	e9:SetTarget(c67200762.lktg)
	e9:SetOperation(c67200762.lkop)
	c:RegisterEffect(e9)
end
--
function c67200762.cfilter(c)
	return c:IsCode(67200755) and c:IsFaceup()
end
function c67200762.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67200762.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c67200762.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c67200762.filter(c,event)
	if not (c:GetType()==TYPE_TRAP and c:IsSetCard(0x367d) and c:IsAbleToRemoveAsCost()) then return false end
	local te=c:CheckActivateEffect(false,true,false)
	return te and te:GetCode()==event
end
function c67200762.target(event)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				if e:GetLabel()==0 then return false end
				e:SetLabel(0)
				return Duel.IsExistingMatchingCard(c67200762.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,event)
			end
			e:SetLabel(0)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,c67200762.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,event)
			local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
			Duel.Remove(g,POS_FACEUP,REASON_COST)
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
			te:SetLabelObject(e:GetLabelObject())
			e:SetLabelObject(te)
			Duel.ClearOperationInfo(0)
		end
end
function c67200762.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
--
function c67200762.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200762.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x367d))
	e1:SetValue(300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
