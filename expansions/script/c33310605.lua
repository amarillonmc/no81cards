--绒武士 太刀柴犬
local cm,m=GetID()
cm.rssetcode="FurryWarrior"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),2,2)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--destory 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32559361,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCost(cm.descost)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tgfilter(c)
	return c and c.rssetcode and c.rssetcode=="FurryWarrior" and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then 
		if e:GetLabel()~=100 then 
			e:SetLabel(0) 
			return false
		end
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and #dg>0 
	end
	e:SetLabel(0)
	local dct=c:RemoveOverlayCard(tp,1,#dg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,dct,tp,LOCATION_ONFIELD)
	e:SetValue(dct)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dct=e:GetValue()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,dct,dct,nil)
	if #dg > 0 then
		Duel.HintSelection(dg)
		if Duel.Destroy(dg,REASON_EFFECT)<=0 or not c:IsRelateToEffect(e) or not c:IsAbleToRemove() or not Duel.SelectYesNo(tp,aux.Stringid(m,2)) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)<=0 or not c:IsLocation(LOCATION_REMOVED) then return end
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e1:SetLabelObject(c)
		e1:SetLabel(fid)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp)
	local c=e:GetLabelObject()
	if c:GetFlagEffectLabel(m)==e:GetLabel() then return true
	else
		e:Reset()
		return false
	end
end
function cm.retop(e,tp)
	local c=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,m)
	Duel.ReturnToField(c)
	e:Reset()
end