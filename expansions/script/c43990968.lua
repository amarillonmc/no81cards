--胜利女神
function c43990968.initial_effect(c)
	aux.AddCodeList(c,43990987)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,4)
	c:EnableReviveLimit()
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetDescription(aux.Stringid(43990968,0))
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	se0:SetCountLimit(1,43990968+EFFECT_COUNT_CODE_OATH)
	se0:SetCondition(c43990968.sprcon)
	se0:SetTarget(c43990968.sprtg)
	se0:SetOperation(c43990968.sprop)
	c:RegisterEffect(se0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990968,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c43990968.tdtg)
	e1:SetOperation(c43990968.tdop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c43990968.efilter)
	c:RegisterEffect(e2)
	--attack up-other
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_EXTRA))--FilterBoolFunction
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--pierce
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e5)
end
function c43990968.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0 and aux.gfcheck(mg,Card.IsCode,43990970,43990987)
end
function c43990968.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil,REASON_SPSUMMON)
	return mg:CheckSubGroup(c43990968.gcheck,2,2,tp,c)
end
function c43990968.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_MZONE,0,nil,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c43990968.gcheck,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c43990968.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.Release(mg,REASON_SPSUMMON)
	mg:DeleteGroup()
end
function c43990968.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c43990968.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c43990968.efilter(e,c,rp,r,re)
	local tp=e:GetHandlerPlayer()
	return c:IsLocation(LOCATION_MZONE) and c:IsSummonLocation(LOCATION_EXTRA)
end
