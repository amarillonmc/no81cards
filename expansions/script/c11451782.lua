--幽狱踏破之际
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetProperty(0,EFFECT_FLAG2_COF)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.condition)
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
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.condition2)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.activate)
	c:RegisterEffect(e4)
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
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetHandler():IsRelateToEffect(re)
	local cid=re:GetHandler():GetRealFieldID()
	cm[ev]={re,tf,cid,ep}
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false,0,ep}
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i] do
		cm[i]=nil
		i=i+1
	end
end
function cm.costcon(e)
	cm[0]=false
	return true
end
function cm.actarget2(e,te,tp)
	if not cm[te] then e:SetLabelObject(te) end
	return not cm[te]
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] or cm[te] then return end
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tg=te:GetTarget() or aux.TRUE
	local tg2=function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,1) end
				if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
				local exc=nil
				if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
				local extg=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_HAND+LOCATION_SZONE,0,exc,m)
				if #extg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local g=extg:Select(tp,1,#extg,nil)
					if #g>0 and Duel.SendtoGrave(g,REASON_COST)>0 then
						Duel.Hint(HINT_CARD,0,m)
						g:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451779,3))
						if g:IsContains(e:GetHandler()) then e:GetHandler():CreateEffectRelation(e) end
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_FIELD)
						e2:SetCode(EFFECT_IMMUNE_EFFECT)
						e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e2:SetTargetRange(LOCATION_ONFIELD,0)
						e2:SetValue(cm.efilter)
						e2:SetOwnerPlayer(tp)
						e2:SetReset(RESET_CHAIN)
						Duel.RegisterEffect(e2,tp)
					end
				end
			end
	te:SetTarget(tg2)
	cm[te]=true
	cm[0]=true
end
function cm.efilter(e,re)
	local i=1
	while type(cm[i])=="table" do
		local te,tf,cid,ep=table.unpack(cm[i])
		if te==re and ep~=e:GetHandlerPlayer() then return true end
		i=i+1
	end
	return false
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
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
	return Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and Duel.GetCurrentChain()==0 and e:GetHandler():GetFlagEffect(m)>0
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if #g1>0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(11451779,0),aux.Stringid(11451779,1))==0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then th=true end
			Duel.ConfirmCards(1-tp,g)
		end
	elseif #g2>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end