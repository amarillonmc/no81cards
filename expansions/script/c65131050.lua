--🥒
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_SEND_REPLACE)
	e0:SetTarget(s.tdtg)
	e0:SetValue(aux.TRUE)
	c:RegisterEffect(e0)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e01:SetCode(id)
	e01:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e01)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetValue(0xc976)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local _MoveToField=Duel.MoveToField
		local _ReturnToField=Duel.ReturnToField
		local _Equip=Duel.Equip
		function Duel.MoveToField(c,tp,...)
			if c:IsHasEffect(id) and s.tdtg(e,tp,nil,nil,nil,nil,nil,nil,1,c) then
				return false
			end
			return _MoveToField(c,tp,...)
		end
		function Duel.ReturnToField(c,...)
			if c:IsHasEffect(id) then
				s.tdtg(e,c:GetControler(),nil,nil,nil,nil,nil,nil,1,c)
			end
			return _ReturnToField(c,...)
		end
		function Duel.Equip(tp,c,mc,...)
			if c:IsHasEffect(id) then
				s.tdtg(e,tp,nil,nil,nil,nil,nil,nil,1,c)
			end
			return _Equip(tp,c,mc,...)
		end
	end
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if not c then c=e:GetHandler() end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if chk==0 then return c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) and c:GetDestination()~=LOCATION_REMOVED end
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
		return false
	else
		return true
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_ONFIELD) and c:GetOriginalCode()==id end
	return true
end
function s.repval(e,c)
	return c:IsFaceup() and c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	c:SetEntityCode(id+1,true)
	c:ReplaceEffect(id+1,0,0)
end