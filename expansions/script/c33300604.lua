--深腐诞地 吞噬怪
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,33300600)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(s.damcon2)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.actfilter(c,e,tp)
	return c:IsCode(33300600) and c:GetActivateEffect():IsActivatable(tp,true,true)
		or (Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_FZONE,0,1,nil,33300600)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x6569)
		and c:IsLevelBelow(6))
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			local te=tc:GetActivateEffect()
			if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
			Duel.ResetFlagEffect(tp,15248873)
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function s.cfilter(c)
	return c:GetCounter(0x0569)>0
end
function s.iee(c)
	return c:GetCounter(0x0569)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=sg:GetSum(s.iee)
	return ct>0 and Duel.GetTurnPlayer()~=tp
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=sg:GetSum(s.iee)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
		and ct>0 and Duel.GetTurnPlayer()~=tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	tp=e:GetHandlerPlayer()
	local sg=Duel.GetMatchingGroup(s.cfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=Duel.GetCounter(tp,1,0,0x0569)--sg:GetSum(s.iee)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end