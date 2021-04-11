--替身使者-大柳贤
function c9300420.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,3,c9300420.ovfilter,aux.Stringid(9300420,1),c9300420.xyzop)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
   --RockPaperScissors
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9300420,0))
	e2:SetCategory(CATEGORY_COUNTER+EFFECT_TYPE_SINGLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9300420)
	e2:SetTarget(c9300420.cttg)
	e2:SetOperation(c9300420.mtop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9300420,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9301420)
	e3:SetCondition(c9300420.imcon)
	e3:SetTarget(c9300420.thtg)
	e3:SetOperation(c9300420.copyop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c9300420.efilter)
	c:RegisterEffect(e4)
	--copy2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9300420,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e5:SetCountLimit(1,9302420)
	e5:SetCost(c9300420.copycost)
	e5:SetTarget(c9300420.copytg)
	e5:SetOperation(c9300420.copyop2)
	c:RegisterEffect(e5)
	--des
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE+LOCATION_PZONE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c9300420.descon)
	e6:SetTarget(c9300420.destg)
	e6:SetOperation(c9300420.desop)
	c:RegisterEffect(e6)
end
c9300420.pendulum_level=2
function c9300420.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf99) and not c:IsCode(9300420)
end
function c9300420.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1f93,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1f93,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1f93,1)
end
function c9300420.filter3(c)
	return c:IsFaceup() and c:GetCounter(0x1f93)>0
end
function c9300420.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsCanAddCounter(0x1f93,1) and c:IsRelateToEffect(e) and c:IsCanAddCounter(0x1f93,1) then
		local res=Duel.RockPaperScissors()
		if res==tp then
		tc:AddCounter(0x1f93,1)
			if tc:GetCounter(0x1f93)==3 and tc:IsCanBeXyzMaterial(c) then
				Duel.Overlay(c,tc) end
		else
		c:AddCounter(0x1f93,1)
			if c:GetCounter(0x1f93)==3 and c:IsCanRemoveCounter(tp,0x1f93,1,REASON_EFFECT) then
			local g=Duel.GetMatchingGroup(c9300420.filter3,tp,0,LOCATION_ONFIELD,nil)
			local ac=c:GetCounter(0x1f93)
			c:RemoveCounter(tp,0x1f93,ac,REASON_EFFECT)
			local tc=g:GetFirst()
				while tc do
				local cc=tc:GetCounter(0x1f93)
				tc:RemoveCounter(tp,0x1f93,cc,REASON_EFFECT)
				tc=g:GetNext()
				end
				if c:IsRelateToEffect(e) then
				local og=c:GetOverlayGroup()
					if og:GetCount()==0 then return end
					Duel.SendtoDeck(og,nil,2,REASON_EFFECT)
				end
			end
		end
	end
end
function c9300420.matfil(c,e)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsType(TYPE_MONSTER)
end
function c9300420.imcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c9300420.matfil,1,nil,e)
end
function c9300420.filter2(c,e)
	return c:IsType(TYPE_EFFECT) and c:IsLocation(LOCATION_OVERLAY)
end
function c9300420.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 end
	local g=og:FilterSelect(tp,c9300420.filter2,1,1,nil,e)
	Duel.SetTargetCard(g)
end
function c9300420.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function c9300420.efilter(e,te)
	return te:GetOwner():GetCounter(0x1f93)>0 and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c9300420.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9300420)==0 end
	e:GetHandler():RegisterFlagEffect(9300420,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9300420.copyfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1f93)~=0 and c:IsType(TYPE_EFFECT)
end
function c9300420.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c9300420.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9300420.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9300420.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9300420.copyop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) then
		local code=tc:GetOriginalCodeRule()
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(9300420,3))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c9300420.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c9300420.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9300420.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9300420.filter4(c)
	return c:GetCounter(0x1f93)>0
end
function c9300420.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c9300420.filter4,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9300420.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9300420.filter4,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end