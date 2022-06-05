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
function Ygzw.SpFilter(c,loc,tp)
	local b1=c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsAbleToRemoveAsCost()
	local b2=c:IsLocation(LOCATION_DECK) and Duel.IsPlayerAffectedByEffect(tp,9910743) and c:IsAbleToGraveAsCost()
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and (b1 or b2)
end
function Ygzw.SpCondition(ct)
	return  function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				local g1=Duel.GetMatchingGroup(Ygzw.SpFilter,tp,LOCATION_GRAVE,0,nil,LOCATION_GRAVE,tp)
				local g2=Duel.GetMatchingGroup(Ygzw.SpFilter,tp,LOCATION_DECK,0,nil,LOCATION_DECK,tp)
				return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (#g1>=ct or (#g1>=ct-1 and #g2>0))
			end
end
function Ygzw.SpOperation(ct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g1=Duel.GetMatchingGroup(Ygzw.SpFilter,tp,LOCATION_GRAVE,0,nil,LOCATION_GRAVE,tp)
				local g2=Duel.GetMatchingGroup(Ygzw.SpFilter,tp,LOCATION_DECK,0,nil,LOCATION_DECK,tp)
				if #g2>0 and (#g1<ct or Duel.SelectYesNo(tp,aux.Stringid(9910700,0))) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg2=g2:Select(tp,1,1,nil)
					Duel.SendtoGrave(sg2,REASON_COST)
					ct=ct-1
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg1=g1:Select(tp,ct,ct,nil)
				Duel.Remove(sg1,POS_FACEUP,REASON_COST)
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
function Ygzw.AddTgFlag(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetOperation(Ygzw.TgOperation())
	c:RegisterEffect(e1)
end
function Ygzw.TgOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsPreviousLocation(LOCATION_ONFIELD) then
					c:RegisterFlagEffect(9910700,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910700,1))
				end
			end
end
