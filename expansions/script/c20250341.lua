--禁钉圣迹戍卫机
function c20250341.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20250341,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,20250341)
	e1:SetCondition(c20250341.addcc)
	e1:SetTarget(c20250341.addct)
	e1:SetOperation(c20250341.addc)
	c:RegisterEffect(e1)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c20250341.hdcon)
	e3:SetTarget(c20250341.hdtg)
	e3:SetOperation(c20250341.hdop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCondition(c20250341.dckcon) 
	e4:SetOperation(c20250341.dckop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(20250341,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SSET)
	e5:SetCode(EVENT_CUSTOM+20250341) 
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,20250342)
	e5:SetCondition(c20250341.descon)
	e5:SetTarget(c20250341.target)
	e5:SetOperation(c20250341.activate)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c20250341.imcon) 
	e6:SetOperation(c20250341.imop)
	c:RegisterEffect(e6)
end

function c20250341.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function c20250341.imop(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():AddCounter(0x154a,2)
end

function c20250341.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function c20250341.adfilter(c)
	return c:IsSetCard(0x54a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c20250341.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20250341.adfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c20250341.addc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c20250341.adfilter),tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20250341.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end

function c20250341.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c20250341.cfilter,1,nil,1-tp)
end

function c20250341.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT) end
end

function c20250341.hdop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(20250339,2)) then
		Duel.RemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT)
	end
end

function c20250341.dckcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetFlagEffect(20250341)
	return x~=e:GetHandler():GetCounter(0x154a)
end 

function c20250341.dckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:ResetFlagEffect(20250341)
		local ct=c:GetCounter(0x154a)
		for i=1,ct do
		c:RegisterFlagEffect(20250341,RESET_EVENT+0x1fe0000,0,1)
	end
		if e:GetHandler():GetCounter(0x154a)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+20250341,e,0,0,tp,0) 
	end
end

function c20250341.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x154a)==0 
end

function c20250341.setfilter(c)
	return c:IsSetCard(0x54a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function c20250341.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20250341.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end

function c20250341.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>=2 then ft=2 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c20250341.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local st=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if st:GetCount()>0 then 
			Duel.SSet(tp,st)
			for tc in aux.Next(st) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(20250341,3))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(20250341,3))
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end