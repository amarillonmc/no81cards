--瘟疫的容器 空洞骑士
local m=115002
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,15000351)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,15000351,cm.ffilter0,1,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_MZONE)
	e3:SetValue(15000351)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1000)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.target2)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
	if not KDlobal then
		KDlobal={}
		KDlobal["Effects"]={}
	end
	KDlobal["Effects"]["c115002"]={}
end
function cm.ffilter0(c)
	return c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable() and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.drcfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
end
----
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.drcfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,15000351) and c:IsAbleToRemove() and c:GetOriginalCode()~=115002  and KDlobal["Effects"]["c"..c:GetOriginalCode()] and (KDlobal["Effects"]["c"..c:GetOriginalCode()]:GetTarget())(e,tp,eg,ep,ev,re,r,rp,0,nil)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(cm.drcfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.drcfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local tc=g:GetFirst()
	while tc do
	local te=KDlobal["Effects"]["c"..tc:GetOriginalCode()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	tc=g:GetNext()
	end
end