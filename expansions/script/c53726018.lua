local m=53726018
local cm=_G["c"..m]
cm.name="特别高等人 法月将臣"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,cm.mfilter,2,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_LINK))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.target)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.mfilter(c)
	return c:IsLinkState() and c:IsType(TYPE_DUAL)
end
function cm.target(e,c)
	local lg1=c:GetLinkedGroup()
	local lg2=e:GetHandler():GetLinkedGroup()
	return c:IsFaceup() and c:IsType(TYPE_LINK) and (lg1 and lg1:IsContains(e:GetHandler()) or lg2 and lg2:IsContains(c))
end
function cm.atkval(e,c)
	return e:GetHandler():GetOverlayCount()*900
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	local b1=e:GetHandler():GetOverlayCount()>0 and re:GetHandler():IsDestructable()
	local b2=e:GetHandler():IsAbleToRemove() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local op=3
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	elseif op==1 then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
	if c:IsRelateToEffect(e) and c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) and re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
	elseif e:GetLabel()==1 then
	if not c:IsRelateToEffect(e) then return end
	local lg=Duel.GetMatchingGroup(cm.lfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and sc:IsLocation(LOCATION_MZONE) and sc:IsFaceup() and #lg>0 then
			local sg=lg:Select(tp,1,1,nil)
			local g=Group.__add(sc,sg)
			Duel.HintSelection(g)
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
				e1:SetValue(aux.imval1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetValue(aux.tgoval)
				tc:RegisterEffect(e2)
			end
		end
	end
	end
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.lfilter(c,tc)
	local lg1=c:GetLinkedGroup()
	local lg2=tc:GetLinkedGroup()
	return c:IsFaceup() and (lg1 and lg1:IsContains(tc) or lg2 and lg2:IsContains(c))
end
