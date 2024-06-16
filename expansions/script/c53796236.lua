local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_BEASTWARRIOR),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SSET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetLabel(0,0)
		ge1:SetOperation(s.MergedDelayEventCheck1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(s.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_ONFIELD==0 then return end
	if loc&LOCATION_SZONE~=0 and seq>4 then return end
	if loc&LOCATION_MZONE~=0 then seq=aux.MZoneSequence(seq) end
	seq=4-seq
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		Duel.RaiseEvent(Group.CreateGroup(),EVENT_CUSTOM+id,re,r,rp,ep,1<<seq)
		g:Clear()
	else
		local l1,l2=e:GetLabel()
		if rp==0 then l1=l1|1<<seq else l2=l2|1<<seq end
		e:SetLabel(l1,l2)
	end
end
function s.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local l1,l2=e:GetLabelObject():GetLabel()
	local g=Group.CreateGroup()
	if l1>0 then Duel.RaiseEvent(g,EVENT_CUSTOM+id,re,r,0,ep,l1) end
	if l2>0 then Duel.RaiseEvent(g,EVENT_CUSTOM+id,re,r,1,ep,l2) end
	e:GetLabelObject():SetLabel(0,0)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local nums={0x1,0x2,0x4,0x8,0x10}
	local zones=0
	for _,zone in ipairs(nums) do if zone&ev==zone and Duel.CheckLocation(tp,LOCATION_SZONE,math.log(zone,2)) then zones=zones|zone end end
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) and zones>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local nums={0x1,0x2,0x4,0x8,0x10}
	local zones=0
	for _,zone in ipairs(nums) do if zone&ev==zone and Duel.CheckLocation(tp,LOCATION_SZONE,math.log(zone,2)) then zones=zones|zone end end
	if zones==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true,zones) then
		Duel.ConfirmCards(1-tp,tc)
		tc:SetStatus(STATUS_SET_TURN,true)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCondition(s.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function s.actcon(e)
	return e:GetHandler():GetColumnGroup():FilterCount(Card.IsControler,nil,1-e:GetHandlerPlayer())==0
end
