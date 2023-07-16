--埃瓦格里乌斯之教示
local cm,m=GetID()
if not pcall(function() require("expansions/script/c130006111") end) then require("script/c130006111") end
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