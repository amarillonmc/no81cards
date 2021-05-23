Ygzw = {}

function Ygzw.AddSpProcedure(c,ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Ygzw.SpCondition(ct))
	e1:SetOperation(Ygzw.SpOperation(ct))
	c:RegisterEffect(e1)
end
function Ygzw.SpFilter(c)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsAbleToRemoveAsCost()
end
function Ygzw.SpCondition(ct)
	return  function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
					and Duel.IsExistingMatchingCard(Ygzw.SpFilter,tp,LOCATION_GRAVE,0,ct,nil)
			end
end
function Ygzw.SpOperation(ct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Ygzw.SpFilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
				Duel.Remove(g,POS_FACEUP,REASON_COST)
			end
end
function Ygzw.SetFilter(c,e,tp)
	if c:IsType(TYPE_TOKEN) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function Ygzw.SetFilter2(c,e,tp)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and Ygzw.SetFilter(c,e,tp)
end
function Ygzw.Set(c,e,tp)
	local op=e:GetHandlerPlayer()
	local res=Duel.MoveToField(c,op,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	Duel.ConfirmCards(1-tp,c)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,op,op,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	return res
end
function Ygzw.Set2(g,e,tp)
	local op=e:GetHandlerPlayer()
	local og=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,op,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
			og:AddCard(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.RaiseEvent(og,EVENT_SSET,e,REASON_EFFECT,op,op,0)
	return og
end
