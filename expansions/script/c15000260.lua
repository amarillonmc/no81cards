local m=15000260
local cm=_G["c"..m]
cm.name="永寂之王神：赛农"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetTarget(cm.sprtg)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.value)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.descost)
	e4:SetTarget(cm.destg)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)
	--Summon 
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e5:SetOperation(cm.regop)  
	c:RegisterEffect(e5)
end
function cm.sprfilter(c)
	return c:IsFaceup()
end
function cm.fselect(g,tp,sc)
	return aux.gffcheck(g,Card.IsSetCard,0xaf37,Card.IsType,TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and Duel.CheckReleaseGroup(tp,aux.IsInGroup,#g,nil,g)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(cm.fselect,2,2,tp,c)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function cm.count()
	local ovlg=Duel.GetOverlayGroup(0,LOCATION_MZONE,LOCATION_MZONE):Filter(Card.IsType,nil,TYPE_LINK)
	if #ovlg<0 then return 0 end
	return ovlg:GetSum(Card.GetLink)
end
function cm.value(e,c)
	return cm.count()*200
end
function cm.thcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.thcexfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function cm.thcexfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayGroup():FilterCount(Card.IsType,nil,TYPE_LINK)>0
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.thcfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=cm.count()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=cm.count()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)  
	if e:GetHandler():IsSummonLocation(LOCATION_EXTRA) then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
		e1:SetValue(LOCATION_DECKBOT)  
		e:GetHandler():RegisterEffect(e1,true)
	end
end