--Un-Fair Play
function c33741110.initial_effect(c)
	c:EnableCounterPermit(0x467)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33741110,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33741110.pbtg)
	e1:SetOperation(c33741110.pbop)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c33741110.cfcon)
	e2:SetOperation(c33741110.cfop)
	c:RegisterEffect(e2)
	--change effect type
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(33741110)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c33741110.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c33741110.damop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--
	if not c33741110.global_check then
		c33741110.global_check=true
		local _TossDice=Duel.TossDice
		function Duel.TossDice(p,ct1,ct2)
			local tp=1-p
			local ct=ct2 and ct1+ct2 or ct1
			local res=false
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_SZONE,0,nil,33741110)
			for tc in aux.Next(g) do
				if ct1>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(33741110,0)) then
					res=true
					Duel.HintSelection(Group.FromCards(tc))
					Duel.Hint(HINT_CARD,0,33741110)
					tc:AddCounter(0x467,1)
					break
				end
			end
			if res then return _TossDice(tp,ct) else
			return _TossDice(p,ct1,ct2)
		end
		local _TossCoin=Duel.TossCoin
		function Duel.TossCoin(p,ct)
			local tp=1-p
			local res=false
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_SZONE,0,nil,33741110)
			for tc in aux.Next(g) do
				if Duel.SelectEffectYesNo(tp,tc,aux.Stringid(33741110,0)) then
					res=true
					Duel.HintSelection(Group.FromCards(tc))
					Duel.Hint(HINT_CARD,0,33741110)
					tc:AddCounter(0x467,1)
					break
				end
			end
			if res then return _TossCoin(tp,ct) else
			return _TossCoin(p,ct)
		end
	end
end
function c33741110.pbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c33741110.pbop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			local ct=Duel.GetTurnPlayer()==tp and 1 or 2
			local e1=Effect.CreateEffect(e:GetHandler())	
			e1:SetDescription(aux.Stringid(33741110,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,ct)
			tc:RegisterEffect(e1)
		end
		Duel.ShuffleHand(1-tp)
	end
	e:GetHandler():AddCounter(0x467,1)
end
function c33741110.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_SEARCH)) and rp~=tp
end
function c33741110.cfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<3 or not Duel.SelectYesNo(tp,aux.Stringid(33741110,0)) then return end
	Duel.SortDecktop(tp,1-tp,3)
	e:GetHandler():AddCounter(0x467,1)
end
function c33741110.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x467)
	if ct>4 then ct=ct*2 end
	e:SetLabel(ct)
end
function c33741110.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct>0 then
		Duel.Damage(tp,ct*1000,REASON_EFFECT)
	end
end
