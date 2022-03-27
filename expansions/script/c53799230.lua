local m=53799230
local cm=_G["c"..m]
cm.name="加点酒"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (not e:GetHandler():IsLocation(LOCATION_HAND) or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) end
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function cm.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,mg,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:CheckFusionMaterial(mg,nil,chkf)
end
function cm.filter3(c,e)
	return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,mg1,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,mg1,nil,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if tc then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			local ct=#mat1
			local exc=nil
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
			if exc~=nil then mat1:AddCard(exc) end
			local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,mat1)
			if ct>0 and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and #dg>=ct and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=dg:Select(tp,ct,ct,nil)
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end
