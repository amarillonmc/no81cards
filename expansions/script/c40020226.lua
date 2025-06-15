--假面骑士 极狐/马格南推进器形态
local m=40020226
local cm=_G["c"..m]
cm.named_with_DGP=1
function cm.DGP(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DGP
end
function cm.initial_effect(c)
	aux.AddCodeList(c,40020225)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e4:SetCondition(cm.immcon)
	e4:SetOperation(cm.immop)
	c:RegisterEffect(e4)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xf12,1)
end
function cm.val(e,re,dam,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(c:GetControler(),m,RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return dam
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)>0 and Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		local tc=sg:GetFirst()
		tc:AddCounter(0xf12,1)
		Duel.ResetFlagEffect(tp,m)
		if tc:GetCounter(0xf12)==1 or tc:GetCounter(0xf12)==2 or tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020225,e,0,tp,tp,0)
		end
		if tc:GetCounter(0xf12)==3 or tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==5 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020235,e,0,tp,tp,0)
		end
		if tc:GetCounter(0xf12)==4 or tc:GetCounter(0xf12)==6 then
			Duel.RaiseEvent(tc,EVENT_CUSTOM+40020325,e,0,tp,tp,0)
		end
	end
end


function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c,check)
	return c:IsAbleToHand()
		and (c:IsCode(40020225) or (check and aux.IsCodeListed(c,40020225) and c:IsType(TYPE_MONSTER)))
end
function cm.checkfilter(c)
	return c:IsFaceup() and c:IsCode(40020225)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.IsExistingMatchingCard(cm.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
		return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.IsExistingMatchingCard(cm.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,check):GetFirst()
	--local tc=Duel.SelectMatchingCard(tp,c17535764.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsCode(40020225) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			--Debug.Message(1)
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.val)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.ctop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e3,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e4,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
end