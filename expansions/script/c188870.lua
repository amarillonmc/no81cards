local m=188870
local cm=_G["c"..m]
cm.name="神意之枯骸-米蕾"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(c,fc,sub,mg,sg)return not sg or not sg:IsExists(Card.IsLevel,1,c,c:GetLevel())end,3,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.rttg)
	e3:SetOperation(cm.rtop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.negcon)
	e4:SetOperation(cm.negop)
	c:RegisterEffect(e4)
end
function cm.mzfilter(c,fc)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:GetLevel()>0 and c:IsSetCard(0xcac) and c:IsCanBeFusionMaterial(fc,SUMMON_TYPE_SPECIAL)
end
function cm.gcheck(g,tp,fc)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:GetSum(Card.GetLevel)%2~=0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil,c)
	return cm.CheckGroup(g,cm.gcheck,nil,2,2,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.mzfilter,tp,LOCATION_MZONE,0,nil,c)
	local g=cm.SelectGroup(tp,HINTMSG_TOGRAVE,mg,cm.gcheck,nil,1,3,tp,c)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0xcac) and c:IsFaceup()
end
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=math.abs(c:GetLevel()-c:GetOriginalLevel())
	if chk==0 then return ct~=0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.abs(c:GetLevel()-c:GetOriginalLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_REMOVED,0,ct,ct,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local og=Duel.GetOperatedGroup()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(c:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsFaceup() and c:GetLevel()>0 end,tp,LOCATION_MZONE,0,nil)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev) and e:GetHandler():IsAbleToExtra() and g and g:GetSum(Card.GetLevel)%2~=0 and Duel.GetMatchingGroupCount(function(c)return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsSetCard(0xcac)end,tp,LOCATION_ONFIELD,0,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateEffect(ev) then
		Duel.BreakEffect()
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function cm.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function cm.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return cm.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
