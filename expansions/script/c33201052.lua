--血晶充能
local s,id,o=GetID()
Duel.LoadScript("c33201050.lua")
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.cttg)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
end
s.VHisc_Vampire=true

--e1
function s.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x32b,1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500,true) and Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32b)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500,true) and Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		local ct=XY_VHisc.LPcost(tp)
		while ct>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=sg:GetFirst()
			tc:AddCounter(0x32b,1)
			ct=ct-1
		end
	end
end

--e2
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,1,REASON_EFFECT) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		Duel.BreakEffect()
		local m=Duel.GetCounter(tp,LOCATION_ONFIELD,0,0x32b)
		if m>10 then m=10 end
		local t={}
		for i=1,m do
			t[i]=i
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local rect=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x32b,rect,REASON_EFFECT)
		Duel.Recover(tp,rect*500,REASON_EFFECT)
	end
end