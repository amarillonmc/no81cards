--艾奇军团 断罪之影
function c60151125.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60151125.xyzfilter,8,2)
	c:EnableReviveLimit()
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60151125.atkcon)
	e1:SetTarget(c60151125.cointg)
	e1:SetOperation(c60151125.coinop)
	c:RegisterEffect(e1)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151125,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetTarget(c60151125.dreptg)
	e3:SetOperation(c60151125.drepop)
	c:RegisterEffect(e3)
end
c60151125.toss_coin=true
function c60151125.xyzfilter(c)
	return c:IsSetCard(0x9b23)
end
function c60151125.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60151125.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ and e:GetHandler():IsHasEffect(60151199)
end
function c60151125.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsHasEffect(60151199) then
		Duel.SetChainLimit(c60151125.chlimit)
		Duel.RegisterFlagEffect(tp,60151125,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_COIN+CATEGORY_ATKCHANGE)
		Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	end
end
function c60151125.chlimit(e,ep,tp)
	return tp==ep
end
function c60151125.filter2(c)
	return c:IsAbleToGrave()
end
function c60151125.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	if c:IsFacedown() then return end
	local res=0
	if Duel.GetFlagEffect(tp,60151125)>0 then
		res=1
	else res=Duel.TossCoin(tp,1) end
	if res==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(c:GetBaseDefense()*2)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c60151125.imef)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
	if res==1 then
		--disable and destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(60151123,1))
		e1:SetCategory(CATEGORY_DISABLE)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_CHAIN_ACTIVATING)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c60151125.indcon)
		e1:SetOperation(c60151125.disop)
		c:RegisterEffect(e1)
	end
end
function c60151125.imef(e,re,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function c60151125.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end
function c60151125.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	Duel.Hint(HINT_CARD,0,60151125)
	local res=0
	res=Duel.TossCoin(tp,1)
	if res==0 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	if res==1 then
		local rc=re:GetHandler()
		Duel.NegateEffect(ev)
		if not rc:IsImmuneToEffect(e) then
			if rc:IsType(TYPE_XYZ) then 
				local og=rc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(e:GetHandler(),Group.FromCards(rc))
			elseif rc:IsType(TYPE_SPELL+TYPE_TRAP) then 
				rc:CancelToGrave()
				Duel.Overlay(e:GetHandler(),Group.FromCards(rc))
			else 
				return false
			end
		end
	end
end
function c60151125.filter3(c)
	return not c:IsCode(60151125) and c:IsAbleToGrave()
end
function c60151125.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function c60151125.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_NEGATE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_ACTIVATING)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetOperation(c60151125.activate)
			Duel.RegisterEffect(e1,1-tp)
		end
end
function c60151125.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (loc==LOCATION_HAND or loc==LOCATION_GRAVE 
		or loc==LOCATION_DECK or loc==LOCATION_REMOVED 
		or loc==LOCATION_EXTRA or loc==LOCATION_OVERLAY) and not re:GetHandler():IsSetCard(0x9b23) then
			Duel.NegateEffect(ev)
	end
end
function c60151125.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c60151125.drepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,1-tp,60151125)
end