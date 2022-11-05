--废坑深殿 梵格尔夫
function c67200241.initial_effect(c)
	aux.AddCodeList(c,67200161) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200241+EFFECT_COUNT_CODE_OATH)
	--e1:SetTarget(c67200241.target)
	e1:SetOperation(c67200241.activate)
	c:RegisterEffect(e1)
	--move to spell & trap zone
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200241,3))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c67200241.tfcon)
	e3:SetTarget(c67200241.tftg)
	e3:SetOperation(c67200241.tfop)
	c:RegisterEffect(e3)	   
end
function c67200241.filter(c)
	return aux.IsCodeListed(c,67200161) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c67200241.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200241.activate(e,tp,eg,ep,ev,re,r,rp)
	--lcoal c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67200241.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(67200241,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.SSet(tp,tc)
		end
	end
end
function c67200241.tfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousControler(tp)
end
function c67200241.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c67200241.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(67200241,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1)
	end
end

