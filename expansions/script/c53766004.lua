local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.sumop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.sdcon)
	e3:SetTarget(s.sdtg)
	e3:SetOperation(s.sdop)
	c:RegisterEffect(e3)
	s.self_destroy_effect=e3
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.ctfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetBaseAttack()==0 and c:IsCanAddCounter(0x153f,1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x153f)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x153f,1)
		if tc:GetFlagEffect(53766000)==0 and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
		local ct=Duel.GetCurrentChain()
		if ct<2 then return end
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tep~=tp and te:IsActiveType(TYPE_MONSTER) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCategory(te:GetCategory())
			local t=te:GetType()
			local cd=te:GetCode()
			local pr1,pr2=te:GetProperty()
			pr1=(pr1 | EFFECT_FLAG_NO_TURN_RESET)
			if (t & EFFECT_TYPE_XMATERIAL)~=0 then t=t-EFFECT_TYPE_XMATERIAL end
			if (t & EFFECT_TYPE_QUICK_F)~=0 then t=(t-EFFECT_TYPE_QUICK_F | EFFECT_TYPE_QUICK_O) end
			if (t & EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F)~=0 then
				if (t & EFFECT_TYPE_SINGLE)~=0 then t=EFFECT_TYPE_QUICK_O cd=EVENT_FREE_CHAIN else t=(t-EFFECT_TYPE_TRIGGER_F | EFFECT_TYPE_TRIGGER_O) pr1=(pr1 | EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) end
			end
			if (t & EFFECT_TYPE_IGNITION)~=0 then t=(t-EFFECT_TYPE_IGNITION | EFFECT_TYPE_QUICK_O) cd=EVENT_FREE_CHAIN end
			e1:SetType(t)
			e1:SetCode(cd)
			e1:SetProperty(pr1,pr2)
			if cd==EVENT_FREE_CHAIN then e1:SetHintTiming(0,0x1e0) end
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(te:GetLabel())
			e1:SetLabelObject(te:GetLabelObject())
			e1:SetCountLimit(1)
			local tg=te:GetTarget()
			if tg then e1:SetTarget(tg) end
			local op=te:GetOperation()
			if op then e1:SetOperation(op) end
			e1:SetReset(0x1fe1000)
			c:RegisterEffect(e1,true)
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,2))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end
function s.desfilter(c,p)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetColumnGroupCount()==0 and c:IsControler(p)
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.desfilter,1,nil,tp)
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.filter(c)
	return c:IsSetCard(0x5534) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg then Duel.SendtoGrave(sg,REASON_EFFECT) end
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end
