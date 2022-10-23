--机 神 休 眠
local m=22348039
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348039,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348039,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,22348039)
	e2:SetTarget(c22348039.destg)
	e2:SetOperation(c22348039.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22348039.descon)
	c:RegisterEffect(e3)
	--send replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetTarget(c22348039.reptg)
	e5:SetValue(c22348039.repval)
	c:RegisterEffect(e5)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e5:SetLabelObject(g)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(c22348039.descon)
	c:RegisterEffect(e6)
end
function c22348039.descon(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function c22348039.spfilter(c,e,tp)
	return c:IsSetCard(0x700) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348039.filter(c)
	return c:IsSetCard(0x700) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c22348039.filter2(c)
	return c:IsSetCard(0x700) and c:IsFaceup()
end

function c22348039.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.IsExistingMatchingCard(c22348039.filter2,tp,LOCATION_MZONE,0,1,nil)) and Duel.IsExistingMatchingCard(c22348039.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348039.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22348039.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	local g1=Duel.SelectMatchingCard(tp,c22348039.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348039.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end end
	else
	local g1=Duel.SelectMatchingCard(tp,c22348039.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348039.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	end
	end
end
function c22348039.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_DESTROY)
		and c:GetOwner()==tp and c:IsSetCard(0x700) and c:IsType(TYPE_MONSTER)
end
function c22348039.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c22348039.repfilter,e:GetHandler(),tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=count
	end
	if Duel.SelectYesNo(tp,aux.Stringid(22348039,2)) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(c22348039.repfilter,e:GetHandler(),tp)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		container:Merge(g)
		return true
	end
	return false
end
function c22348039.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
