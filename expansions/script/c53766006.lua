local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_MUST_ATTACK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e4:SetValue(s.atklimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.avfilter)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetRange(LOCATION_PZONE)
	e7:SetValue(s.immval)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,1))
	e8:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_CUSTOM+id)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e8:SetTarget(s.sdtg)
	e8:SetOperation(s.sdop)
	c:RegisterEffect(e8)
	s.self_destroy_effect=e8
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(s.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=true
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	s.chain_solving=false
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.rmfilter(c,code)
	return c:IsCode(code) and c:IsFacedown() and c:IsAbleToRemove()
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local g=Duel.SelectMatchingCard(1-tp,s.rmfilter,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,nil,ac)
		if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
	end
end
function s.atkfilter(c)
	return c:IsSetCard(0x5534) and c:IsFaceup()
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.atklimit(e,c)
	return c:IsSetCard(0x5534) and c:IsFaceup()
end
function s.avfilter(e,c)
	local at=Duel.GetAttacker()
	return c:IsSetCard(0x5534) and c:IsFaceup() and at and at~=c
end
function s.immval(e,te)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_PZONE) or not te:IsActivated() or not s.chain_solving or te:GetOwner()==c then return false end
	local tp=c:GetControler()
	local tc=te:GetHandler()
	local eset={c:IsHasEffect(id)}
	local ctns=true
	for _,se in pairs(eset) do if se:GetLabel()==tc:GetCode() then ctns=false end end
	if ctns then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(id)
		e1:SetLabel(tc:GetCode())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetLabelObject(te)
		e2:SetReset(RESET_CHAIN)
		e2:SetOperation(s.imcop)
		Duel.RegisterEffect(e2,tp)
		if te:GetOwnerPlayer()~=tp then return true end
	end
	return false
end
function s.imcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.efilter)
	e1:SetLabel(e:GetLabelObject():GetHandler():GetCode())
	c:RegisterEffect(e1)
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+id,e:GetLabelObject(),REASON_EFFECT,tp,tp,0)
	e:Reset()
end
function s.efilter(e,te)
	return te:GetHandler():IsCode(e:GetLabel()) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsLocation(LOCATION_PZONE) then return false end
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		if #og>0 then
			local sg=og:Filter(Card.IsSetCard,nil,0x5534)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=sg:Select(tp,1,1,nil)
				Duel.ConfirmCards(1-tp,g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			else Duel.SendtoDeck(og,nil,2,REASON_EFFECT) end
		end
	end
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end
