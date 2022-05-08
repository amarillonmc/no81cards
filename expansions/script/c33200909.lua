--寒霜灵兽 拉普拉斯
function c33200909.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33200909)
	e1:SetCost(c33200909.spcost)
	e1:SetTarget(c33200909.sptg)
	e1:SetOperation(c33200909.spop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200909,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,33210909)
	e2:SetCondition(c33200909.tgcon)
	e2:SetTarget(c33200909.tgtg)
	e2:SetOperation(c33200909.tgop)
	c:RegisterEffect(e2)
	--Recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200909,2))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33200909.reccon)
	e4:SetTarget(c33200909.rectg)
	e4:SetOperation(c33200909.recop)
	c:RegisterEffect(e4) 
end

--e1
function c33200909.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x132a,e:GetHandler():GetLevel(),REASON_COST)
end
function c33200909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33200909.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

--e2
function c33200909.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 
end
function c33200909.tgfilter(c)
	return c:GetCounter(0x132a)>0
end
function c33200909.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c33200909.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c33200909.tgfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then 
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),nil,0,LOCATION_HAND)
	elseif e:GetHandler():IsLocation(LOCATION_MZONE) then 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),nil,0,LOCATION_MZONE)
	end
end
function c33200909.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33200909.tgfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(33200909,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200909,1))
			tc=g:GetNext()
		end
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(g)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c33200909.descon)
		e1:SetOperation(c33200909.desop)
		Duel.RegisterEffect(e1,tp)
		Duel.BreakEffect()
		if e:GetHandler():IsLocation(LOCATION_ONFIELD) then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		elseif e:GetHandler():IsLocation(LOCATION_HAND) and e:GetHandler():IsAbleToExtra() then 
			Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
		end
	end
end
function c33200909.desfilter(c)
	return c:GetFlagEffect(33200909)~=0
end
function c33200909.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c33200909.desfilter,1,nil)
end
function c33200909.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33200909.desfilter,nil)
	Duel.SendtoGrave(tg,REASON_EFFECT)
	g:DeleteGroup()
end

--e4
function c33200909.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33200900)>0
end
function c33200909.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c33200909.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,33200900)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
