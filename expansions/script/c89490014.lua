--炯眼的桎梏
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local g=Group.FromCards()
	g:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(g)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(s.checkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
	s[e3]={e1,e2}
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetTarget(s.sumlimit)
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
	local e2=e5:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e2)
	local e3=e5:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e3)
	local e4=e5:Clone()
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetValue(s.aclimit)
	c:RegisterEffect(e4)
end
function s.costfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsType(TYPE_MONSTER)
end
function s.rlfilter(c)
	return c:IsFaceup() and c:IsReleasable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe2=Duel.IsPlayerAffectedByEffect(tp,89490080)
	local b2=fe2 and Duel.IsExistingMatchingCard(s.rlfilter,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.CheckReleaseGroupEx(tp,s.costfilter,1,REASON_COST,true,nil)
	if chk==0 then return b2 or b3 end
	local op=aux.SelectFromOptions(tp,{b2,fe2 and fe2:GetDescription() or nil},{b3,1150})
	if op==1 then
		Duel.Hint(HINT_CARD,0,89490080)
		fe2:UseCountLimit(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,s.rlfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Release(g,REASON_COST)
	else
		local g=Duel.SelectReleaseGroupEx(tp,s.costfilter,1,1,REASON_COST,true,nil)
		Duel.Release(g,REASON_COST)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		e:GetLabelObject():AddCard(tc)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if s[e][2]:GetLabel()~=0 then return end
	local g=s[e][1]:GetLabelObject()
	if #g<=0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)>0 then
			Duel.ReturnToField(tc)
		end
		tc=g:GetNext()
	end
	g:Clear()
end
function s.sumlimit(e,c)
	return e:GetLabelObject():GetLabelObject():IsExists(Card.IsCode,1,nil,c:GetCode())
end
function s.aclimit(e,re,tp)
	return e:GetLabelObject():GetLabelObject():IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode()) and re:IsActiveType(TYPE_MONSTER)
end
