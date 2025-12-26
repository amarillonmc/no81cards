--古之钥的序曲 蒸汽交响
function c28381783.initial_effect(c)
	aux.AddFusionProcFunRep2(c,c28381783.ffilter,2,99,true)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	--e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28381783.sprcon)
	e0:SetTarget(c28381783.sprtg)
	e0:SetOperation(c28381783.sprop)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(c28381783.tgcon)
	e1:SetTarget(c28381783.destg)
	e1:SetOperation(c28381783.desop)
	c:RegisterEffect(e1)
	--material check
	local ce1=Effect.CreateEffect(c)
	ce1:SetType(EFFECT_TYPE_SINGLE)
	ce1:SetCode(EFFECT_MATERIAL_CHECK)
	ce1:SetValue(c28381783.valcheck)
	ce1:SetLabelObject(e1)
	c:RegisterEffect(ce1)
end
function c28381783.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLevel(3)
end
function c28381783.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLevel(3) and c:IsAbleToDeckAsCost() and c:IsCanBeFusionMaterial()
end
function c28381783.gcheck(mg,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,mg,fc)>0
end
function c28381783.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c28381783.matfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFlagEffect(tp,28381783)+2
	return mg:CheckSubGroup(c28381783.gcheck,ct,#mg,tp,c) and Duel.GetLP(tp)<=3000
end
function c28381783.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c28381783.matfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFlagEffect(tp,28381783)+2
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,c28381783.gcheck,true,ct,99,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c28381783.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
	Duel.RegisterFlagEffect(tp,28381783,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c28381783.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c28381783.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x285) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function c28381783.thfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToHand() and c:IsFaceupEx() and aux.NecroValleyFilter()(c)
end
function c28381783.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():IsRelateToChain() and e:GetLabel() or 0
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,ct,nil,0x285)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if Duel.GetLP(tp)<=3000 and Duel.IsExistingMatchingCard(c28381783.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28381783,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28381783.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function c28381783.valcheck(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterialCount())
end
