--血晶扩散风暴
local s,id,o=GetID()
Duel.LoadScript("c33201050.lua")
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetLabel(0)
	e1:SetCost(s.cost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
end
s.VHisc_Vampire=true

--e1
function s.desfilter(c,datk)
	return c:IsFaceup() and c:GetAttack()<=datk
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x32b)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local datk=ct*500
		return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,datk) end

	local g1,minatk=g:GetMinGroup(Card.GetAttack)
	local g2,maxatk=g:GetMaxGroup(Card.GetAttack)
	local cost=0
	if maxatk==0 then 
		cost=1
	else
		local m1=math.ceil(minatk/500)
		if m1==ct then
			cost=m1
		else
			local t={}
			for i=m1,ct do
				t[i]=i
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
			cost=Duel.AnnounceNumber(tp,table.unpack(t))
		end
	end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,cost,REASON_COST)
	local datk=cost*500
	e:SetLabel(cost)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,datk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local datk=e:GetLabel()*500
	e:SetLabel(0)
	if datk==0 then return end
	if e:GetHandler():IsOnField() and e:GetHandler():IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,datk)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--e2
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end