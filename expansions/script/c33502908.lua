--DIVA
local m=33502908
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33502900)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e0:SetValue(33502900)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(cm.filter))
	e1:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return aux.IsCodeListed(c,33502900) 
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,nil,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #cg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=cg:Select(tp,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local sg=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #sg<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local zg=sg:Select(tp,1,1,nil)
		if Duel.SSet(tp,zg)~=0 then
			Duel.ConfirmCards(1-tp,zg)
		end
	end
end
function cm.thfilter1(c)
	return c:IsType(TYPE_TRAP) and aux.IsCodeListed(c,33502900) and c:IsSSetable()
end