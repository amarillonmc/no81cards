--他力本愿
local cm,m=GetID()
function cm.initial_effect(c)
	--cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_DECK)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(cm.costcon)
	e5:SetTarget(cm.actarget2)
	e5:SetOperation(cm.costop2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_DECK)
	c:RegisterEffect(e6)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
	--check add count
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_DECK) and tc:IsLocation(LOCATION_HAND) then
			local p=tc:GetControler()
			if p==0 or p==1 then cm[p]=cm[p]+1 end
		end
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.costcon(e)
	cm[3]=false
	return true
end
function cm.actarget2(e,te,tp)
	if not cm[te] then e:SetLabelObject(te) end
	return not cm[te]
end
function cm.extfilter(c)
	return c:IsHasEffect(m) and c:IsAbleToGraveAsCost()
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if cm[3] or cm[te] then return end
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				local extg=Duel.GetMatchingGroup(cm.extfilter,tp,LOCATION_DECK,0,nil)
				if #extg>0 and cm[tp]<cm[1-tp] and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=extg:Select(tp,1,1,nil)
					if #g>0 then Duel.SendtoGrave(g,REASON_COST) end
				end
			end
	te:SetTarget(tg2)
	cm[te]=true
	cm[3]=true
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.flcon)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	if not Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
		e1:SetLabel(1)
	end
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(0x20000000+m+1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e2)
end
function cm.flcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m+1)~=0
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and e:GetLabel()==1 then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,rp,LOCATION_DECK,0,nil)
	if #g>0 then--and Duel.SelectYesNo(rp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,rp,HINTMSG_ATOHAND)
		local tc=g:Select(rp,0,1,nil):GetFirst()
		if not tc then return end
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-rp,tc)
			--Duel.HintSelection(Group.FromCards(tc))
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVED)
			e2:SetCountLimit(1)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetLabelObject(tc)
			e2:SetCondition(cm.descon)
			e2:SetOperation(cm.desop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end