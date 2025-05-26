--异种 刽子手
function c98500140.initial_effect(c)
	--be target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98500140,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98500140)
	e1:SetCondition(c98500140.condition)
	e1:SetCost(c98500140.cost)
	e1:SetTarget(c98500140.target)
	e1:SetOperation(c98500140.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98500140,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,98500141)
	e2:SetTarget(c98500140.hsptg)
	e2:SetOperation(c98500140.hspop)
	c:RegisterEffect(e2)
	--flip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500140,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,98500141)
	e3:SetTarget(c98500140.destg)
	e3:SetOperation(c98500140.desop)
	c:RegisterEffect(e3)
   
end
function c98500140.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown()
end
function c98500140.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local op=Duel.SelectOption(tp,aux.Stringid(98500140,7),aux.Stringid(98500140,8))
	if op==0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_ATTACK)
	else
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c98500140.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500140.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c98500140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	if Duel.IsExistingMatchingCard(c98500140.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) then
		Duel.SetChainLimit(c98500140.chainlm)
	end
end
function c98500140.filter2(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c98500140.chainlm(e,rp,tp)
	return tp==rp
end
function c98500140.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c98500140.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function c98500140.filter3(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c98500140.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98500140.filter3(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsSummonable(true,nil) or e:GetHandler():IsMSetable(true,nil)) and (Duel.IsExistingTarget(c98500140.filter3,tp,LOCATION_MZONE,0,1,nil) or (Duel.IsPlayerAffectedByEffect(tp,98500080) and Duel.IsExistingTarget(c98500140.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if Duel.IsPlayerAffectedByEffect(tp,98500080) then
		local g=Duel.SelectTarget(tp,c98500140.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		local g=Duel.SelectTarget(tp,c98500140.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98500140.filter4(c)
	return c:IsFacedown() 
end
function c98500140.hspop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	 local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_SUMMON_SUCCESS)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e0:SetCountLimit(1,98500510)
		e0:SetReset(RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END)
		e0:SetOperation(c98500140.efilter)
		c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_MSET)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e4:SetCountLimit(1,98500510)
		e4:SetReset(RESET_PHASE+PHASE_END)
	 -- e4:SetLabelObject(c)
		e4:SetOperation(c98500140.efilter)
		Duel.RegisterEffect(e4,tp)
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
	local ts={}
	local index=1
	if e:GetHandler():IsSummonable(true,nil) then
		ts[index]=aux.Stringid(98500140,9)
		index=index+1
	end
	if e:GetHandler():IsMSetable(true,nil) then
	   ts[index]=aux.Stringid(98500140,10)
	   index=index+1
	end
	local c=e:GetHandler()
	local opt=Duel.SelectOption(tp,table.unpack(ts))
	if ts[opt+1]==aux.Stringid(98500140,9) then
		Duel.Summon(tp,c,true,nil)
	elseif ts[opt+1]==aux.Stringid(98500140,10) then
		Duel.MSet(tp,c,true,nil)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		   
		end
	end
end
function c98500140.efilter(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c98500140.filter4,tp,LOCATION_MZONE,0,nil)
			 Duel.ShuffleSetCard(g2)
end
function c98500140.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c98500140.desop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.HintSelection(g)
		  if  Duel.Destroy(tc,POS_FACEUP,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	   end
	end
end
