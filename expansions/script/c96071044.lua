--式神·沧海一粟 御饌津
local m=96071044
local set=0xff7
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(Card.IsSetCard,0xff7),1,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.damcon)
	e5:SetOperation(cm.damop)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,6))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetCondition(cm.regcon)
		ge2:SetOperation(cm.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
end
	--synchro summon
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_PENDULUM) and c:IsSetCard(0xff7))
end
	--spsummon
function cm.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.spcfilter,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thfilter1(c,tp,id)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(m)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(cm.thfilter1,tp,0x70,0x70,nil,tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,7))
			local cg=g:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode())
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
	--act limit
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
   if e:GetLabel()==0 then
	e:GetHandler():RegisterFlagEffect(333331,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	elseif e:GetLabel()==1 then
	e:GetHandler():RegisterFlagEffect(333332,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	else e:GetHandler():RegisterFlagEffect(333333,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0) end
	if e:GetHandler():GetFlagEffect(333331)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
	end
	if e:GetHandler():GetFlagEffect(333332)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
	end
	if e:GetHandler():GetFlagEffect(333333)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,0)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
	end
end
	--negate
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(333331)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
	elseif c:GetFlagEffect(333332)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL)
	elseif c:GetFlagEffect(333333)>0 then
	return rp~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_TRAP)
	end
end 
function cm.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.disfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
	--damage
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(m)~=0
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
	--pendulum
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end