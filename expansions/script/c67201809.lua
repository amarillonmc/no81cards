--银白宫殿的千金 馨西亚二世
local s,id,o=GetID()
function c67201809.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--to gy
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67201809,1))
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e0:SetCountLimit(1,67201810)
	e0:SetCost(c67201809.tgcost)
	e0:SetTarget(c67201809.tgtg)
	e0:SetOperation(c67201809.tgop)
	c:RegisterEffect(e0)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.mvcon2)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)   
end
--
function s.filter1(c)
	return c:IsSetCard(0x667f) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:Select(tp,2,2,nil)
	if tc then
		tc:KeepAlive()
		e:SetLabelObject(tc)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ggg=e:GetLabelObject()
	local tc1=ggg:GetFirst()
	local tc2=ggg:GetNext()
	if Duel.MoveToField(tc1,tp,tc1:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc2,tp,tc2:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc2:RegisterEffect(e1)
			--tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc1:RegisterEffect(e2)
		--tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
--
function c67201809.tgfilter(c)
	return c:IsSetCard(0x667f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c67201809.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c67201809.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201809.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67201809.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67201809.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--
function s.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev<2 then return false end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and rp==1-tp and te and te:GetHandler():IsSetCard(0x667f) 
		and Duel.GetFlagEffect(tp,id)==0
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev)
	end
end