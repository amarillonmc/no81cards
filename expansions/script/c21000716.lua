--超能力脱离
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target)
	e1:SetOperation(s.prop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.prop2)
	c:RegisterEffect(e2)
end

function s.checkfilter(c)
	return c:IsSetCard(0x615) and c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) then return true end
	return false
end
function s.filter2(c)
	return c:IsSetCard(0x603) and c:IsFaceup()
end
function s.filter0(c,type1)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()  and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,nil,g,1,0,0)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		
		Duel.BreakEffect()

		if Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_REMOVED,0,3,nil) and Duel.IsExistingMatchingCard(s.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g2=Duel.SelectMatchingCard(tp,s.filter0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),type1)
			if g2:GetCount()>0 then
				local cc = g2:GetFirst()
				local fid=cc:GetFieldID()
				cc:RegisterFlagEffect(id,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(id,3))
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e3:SetCode(EVENT_LEAVE_FIELD)
				e3:SetLabel(fid)
				e3:SetLabelObject(cc)
				e3:SetOperation(s.damop)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
				
			end
		end
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return
	end
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(e:GetHandler():GetOwner(),1,REASON_EFFECT)
	tc:ResetFlagEffect(id)
	e:Reset()
end

function s.filter00(c)
	return c:IsSetCard(0x603) and c:IsFaceup() and c:IsAbleToRemove()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x603) and re:GetHandler():IsType(TYPE_MONSTER) and bit.band(r,REASON_EFFECT)>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter00,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,s.filter00,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local rg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local fid=e:GetHandler():GetFieldID()
		for rc in aux.Next(rg) do
			rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		end
		rg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid,Duel.GetTurnCount())
		e1:SetLabelObject(rg)
		e1:SetCondition(s.tdcon)
		e1:SetOperation(s.tdop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end


function s.tdfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,turnc=e:GetLabel()
	local g=e:GetLabelObject()
	if not g:IsExists(s.tdfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local fid,turnc=e:GetLabel()
	local g=e:GetLabelObject()
	local tg=g:Filter(s.tdfilter,nil,fid)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		Duel.ShuffleHand(tp)
	end
end