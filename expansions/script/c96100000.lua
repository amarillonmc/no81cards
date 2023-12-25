--傲慢源码·露茜法
function c96100000.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,nil,nil,99)
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(96100000,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,96100000)
	e1:SetCondition(c96100000.chcon)
	e1:SetTarget(c96100000.chtg)
	e1:SetOperation(c96100000.chop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96100000,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,96200000)
	e2:SetCondition(c96100000.macon)
	e2:SetTarget(c96100000.matg)
	e2:SetOperation(c96100000.maop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(96100000,3))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,96300000)
	e3:SetCondition(c96100000.relcon)
	e3:SetTarget(c96100000.reltg)
	e3:SetOperation(c96100000.relop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(96100000,4))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,96400000)
	e4:SetCondition(c96100000.reccon)
	e4:SetTarget(c96100000.rectg)
	e4:SetOperation(c96100000.recop)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	e5:SetCondition(c96100000.effcon)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c96100000.efilter)
	e6:SetCondition(c96100000.effcon)
	e6:SetLabel(7)
	c:RegisterEffect(e6)
end
function c96100000.syfilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_SYNCHRO)
end
function c96100000.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetOverlayGroup():FilterCount(c96100000.syfilter,nil)~=0
end
function c96100000.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,rp,LOCATION_EXTRA,0,1,nil,REASON_EFFECT) end
end
function c96100000.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c96100000.repop)
end
function c96100000.repop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c96100000.exfilter(c,tp)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function c96100000.fufilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_FUSION)
end
function c96100000.macon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c96100000.exfilter,1,nil,tp) and e:GetHandler():GetOverlayGroup():FilterCount(c96100000.fufilter,nil)~=0
end
function c96100000.tgfilter(c,eg)
	return c:IsCanOverlay() and eg:IsContains(c)
end
function c96100000.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c96100000.tgfilter(chkc,eg) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c96100000.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c96100000.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),eg)
end
function c96100000.matfilter(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c96100000.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		if tc:IsSetCard(0x745) and Duel.SelectYesNo(tp,aux.Stringid(96100000,2)) then
			Duel.BreakEffect()
			local tg=Duel.GetMatchingGroup(c96100000.matfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e),e)
			if tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local sg=tg:Select(tp,1,1,nil):GetFirst()
				Duel.Overlay(c,Group.FromCards(sg))
			end
		end
	end
end
function c96100000.rifilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_RITUAL)
end
function c96100000.relcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():FilterCount(c96100000.rifilter,nil)~=0
end
function c96100000.reltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,1-tp,LOCATION_MZONE,0,1,nil,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,1-tp,LOCATION_MZONE)
end
function c96100000.relop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,1-tp,LOCATION_MZONE,0,nil,REASON_RULE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Release(sg,REASON_RULE)
	end
end
function c96100000.dufilter(c)
	return c:IsSetCard(0x745) and c:IsType(TYPE_DUAL)
end
function c96100000.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():FilterCount(c96100000.dufilter,nil)~=0
end
function c96100000.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount() end
	local ct=e:GetHandler():GetOverlayCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c96100000.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetHandler():GetOverlayCount()
	if ct>0 then
		Duel.Recover(p,ct*500,REASON_EFFECT)
	end
end
function c96100000.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c96100000.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
