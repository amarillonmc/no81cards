local m=15000882
local cm=_G["c"..m]
cm.name="高等恶虺-橙影泣"
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.LinkCondition(aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,99,cm.lcheck))
	e1:SetTarget(cm.LinkTarget(aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,99,cm.lcheck))
	e1:SetOperation(cm.LinkOperation(aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,99,cm.lcheck))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000882)
	e2:SetCost(cm.effcost)
	e2:SetTarget(cm.efftg)
	e2:SetOperation(cm.effop)
	c:RegisterEffect(e2)
	--All Flip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.fliptg)
	e3:SetValue(TYPE_FLIP)
	c:RegisterEffect(e3)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_FLIP)
end
function cm.fdfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_MONSTER)
end
function cm.LConditionFilter(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc)) or cm.fdfilter(c)) and (not f or f(c))
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg)) and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp) and (not lmat or sg:IsContains(lmat)) and not sg:IsExists(cm.fdfilter,2,nil)
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				g1=g:Filter(cm.fdfilter,nil)
				g:Sub(g1)
				Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xf3b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()) then return false end
	local te1=c.FlipEffect_Deobra
	local te2=c.TargetEffect_Deobra
	if (not te1 and not te2) then return false end
	local tg2=te2:GetTarget()
	if Duel.GetCurrentChain()>=1 and te2 and ((not tg2) or (tg2 and tg2(e,tp,eg,ep,ev,re,r,rp,0))) then return true end
	local tg1=te1:GetTarget()
	return (not tg1) or (tg1 and tg1(e,tp,eg,ep,ev,re,r,rp,0))
end
function cm.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.efffilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.efffilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te1=tc.FlipEffect_Deobra
	local te2=tc.TargetEffect_Deobra
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local op=0
	local tg1=te1:GetTarget()
	local tg2=te2:GetTarget()
	local b1=(te1 and (not tg1) or (tg1 and tg1(e,tp,eg,ep,ev,re,r,rp,0)))
	local b2=(te2 and Duel.GetCurrentChain()>=1 and ((not tg2) or (tg2 and tg2(e,tp,eg,ep,ev,re,r,rp,0))))
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	elseif b2 and not b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	else return end
	if op==0 then
		if te1:GetCategory() then e:SetCategory(te1:GetCategory()) end
		e:SetProperty(te1:GetProperty())
		local tg1=te1:GetTarget()
		if tg1 then tg1(e,tp,eg,ep,ev,re,r,rp,1) end
		te1:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te1)
		Duel.ClearOperationInfo(0)
	end
	if op==1 then
		if te2:GetCategory() then e:SetCategory(te2:GetCategory()) end
		e:SetProperty(te2:GetProperty())
		local tg2=te2:GetTarget()
		if tg2 then tg2(e,tp,eg,ep,ev,re,r,rp,1) end
		te2:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te2)
		Duel.ClearOperationInfo(0)
	end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function cm.fliptg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end