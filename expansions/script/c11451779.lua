--幻梦倾侧之际
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetProperty(0,EFFECT_FLAG2_COF)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_HAND+LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(cm.costcon)
	e5:SetTarget(cm.actarget2)
	e5:SetOperation(cm.costop2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_HAND+LOCATION_SZONE)
	c:RegisterEffect(e6)
	if not CONVIATRESS_BUFF then
		CONVIATRESS_BUFF={}
	end
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return LOCATION_SZONE
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
	end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.actarget2(e,te,tp)
	if not CONVIATRESS_BUFF[te] then e:SetLabelObject(te) end
	return not CONVIATRESS_BUFF[te]
end
function cm.extfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsStatus(STATUS_EFFECT_ENABLED)) and (c:IsHasEffect(11451779) or c:IsHasEffect(11451780) or c:IsHasEffect(11451781) or c:IsHasEffect(11451782)) and c:IsAbleToGraveAsCost()
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if cm[0] or CONVIATRESS_BUFF[te] then return end
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				local extg=Duel.GetMatchingGroup(cm.extfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,nil)
				if #extg>0 and Duel.SelectYesNo(tp,aux.Stringid(11451779,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=extg:Select(tp,1,#extg,nil)
					if #g>0 then
						local lab1=g:IsExists(Card.IsHasEffect,1,nil,11451779)
						local lab2=g:IsExists(Card.IsHasEffect,1,nil,11451780)
						local lab3=g:IsExists(Card.IsHasEffect,1,nil,11451781)
						local lab4=g:IsExists(Card.IsHasEffect,1,nil,11451782)
						if Duel.SendtoGrave(g,REASON_COST)>0 then
							g:ForEach(Card.RegisterFlagEffect,11451779,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451779,3))
							if g:IsContains(e:GetHandler()) then e:GetHandler():CreateEffectRelation(e) end
							if lab1 then
								Duel.Hint(HINT_CARD,0,11451779)
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD)
								e1:SetCode(EFFECT_CANNOT_INACTIVATE)
								e1:SetValue(cm.efilter)
								e1:SetReset(RESET_CHAIN)
								e1:SetLabel(Duel.GetCurrentChain())
								Duel.RegisterEffect(e1,tp)
								local e2=e1:Clone()
								e2:SetCode(EFFECT_CANNOT_DISEFFECT)
								Duel.RegisterEffect(e2,tp)
							end
							if lab2 then
								Duel.Hint(HINT_CARD,0,11451780)
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(EVENT_CHAIN_END)
								e1:SetOperation(cm.limop2)
								Duel.RegisterEffect(e1,tp)
							end
							if lab3 then
								Duel.Hint(HINT_CARD,0,11451781)
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(EVENT_CHAIN_SOLVING)
								e1:SetOperation(cm.ngop)
								e1:SetReset(RESET_CHAIN)
								e1:SetLabel(Duel.GetCurrentChain()+1)
								Duel.RegisterEffect(e1,tp)
							end
							if lab4 then
								Duel.Hint(HINT_CARD,0,11451782)
								local e2=Effect.CreateEffect(c)
								e2:SetType(EFFECT_TYPE_FIELD)
								e2:SetCode(EFFECT_IMMUNE_EFFECT)
								e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
								e2:SetTargetRange(LOCATION_ONFIELD,0)
								e2:SetValue(cm.imfilter)
								e2:SetOwnerPlayer(tp)
								e2:SetReset(RESET_CHAIN)
								Duel.RegisterEffect(e2,tp)
							end
						end
					end
				end
			end
	te:SetTarget(tg2)
	CONVIATRESS_BUFF[te]=true
	cm[0]=true
end
function cm.efilter(e,ct)
	return e:GetLabel()==ct
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(cm.chainlm)
	e:Reset()
end
function cm.ngop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and ev==e:GetLabel() then Duel.NegateEffect(ev) end
end
function cm.imfilter(e,re)
	local i=1
	while type(c11451782[i])=="table" do
		local te,tf,cid,ep=table.unpack(c11451782[i])
		if te==re and ep~=e:GetHandlerPlayer() then return true end
		i=i+1
	end
	return false
end
function cm.filter(c,tp)
	return (c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()) or (c:IsCode(m+1) and c:GetActivateEffect():IsActivatable(tp))
end
function cm.filter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter2(c,tp)
	return c:IsCode(m+1) and c:GetActivateEffect():IsActivatable(tp)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(11451779)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil,tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local th=false
	if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(11451779,0),aux.Stringid(11451779,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then th=true end
			Duel.ConfirmCards(1-tp,g)
		end
	elseif #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			th=Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
	if th and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
	end
end