--盆回し
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function s.gcheck(g,tp)
	if #g==1 then return true end
	if g:GetClassCount(Card.GetCode)==#g then
		local c1,c2=g:GetFirst(),g:GetNext()
		local res=s.placecheck(c1,c2,tp)
		if not res then
			res=s.placecheck(c2,c1,tp)
		end
		return res
	end
	return false
end
function s.placecheck(c1,c2,tp)
	return c1:IsCanPlaceInFieldZone(tp,tp) and c2:IsCanPlaceInFieldZone(tp,1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,tp)
	if chk==0 then return g:CheckSubGroup(s.gcheck,2,2,tp) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local og=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	if #og<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=og:SelectSubGroup(tp,s.gcheck,false,2,2,tp)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73468603,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73468603,1))
	local tg2=g:Select(tp,1,1,nil)
	Duel.SSet(tp,tg1)
	Duel.SSet(tp,tg2,1-tp)
	tg1:GetFirst():RegisterFlagEffect(73468603,RESET_EVENT+RESETS_STANDARD,0,1)
	tg2:GetFirst():RegisterFlagEffect(73468603,RESET_EVENT+RESETS_STANDARD,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(s.con)
	e1:SetValue(s.actlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.con)
	e2:SetTarget(s.setlimit)
	Duel.RegisterEffect(e2,tp)
end
function s.cfilter(c)
	return c:IsFacedown() and c:GetFlagEffect(73468603)~=0
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(73468603)==0
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and c:GetFlagEffect(73468603)==0
end
