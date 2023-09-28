--埃瓦格里乌斯之教示
local cm,m=GetID()
--lib
AlterEgo=AlterEgo or {}
ae=AlterEgo
function ae.initial(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ae.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(ae.recon)
	e3:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e3)
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(ae.repcon)
	e4:SetOperation(ae.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,c:GetOriginalCode()+1000)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(ae.sptg)
	e5:SetOperation(ae.spop)
	c:RegisterEffect(e5)
	--ptos
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(ae.ptoscon)
	e6:SetOperation(ae.ptosop)
	c:RegisterEffect(e6)
end
function ae.value(e,c)
	return Duel.GetMatchingGroupCount(ae.filter,c:GetControler(),LOCATION_ONFIELD,0,nil)*1000
end
function ae.filter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo and c:IsFaceup()
end
function ae.cfilter(c)
	local com=_G["c"..c:GetCode()]
	return com and com.AlterEgo
end
function ae.recon(e)
	return e:GetHandler():IsLocation(LOCATION_SZONE) and not e:GetHandler():IsLocation(LOCATION_PZONE)
end
function ae.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function ae.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	local num=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then num=num+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then num=num+1 end
	if (num==0 or not Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetOwner())) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
function ae.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function ae.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function ae.ptoscon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetCurrentChain()==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function ae.ptosop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(c:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006111,1))
	end
end
--
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return ae.cfilter(c) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		local tg=sg1:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			sg1:Sub(tg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=sg1:Select(tp,1,1,nil):GetFirst()
			local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			local b3=tc:IsAbleToHand()
			local off=1
			local ops={} 
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(m,0)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(m,1)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(m,2)
				opval[off-1]=3
				off=off+1
			end
			if off==1 then return end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			if opval[op]==1 then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			elseif opval[op]==2 then
				if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
					local e1=Effect.CreateEffect(tc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					tc:RegisterEffect(e1)
					tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006111,1))
				end
			elseif opval[op]==3 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
			sg1:RemoveCard(tc)
			tc=sg1:GetFirst()
			local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			local b3=tc:IsAbleToHand()
			local off=1
			local ops={} 
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(m,0)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(m,1)
				opval[off-1]=2
				off=off+1
			end
			if b3 then
				ops[off]=aux.Stringid(m,2)
				opval[off-1]=3
				off=off+1
			end
			if off==1 then return end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			if opval[op]==1 then
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			elseif opval[op]==2 then
				if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
					local e1=Effect.CreateEffect(tc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					tc:RegisterEffect(e1)
					tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(130006045,1))
				end
			elseif opval[op]==3 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
function cm.tfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and ae.filter(c) and c:IsControler(tp) and c:IsFaceup()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(cm.tfilter,1,nil,tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsPlayerCanDraw(tp,1) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeChainOperation(ev,cm.fff)
end
function cm.fff(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(1-tp,1,REASON_EFFECT)>0 then
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		local dg=sg:RandomSelect(tp,1)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end