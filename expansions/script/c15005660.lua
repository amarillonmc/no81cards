local m=15005660
local cm=_G["c"..m]
cm.name="枯绿授忆者-影王厄剌伯斯凯撒"
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),5,5)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.incon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--add effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.tncon)
	e3:SetOperation(cm.tnop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(cm.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function cm.incon(e)
	local c=e:GetHandler()
	return c:IsType(TYPE_LINK) and c:GetLinkedGroupCount()==0
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:GetCount()>0 and not g:IsExists(cm.mfilter,1,nil) then
		flag=1
	end
	e:GetLabelObject():SetLabel(flag)
	if flag==1 then
		local ct=g:Filter(Card.IsType,nil,TYPE_LINK):GetSum(Card.GetLink)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function cm.mfilter(c)
	return not c:IsExtraLinkState()
end
function cm.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()>0
end
function cm.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,c)
	g1:Merge(g2)
	g1:KeepAlive()
	Duel.SetChainLimit(cm.limit(g1))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.limit(g)
	return  function (e,lp,tp)
				return not g:IsContains(e:GetHandler())
			end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(Duel.GetTargetsRelateToChain(),REASON_EFFECT)
	local dg=Duel.GetOperatedGroup():Filter(Card.IsType,nil,TYPE_LINK)
	if #dg>0 then
		Duel.BreakEffect()
		local ct=dg:GetSum(Card.GetLink)
		Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
	end
end