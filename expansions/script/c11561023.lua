--星界之圣像骑士
function c11561023.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c11561023.lcheck)
	c:EnableReviveLimit()  
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c11561023.atkval)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c11561023.antg)
	c:RegisterEffect(e2)  
	--to deck 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)   
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1) 
	--e3:SetCondition(c11561023.tdcon)
	e3:SetCost(c11561023.tdcost)
	e3:SetTarget(c11561023.tdtg) 
	e3:SetOperation(c11561023.tdop) 
	c:RegisterEffect(e3)
end
function c11561023.lcheck(g)
	return g:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
end
function c11561023.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil)
	return g:GetSum(Card.GetBaseAttack)
end
function c11561023.antg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c11561023.tdckfil(c,e,tp) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsFaceup() and c:IsType(TYPE_EFFECT) 
end 
function c11561023.tdcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c11561023.tdckfil,1,nil,e,tp)  
end 
function c11561023.tdcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsControler,nil,tp)
	if chk==0 then return g:IsExists(Card.IsReleasable,1,nil) end 
	local tc=g:Filter(Card.IsReleasable,nil):Select(tp,1,1,nil):GetFirst() 
	if tc:IsSetCard(0x116,0xfe) then 
	e:SetLabel(1) 
	else e:SetLabel(0) end  
	Duel.Release(tc,REASON_COST)
end 
function c11561023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561023.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end 
function c11561023.setfil(c) 
	if not (c:IsSetCard(0x116) and c:IsType(TYPE_SPELL)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c11561023.filter(c) 
	return c:IsAbleToDeck()
end
function c11561023.fcheck(g,tp)
	return g:FilterCount(Card.IsControler,nil,tp)<=1 and g:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function c11561023.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c11561023.filter),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:SelectSubGroup(tp,c11561023.fcheck,false,1,2,tp)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c11561023.setfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11561023,0)) then 
			local tc=Duel.SelectMatchingCard(tp,c11561023.setfil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() 
			if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else 
				Duel.SSet(tp,tc)   
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end  
		end  
	end 
end 