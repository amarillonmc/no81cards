--混调色画板
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE+LOCATION_GRAVE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.setfilter(c)
	return s.cc(c) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SSet(tp,g) end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.check,1,nil,tp)
end
function s.check(c,tp)
	return s.cc(c) and c:IsType(TYPE_MONSTER)
		and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()==tp
end
function s.coverfilter(c)
	return s.cc(c) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:Filter(s.check,nil,tp):GetFirst()
	if not tc then return end
	local g=Duel.GetMatchingGroup(s.coverfilter,tp,LOCATION_GRAVE,0,nil)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),g:GetCount())
	if ct<=0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,s.coverfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	if sg:GetCount()==0 then return end
	Duel.SSet(tp,sg)
	local mg=tc:GetMaterial():Clone()
	mg:Merge(sg)
	tc:SetMaterial(mg)
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetCondition(s.actcon)
		e1:SetValue(1)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end
function s.actcon(e)
	return e:GetLabelObject():IsOnField() and e:GetLabelObject():IsFaceup()
end