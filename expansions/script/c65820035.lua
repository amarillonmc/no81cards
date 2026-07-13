--源于黑影 波动
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.maintg)
	e1:SetOperation(s.mainop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.mecon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

s.effect_lixiaoguo=true

function s.consume_use_counter(e,tp)
	for i=0,10 do
		Duel.ResetFlagEffect(tp,EFFECT_FLAG_EFFECT+65820000+i)
	end
	local count=math.max(Duel.GetFlagEffect(tp,65820099)-1,0)
	Duel.ResetFlagEffect(tp,65820099)
	for i=1,count do
		Duel.RegisterFlagEffect(tp,65820099,0,0,1)
	end
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,tp)
end

function s.thfilter(c)
	return c.effect_lixiaoguo
end

function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function s.maintg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local has_use=Duel.GetFlagEffect(tp,65820099)>0
	local is_flipped=c:GetFlagEffect(65820010)>0

	if (has_use and not is_flipped) or (not has_use and is_flipped) then
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(1)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
	else
		if chk==0 then
			return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil)
		end
		if has_use then s.consume_use_counter(e,tp) end
		e:SetLabel(2)
	end
end

function s.mainop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		if tc:GetFlagEffect(65820010)==0 then
			tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
		else
			tc:ResetFlagEffect(65820010)
		end
		Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
		if Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(g)
			if #g<=0 then return end
			Duel.BreakEffect()
			local ct=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(s.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ct:RegisterEffect(e1)
		end
	else
		if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		if tc:GetFlagEffect(65820010)==0 then
			tc:RegisterFlagEffect(65820010,0,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65820010,1))
		else
			tc:ResetFlagEffect(65820010)
		end
		Duel.RaiseEvent(tc,EVENT_CUSTOM+65820010,e,REASON_EFFECT,tp,nil,nil)
		if Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,0,nil,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
			local tc2=g:GetFirst()
			while tc2 do
				local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_IMMUNE_EFFECT)
				e4:SetValue(s.efilter)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				e4:SetOwnerPlayer(tp)
				tc2:RegisterEffect(e4)
				tc2=g:GetNext()
			end
		end
	end
end

function s.mecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c) return c:IsSetCard(0x3a32) end,1,nil,tp) and ep==tp
end

function s.filter(c)
	return c:IsAbleToDeck()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,3,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end