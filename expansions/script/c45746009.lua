--幻影旅团·9 派克诺妲
local m=45746009
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf1,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tf1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.f3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		local tg=Group.CreateGroup()
		local tc=g:GetFirst()
		while tc do
			if not tc:IsImmuneToEffect(e) and tc:GetFlagEffect(m)==0 then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				tg:AddCard(tc)
			end
			tc=g:GetNext()
		end
		tg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(aux.TargetEqualFunction(Card.GetFlagEffect,1,m))
		e1:SetLabelObject(tg)
		Duel.RegisterEffect(e1,tp)
		--force adjust
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVED)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,tp)
		--reset
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetLabelObject(e2)
		e3:SetLabel(Duel.GetChainInfo(0,CHAININFO_CHAIN_ID))
		e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetLabel() then
				local e2=e:GetLabelObject()
				local e1=e2:GetLabelObject()
				local tg=e1:GetLabelObject()
				for tc in aux.Next(tg) do
					tc:ResetFlagEffect(m)
				end
				tg:DeleteGroup()
				e1:Reset()
				e2:Reset()
				e:Reset()
			end
		end)
		Duel.RegisterEffect(e3,tp)
	end)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return r==REASON_XYZ and c:GetReasonCard():GetOriginalRace()==RACE_PSYCHO 
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local rc=c:GetReasonCard()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND):Filter(Card.IsFacedown,nil)
			if #g>0 then
				Duel.ConfirmCards(tp,g)
			end
		end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		if not rc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2,true)
		end
	end)
	c:RegisterEffect(e2)
end
--e1
function cm.tf1(c)
	return c:IsSetCard(0x5880) and c:IsAbleToHand()
end
--e3
function cm.f3(c)
	return c:GetControler()~=c:GetOwner()
end