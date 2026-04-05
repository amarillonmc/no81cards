--片桐动令 - 悬赏令
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(s.target)
	e0:SetOperation(s.prop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.prop2)
	c:RegisterEffect(e1)
end

function s.spfilter(c,e,tp)
	return c:IsCode(21000763) and c:IsAbleToRemove()
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x606) and c:IsAbleToRemove() and c:IsType(TYPE_EQUIP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a = false
	local ct=Duel.GetCurrentChain()
	if ct>=2 then 
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	
	local b = a and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE)
	if b then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		
		Duel.BreakEffect()
		
		local ct=Duel.GetCurrentChain()
		local a = false
		if ct>=2 then 
			local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		end
		if a and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g0=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g0:GetCount()>0 then
				Duel.Remove(g0,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end

function s.filter0(c,type1)
	return c:IsFaceup()
end
function s.filter02(c,type1)
	return c:IsCode(id) and c:IsSSetable()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()  and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,nil,g,1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,5))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetCondition(s.damcon)
		e3:SetOperation(s.damop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		
		Duel.BreakEffect()

		local ct=Duel.GetCurrentChain()
		local a = false
		if ct>=2 then 
			local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		end
		if a and Duel.GetLocationCount(tp,LOCATION_SZONE)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter02),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g0=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter02),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g0:GetCount()>0 and Duel.SSet(tp,g0)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				g0:GetFirst():RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				g0:GetFirst():RegisterEffect(e2)
			end
		end
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x606)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return
	end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(e:GetHandler():GetOwner(),2,REASON_EFFECT)
	tc:ResetFlagEffect(id)
	e:Reset()
end