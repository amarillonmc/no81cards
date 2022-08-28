local m=90700022
local cm=_G["c"..m]
cm.name="多元霜火要塞"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90700022,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_HAND)
	--e2:SetCondition(cm.actcon)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetTarget(cm.acttg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_MOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.addcop)
	c:RegisterEffect(e4)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.dtoffilter(c)
	return c:IsAbleToDeckAsCost()
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dtoffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.dtoffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,tp,-1,REASON_COST)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local field=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if field then
		Duel.SendtoGrave(field,REASON_RULE)
	end
	local tc=e:GetHandler()
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function cm.atktgfilter(e,c)
	return c:IsSetCard(0x5ac0)
end
function cm.cfilter(c)
	return c:IsPosition(POS_FACEUP)
end
function cm.serfilter(c)
	return c:IsSetCard(0x5ac0) and c:IsAbleToHand()
end
function cm.addcop(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	while c do
		if not c:IsLocation(LOCATION_FZONE) and c:IsLocation(LOCATION_ONFIELD) and c:IsPosition(POS_FACEUP) and c:IsSetCard(0x5ac0) then
			e:GetHandler():AddCounter(0x5ac0,1)
			c:AddCounter(0x5ac0,3)
			e:GetHandler():AddCounter(0x5ac0,3)
			local Counters=Duel.GetCounter(tp,1,0,0x5ac0)
			local adcon=Counters>0
			local countercon=Counters>2 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
			local sercon=Counters>5 and Duel.IsExistingMatchingCard(cm.serfilter,tp,LOCATION_DECK,0,1,nil)
			if (adcon or countercon or sercon) and Duel.SelectYesNo(tp,aux.Stringid(90700022,5)) then
				local ope=-1
				if adcon then
					if countercon then
						if sercon then
							ope=Duel.SelectOption(tp,aux.Stringid(90700022,0),aux.Stringid(90700022,1),aux.Stringid(90700022,2))
						else
							ope=Duel.SelectOption(tp,aux.Stringid(90700022,0),aux.Stringid(90700022,1))
						end
					else
						if sercon then
							ope=Duel.SelectOption(tp,aux.Stringid(90700022,0),aux.Stringid(90700022,2))
							if ope==1 then
								ope=2
							end
						else
							ope=0
						end
					end
				else
					if countercon then
						if sercon then
							ope=Duel.SelectOption(tp,aux.Stringid(90700022,1),aux.Stringid(90700022,2))
							ope=ope+1
						else
							ope=2
						end
					else
						ope=2
					end
				end
				if ope==0 then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(90700022,3))
					local opt={}
					for i=1,Counters do
						opt[i]=i
					end
					opt[Counters+1]=nil
					local adnum=Duel.AnnounceNumber(tp,table.unpack(opt))
					Duel.RemoveCounter(tp,1,0,0x5ac0,adnum,REASON_EFFECT)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetTargetRange(LOCATION_MZONE,0)
					e1:SetTarget(cm.atktgfilter)
					e1:SetValue(100*adnum)
					e1:SetReset(RESET_PHASE+PHASE_END,2)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					Duel.RegisterEffect(e2,tp)
				end
				if ope==1 then
					Duel.RemoveCounter(tp,1,0,0x5ac0,3,REASON_EFFECT)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
					local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
					if g then
						local tc=g:GetFirst()
						tc:AddCounter(0x5ac0,1)
					end
				end
				if ope==2 then
					Duel.RemoveCounter(tp,1,0,0x5ac0,6,REASON_EFFECT)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g=Duel.SelectMatchingCard(tp,cm.serfilter,tp,LOCATION_DECK,0,1,1,nil)
					if g then
						Duel.SendtoHand(g,tp,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,g)
					end
				end
			end
		end
		c=eg:GetNext()
	end
end