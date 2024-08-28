--古之钥的主歌 深渊冲突
function c28382113.initial_effect(c)
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x285),2,99,true)
	c:EnableReviveLimit()
   --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(c28382113.hspcon)
	e0:SetOperation(c28382113.hspop)
	c:RegisterEffect(e0)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28382113.tdcon)
	e1:SetTarget(c28382113.tdtg)
	e1:SetOperation(c28382113.tdop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c28382113.dscon)
	e2:SetTarget(c28382113.dstg)
	e2:SetOperation(c28382113.dsop)
	c:RegisterEffect(e2)
	--L'Antica SetCode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(0x283)
	c:RegisterEffect(e3)
	--L'Antica Race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetValue(RACE_FIEND)
	c:RegisterEffect(e4)
end
function c28382113.matfilter(c)
	return c:IsReleasable(REASON_SPSUMMON) and c:IsFusionSetCard(0x285) and c:IsCanBeFusionMaterial()
end
function c28382113.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c28382113.matfilter,c:GetOwner(),LOCATION_MZONE,0,nil)
	return mg:GetCount()>=2 and Duel.GetLP(c:GetOwner())<=3000
end
function c28382113.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.SelectMatchingCard(tp,c28382113.matfilter,tp,LOCATION_MZONE,0,2,99,nil)
	c:SetMaterial(mg)
	Duel.Release(mg,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c28382113.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c28382113.tdfilter(c)
	return c:IsSetCard(0x285) and c:IsAbleToDeck()  and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c28382113.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c28382113.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	if Duel.GetLP(tp)<=3000 then
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else e:SetProperty(EFFECT_FLAG_DELAY) end
end
function c28382113.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetMaterialCount()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(300*ct)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28382113.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c28382113.dscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c28382113.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
end
function c28382113.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28382113.ctfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28382113.dsop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c28382113.ctfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
	if Duel.GetLP(tp)<=3000 and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(tp,aux.Stringid(28382113,0)) then
		Duel.NegateActivation(ev)
	end
end
