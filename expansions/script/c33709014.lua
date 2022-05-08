--『学识』的绿
local m=33709014
local cm=_G["c"..m]
Duel.LoadScript("c16199990.lua")
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e0:SetCost(cm.cost)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.tgdo)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	es:SetCode(EVENT_REMOVE)
	es:SetRange(LOCATION_GRAVE)
	es:SetCondition(cm.kemuricon)
	es:SetOperation(cm.kemuriop)
	c:RegisterEffect(es)
	if not aux.kemuricheck then
		aux.kemuricheck=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
		e1:SetTarget(cm.tg)
		e1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.tg(e,c)
	local code=c:GetOriginalCode()
	return code>=33709010 and code<=33709015 and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or not (c:IsDisabled() and c:IsLocation(LOCATION_ONFIELD)))
end
function cm.check(c)
	local code=c:GetOriginalCode()
	return code>=m and code<=33709016 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.check2(c)
	local code=c:GetOriginalCode()
	return code>=m and code<=33709016 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.kemuricon(e,tp,eg)
	return eg:IsExists(cm.check,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.kemuriop(e,tp,eg)
	local sg=eg:Filter(cm.check2,nil)
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	end
end
function cm.check3(c)
	local code=c:GetOriginalCode()
	return code>=33709004 and code<=33709009 and c:IsDiscardable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then Duel.IsExistingMatchingCard(cm.check3,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.check3,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=eg:Filter(cm.cfilter,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=eg:Filter(cm.cfilter,1,nil,tp)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function cm.tgdo(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=re:GetHandler()
	Duel.Destroy(sg,REASON_EFFECT)
end