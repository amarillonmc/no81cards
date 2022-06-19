--全盛之珠玉圣骑领君主 伊万杰琳
local m=40010368
local cm=_G["c"..m]
cm.named_with_JewelPaladin=1
function cm.JewelPaladin(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_JewelPaladin
end
function cm.initial_effect(c)
	--spsummon cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e0:SetOperation(cm.jpop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(cm.descon)
	e2:SetCost(cm.tgcost1)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.hstg)
	e3:SetOperation(cm.hsop)
	c:RegisterEffect(e3)	
end
function cm.jpfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function cm.jpop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.jpfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-1 then return end
	--if Duel.GetFlagEffect(tp,m+2)>0 then return end
	if sg:GetCount()>0 and ft>0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,3,3,nil)
			Duel.Release(g,REASON_COST)
			Duel.BreakEffect()
			Duel.Draw(tp,3,REASON_EFFECT)
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	else
		local g=Duel.SelectReleaseGroup(tp,cm.jpfilter,3,3,nil)
		Duel.Release(g,REASON_COST)
		Duel.BreakEffect()
		Duel.Draw(tp,3,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	--e:GetLabelObject():SetLabel(0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	local rc=e:GetHandler():GetReasonCard()
	if rc then else rc=e:GetHandler():GetReasonEffect():GetHandler() end
	if rc then
		--Debug.Message("1")
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCountLimit(1)
		e1:SetLabelObject(rc)
		e1:SetOperation(cm.op2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=e:GetLabelObject()
	--Debug.Message("2")
	if rc and rc==eg:GetFirst() and rc:GetSequence()==c:GetPreviousSequence() and rc:IsControler(tp) then
		--Debug.Message("3")
		Duel.RaiseEvent(c,EVENT_CUSTOM+m,nil,0,0,tp,0)
	end
	e:Reset()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.costfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function cm.tgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.costfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabel(g:GetCount())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)

end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabel()
	--local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if chk==0 then return #g>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.spfilter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local g=e:GetLabel()
	--local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_SYNCHRO)
	if #g>0 and #dg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sdg=dg:Select(tp,1,g:GetCount(),nil)
		Duel.HintSelection(sdg)
		local sg=Duel.SendtoGrave(sdg,REASON_EFFECT)
		if #sg>0 then
			local cg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				local ct=sg:GetCount()
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local gg=cg:Select(tp,1,ct,nil)
				Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function cm.hsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end






