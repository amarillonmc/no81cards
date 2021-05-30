--穿梭的远古造物
require("expansions/script/c9910700")
function c9910730.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910730,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910730+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9910730.target)
	e1:SetOperation(c9910730.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910730,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9910730+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c9910730.cost)
	e2:SetTarget(c9910730.target2)
	e2:SetOperation(c9910730.activate2)
	c:RegisterEffect(e2)
end
function c9910730.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp)
		and Ygzw.SetFilter2(chkc,e,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ct>ft
		and Duel.IsExistingTarget(Ygzw.SetFilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,Ygzw.SetFilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil,e,tp)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_LEAVE_GRAVE)
	end
end
function c9910730.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or g:GetCount()>ft then return end
	Ygzw.Set2(g,e,tp)
end
function c9910730.cfilter(c,e,tp,mc)
	if c:IsFaceup() or not c:IsAbleToGraveAsCost() then return false end
	local ft=0
	if mc:IsLocation(LOCATION_HAND) then ft=1 end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local flag=ct>ft or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5)
	return flag and Duel.IsExistingMatchingCard(c9910730.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
function c9910730.setfilter(c,e,tp)
	if not c:IsCanBeEffectTarget(e) then return false end
	if not c:IsSetCard(0xc950) or not c:IsType(TYPE_MONSTER) then return false end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function c9910730.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9910730.cfilter,tp,LOCATION_ONFIELD,0,c,e,tp,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c9910730.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp)
		and Ygzw.SetFilter2(chkc,e,tp) end
	if chk==0 then return true end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,Ygzw.SetFilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_REMOVE)
	end
	Duel.SetChainLimit(c9910730.chlimit)
end
function c9910730.chlimit(e,ep,tp)
	return tp==ep
end
function c9910730.rmfilter(c,mg)
	local res=mg:IsContains(c)
	for mc in aux.Next(mg) do
		if mc:GetColumnGroup():IsContains(c) then res=true end
	end
	return res and c:IsAbleToRemove()
end
function c9910730.rmfilter2(g)
	for c in aux.Next(g) do
		local cg=Group.__band(c:GetColumnGroup(),g)
		if cg:GetCount()>0 then return false end
	end
	return true
end
function c9910730.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 or g:GetCount()>ft then return end
	local og=Ygzw.Set2(g,e,tp):Filter(Card.IsOnField,nil)
	if og:GetCount()==0 then return end
	local tg=Duel.GetMatchingGroup(c9910730.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,og)
	if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910730,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=tg:SelectSubGroup(tp,c9910730.rmfilter2,false,1,#tg)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
