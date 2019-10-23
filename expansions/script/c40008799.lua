--咒眼之魔神 撒拉基尔
function c40008799.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x129),2)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c40008799.regcon)
	e1:SetOperation(c40008799.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c40008799.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c40008799.efilter)
	e3:SetCondition(c40008799.macon)
	c:RegisterEffect(e3)  
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40008799,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,40008799)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	e4:SetCondition(c40008799.descon)
	e4:SetTarget(c40008799.destg)
	e4:SetOperation(c40008799.desop)
	c:RegisterEffect(e4) 
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(40008799,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c40008799.discon)
	e5:SetTarget(c40008799.distg)
	e5:SetOperation(c40008799.disop)
	c:RegisterEffect(e5)
end
function c40008799.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function c40008799.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c40008799.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(40008800,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(40008799,2))
end
function c40008799.macon(e)
	return e:GetHandler():GetFlagEffect(40008800)>0
end
function c40008799.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsAttackAbove,1,nil,3600) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008799.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,44133040)
end
function c40008799.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:GetHandler():RegisterFlagEffect(40008799,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
	else
		e:GetHandler():RegisterFlagEffect(40008799,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,1,0)
	end
end
function c40008799.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function c40008799.discon(e,tp,eg,ep,ev,re,r,rp)
	local tid=e:GetHandler():GetFlagEffectLabel(40008799)
	return tid and tid~=Duel.GetTurnCount()
end
function c40008799.disfilter(c,g)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT) and g:IsContains(c)
end
function c40008799.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c40008799.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c40008799.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,cg)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end