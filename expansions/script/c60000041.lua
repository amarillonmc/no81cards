--雾散雷鸣
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--local e2=e1:Clone()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.condition)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)

	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35699,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and not Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil):RandomSelect(tp,1)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_FZONE,0,nil)
	if g and #g~=0 then Duel.SendtoGrave(g,REASON_RULE) end
	if Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true)~=0 then
		local tc=e:GetHandler()
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.filter(c)
	return c:IsCode(60000032) and c:IsAbleToGraveAsCost()
end
function cm.pfil(c)
	return c:IsCode(60000032) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,100,REASON_EFFECT)
end
function cm.fil1(c)
	return c:IsCode(60000037) and c:IsAbleToHand()
end
function cm.fil2(c)
	return aux.IsCodeListed(c,60000032) and c:IsAbleToHand()
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if not b1 and not b2 then return end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if not Duel.IsPlayerCanDraw(tp,1) or not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end

	
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,60000036,0,0,1)
		Duel.RegisterFlagEffect(tp,60000037,RESET_PHASE+PHASE_END,0,1)
		local b1=true
		local b2=true
		local b3=true
		if Duel.GetFlagEffect(tp,m+10000000)~=0 then
			b1=false
			if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
		end
		if Duel.GetFlagEffect(tp,m+20000000)~=0 then
			b2=false
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if Duel.GetFlagEffect(tp,m+30000000)~=0 then
			b3=false
			if Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE,0,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
			end
		end
		local op=0
		if b1 or b2 or b3 then op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)},{b3,aux.Stringid(m,3)}) end
		if op==1 then Duel.RegisterFlagEffect(tp,60000037+10000000,0,0,1) 
		elseif op==2 then Duel.RegisterFlagEffect(tp,60000037+20000000,0,0,1) 
		elseif op==3 then Duel.RegisterFlagEffect(tp,60000037+30000000,0,0,1) end
	end

	
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
				local tc=g:GetFirst()
				if tc:CheckActivateEffect(true,true,false)==nil then return end
				if not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
				local te=tc:CheckActivateEffect(true,true,false)
				e:SetLabelObject(te:GetLabelObject())
				local op=te:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
end