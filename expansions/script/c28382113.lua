--古之钥的主歌 深渊冲突
function c28382113.initial_effect(c)
	aux.AddFusionProcFunRep2(c,c28382113.ffilter,2,99,true)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	--e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28382113.sprcon)
	e0:SetTarget(c28382113.sprtg)
	e0:SetOperation(c28382113.sprop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c28382113.descon)
	e1:SetTarget(c28382113.destg)
	e1:SetOperation(c28382113.desop)
	c:RegisterEffect(e1)
	--material check
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c28382113.valcheck)
	ce1:SetLabelObject(e1)
	c:RegisterEffect(ce1)
end
function c28382113.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLevel(3)
end
function c28382113.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLevel(3) and c:IsReleasable(REASON_SPSUMMON) and c:IsCanBeFusionMaterial()
end
function c28382113.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0
end
function c28382113.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c28382113.matfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFlagEffect(tp,28382113)+2
	return mg:CheckSubGroup(c28382113.gcheck,ct,#mg,tp,c) and Duel.GetLP(tp)<=3000
end
function c28382113.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c28382113.matfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFlagEffect(tp,28382113)+2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c28382113.gcheck,true,ct,99,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c28382113.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.Release(mg,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,28382113,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c28382113.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c28382113.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetMaterialCount()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 and #g>0 end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28382113,1))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28382113.gcheck(sg,tp)
	return sg:IsExists(Card.IsControler,1,nil,tp)
end
function c28382113.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():IsRelateToChain() and e:GetHandler():GetMaterialCount() or 0
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:SelectSubGroup(tp,c28382113.gcheck,false,1,ct,tp)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
	if Duel.GetLP(tp)<=3000 and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(28382113,0)) then
		Duel.NegateEffect(ev)
	end
end
function c28382113.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterialCount())
end
