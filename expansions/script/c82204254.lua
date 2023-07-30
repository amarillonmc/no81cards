local m=82204254
local cm=_G["c"..m]
cm.name="小红帽「女骑士」"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	--atkup  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(cm.val)  
	c:RegisterEffect(e1)  
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_RedHat=true 
function cm.isRedHat(c)
	local code=c:GetCode()
	local ccode=_G["c"..code]
	return ccode.SetCard_01_RedHat
end
function cm.matfilter(c)
	return cm.isRedHat(c) and (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)))
end 

function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function cm.val(e,c)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*500  
end  
function cm.atkfilter(c)  
	return c:IsFaceup() and cm.isRedHat(c)
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	if chkc then return false end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,c)  
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,c)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,c)  
	g1:Merge(g2)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)  
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()>0 then 
		Duel.Destroy(tg,REASON_EFFECT)  
	end  
end   