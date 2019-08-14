--乌托兰的造访者
function c10122019.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,10122011),2,2)	 
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(c10122019.con)
	e1:SetValue(10122011)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.imval1)
	--c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(1)
	--c:RegisterEffect(e3)   
	--activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10122019,0))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,10122019)
	e4:SetCondition(c10122019.con2)
	e4:SetTarget(c10122019.tg)
	e4:SetOperation(c10122019.op)
	c:RegisterEffect(e4) 
	--immue  
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c10122019.con)
	e5:SetValue(c10122019.efilter)
	c:RegisterEffect(e5) 
end
function c10122019.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function c10122019.con(e)
	--stack over limit
	--if not Duel.IsExistingMatchingCard(c10122019.tgfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler()) then return false end
	return Duel.IsExistingMatchingCard(c10122019.tgfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c10122019.tgfilter2(c)
	--return c:IsFaceup() and (c:GetOriginalCode()==10122011 or (c:IsHasEffect(10122018) and c:IsCode(10122011)))
	return c:IsFaceup() and ((c:IsType(TYPE_TOKEN) and c:IsCode(10122011)) or (c:IsHasEffect(10122018) and c:IsCode(10122011)))
end
function c10122019.tgfilter(c)
	return c:IsFaceup() and c:IsCode(10122011)
end
function c10122019.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(10122011) and c:IsControler(tp)
end
function c10122019.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c10122019.cfilter,1,e:GetHandler(),tp)
end
function c10122019.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0xc333)
end
function c10122019.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10122019.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c10122019.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10122020,0))
	local tc=Duel.SelectMatchingCard(tp,c10122019.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10122019.tdfilter),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10122019,1)) then
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		   local tg=g:Select(tp,1,999,nil)
		   if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
			  local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			  Duel.Recover(tp,ct*800,REASON_EFFECT)
		   end
		end
	end
end
function c10122019.tdfilter(c)
	return c:IsSetCard(0xc333) and c:IsAbleToDeck()
end
