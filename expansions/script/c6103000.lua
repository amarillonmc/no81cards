--鸠极魔术使
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,3,3,cm.ovfilter,aux.Stringid(m,0),cm.xyzop)
	--change effect  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.chcon) 
	e1:SetCost(cm.chcost) 
	e1:SetTarget(cm.chtg)  
	e1:SetOperation(cm.chop)  
	c:RegisterEffect(e1)	
	--putonfield  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.intg)
	e3:SetValue(cm.inval)
	c:RegisterEffect(e3)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.cfilter(c)
	return c:IsType(TYPE_XYZ)
end
function cm.cfilter1(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and not c:IsType(TYPE_XYZ)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,m)==0 and Duel.CheckRemoveOverlayCard(tp,1,0,3,REASON_COST) end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.RemoveOverlayCard(tp,1,0,3,3,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end  
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)	
end  
function cm.chfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.chfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
end  
function cm.chop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,g)  
	Duel.ChangeChainOperation(ev,cm.repop)  
end  
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.chfilter,1-tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
	end
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.costfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()   
end  
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.spfilter(c)  
	return c:IsType(TYPE_MONSTER) 
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,3)) 
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CARD_TARGET)
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCondition(cm.ptcon)
			e2:SetTarget(cm.pttg)
			e2:SetOperation(cm.ptop)
			tc:RegisterEffect(e2)
	end
end 
function cm.ptfilter1(c,sc)
	return sc:GetColumnGroup():IsContains(c) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.ptcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ptfilter1,1,nil,e:GetHandler(),e:GetHandler(),eg)
end
function cm.pttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.ptfilter1(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(cm.ptfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler()) and Duel.IsExistingMatchingCard(cm.ptfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.ptfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),e:GetHandler())
	Duel.HintSelection(g)
end
function cm.ptfilter(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.ptop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			local fid=c:GetFieldID()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e1)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e0:SetCode(EFFECT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e0)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(cm.tgcon)
			e3:SetOperation(cm.tgop)
			Duel.RegisterEffect(e3,tp)
	   end
			local pc=Duel.SelectMatchingCard(tp,cm.ptfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.Overlay(pc,Group.FromCards(c))
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function cm.intg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.inval(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end