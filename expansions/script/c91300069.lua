--歧路诗篇－忏悔荒地－
function c91300069.initial_effect(c)
	--remain field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c91300069.target)
	e1:SetOperation(c91300069.activate)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c91300069.diceop)
	c:RegisterEffect(e2)
	if not c91300069.global_check then
		c91300069.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		--ge1:SetCondition(c91300069.checkcon)
		ge1:SetOperation(c91300069.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c91300069.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,91300069) or 0
	for _,loc in pairs({ LOCATION_HAND,LOCATION_DECK,LOCATION_GRAVE,LOCATION_REMOVED }) do
		if eg:IsExists(Card.IsPreviousLocation,1,nil,loc) then ct=ct|loc end
	end
	if Duel.GetFlagEffectLabel(tp,91300069) then
		Duel.SetFlagEffectLabel(tp,91300069,ct)
	else
		Duel.RegisterFlagEffect(tp,91300069,RESET_PHASE+PHASE_END,0,1,ct)
	end
end
function c91300069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:IsCostChecked() and (e:IsHasType(EFFECT_TYPE_ACTIVATE) or c:IsLocation(LOCATION_SZONE)) and c:GetSequence()<5 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c91300069.rmfilter(c,tp)
	return c:IsSetCard(0x855) and c:IsAbleToRemove() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c91300069.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsLocation(LOCATION_SZONE) or c:GetSequence()>=5 then return end
	local d=Duel.TossDice(tp,1)
	if d<1 or d>6 then return end
	local seq=c:GetSequence()
	if seq>=d or seq==0 and d==6 then
		local s=seq==0 and d==6 and 4 or seq-d
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,s)
		if tc then Duel.SendtoGrave(c,REASON_EFFECT) return else
			Duel.MoveSequence(c,s)
		end
	else
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,d-seq-1)
		if tc then Duel.SendtoGrave(c,REASON_EFFECT) return else
			e:SetLabel(1)
			Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true,1<<(d-seq-1))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)--0x47c0000
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_RACE)
			e2:SetValue(RACE_ALL)
			c:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
			e3:SetValue(0xff)
			c:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(0)
			c:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(0)
			c:RegisterEffect(e5,true)
			c:SetStatus(STATUS_NO_LEVEL,true)
		end
		--local flag=1<<(11-c:GetSequence())
	end
	if c:IsLocation(LOCATION_MZONE) then
		local b1=Duel.IsExistingMatchingCard(c91300069.rmfilter,tp,LOCATION_DECK,0,1,nil,tp)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil)
		if not (b1 or b2) then return end
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(91300069,0)},
			{b2,aux.Stringid(91300069,1)},
			{true,aux.Stringid(91300069,2)})
		if op==3 then return end
		local tc
		if op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			tc=Duel.SelectMatchingCard(tp,c91300069.rmfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		else
			tc=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1):GetFirst()
		end
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(91300069,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c91300069.retcon)
		e1:SetOperation(c91300069.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if tc:IsPreviousControler(tp) then
			Duel.BreakEffect()
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
			Duel.ClearTargetCard()
			e:SetProperty(te:GetProperty())
			local tg=te:GetTarget()
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
			e:SetProperty(0)--Original Property
		end
	else
		if CROSSROADS_COIN then
			local t={}
			for des,f in pairs(Crossroads_coin_effect_list) do
				local res=f(e,tp,eg,ep,ev,re,r,rp,0)
				if res then
					for _,v in pairs(t) do
						if v==des then res=false end
					end
				end
				if res then table.insert(t,des) end
			end
			if #t==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVEEFFECT)
			local sel=Duel.SelectOption(tp,table.unpack(t))
			local des=t[sel+1]
			local f=Crossroads_coin_effect_list[des]
			f(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
end
function c91300069.retcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(91300069)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c91300069.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsPreviousLocation(LOCATION_HAND) then
		Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
	else
		Duel.SendtoDeck(tc,tc:GetPreviousControler(),SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c91300069.diceop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.Hint(HINT_CARD,0,91300069)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TOSS_DICE_NEGATE)
		e1:SetOperation(c91300069.repop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c91300069.repop(e,tp,eg,ep,ev,re,r,rp)
	local res=LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED == Duel.GetFlagEffectLabel(tp,91300069)
	--
	local dc={Duel.GetDiceResult()}--maybe exist 0!
	local t={}
	for i,v in ipairs(dc) do
		if v~=0 and (v~=3 or res) then table.insert(t,i) end
	end
	--Duel.GetDiceResult(table.unpack(dc))
	if #t~=0 and Duel.SelectYesNo(tp,aux.Stringid(91300069,3)) then
		Duel.Hint(HINT_CARD,0,91300069)
		local ac=t[1]
		if #t>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91300069,4))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		local ct=3
		if res then
			local z={}
			for i=1,100 do z[i]=i end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(91300069,5))
			ct=Duel.AnnounceNumber(tp,table.unpack(z))
		end
		dc[ac]=ct
		Duel.SetDiceResult(table.unpack(dc))
		e:Reset()
	end
end
