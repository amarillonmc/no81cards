--E爆破！
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter(c,tp,ac)
	local cg=c:GetColumnGroup()
	local dg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ac,cg,tp)
	return c:IsFaceup() and c:IsSetCard(0x18b) and #dg>0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.desfilter(c,g)
	return g:IsContains(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ac=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.mfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,tp,ac) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,ac)
	local cg=g:GetFirst():GetColumnGroup()
	local dg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ac,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,0,0)
end
function cm.checkfilter(c)
	return c:IsCode(37617348) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=aux.ExceptThisCard(e)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local cg=tc:GetColumnGroup()
		local dg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ac,cg)
		if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) then
			local g=Duel.GetOperatedGroup():Filter(Card.IsPreviousControler,nil,1-tp)
			Duel.BreakEffect()
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				e1:SetTarget(cm.distg)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(cm.discon)
				e2:SetOperation(cm.disop)
				e2:SetLabelObject(tc)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e3:SetTarget(cm.distg)
				e3:SetLabelObject(tc)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end