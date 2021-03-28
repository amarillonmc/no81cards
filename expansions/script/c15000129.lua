local m=15000129
local cm=_G["c"..m]
cm.name="方舟之骑士·卡夫卡"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--Destroy and SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000129)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,15000130)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	c15000129.summon_effect=e2
end
function cm.desfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.IsAbleToEnterBP() and Duel.SelectYesNo(tp,aux.Stringid(15000129,0)) then
			--attack limit
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_FIELD)
			e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e7:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e7:SetTargetRange(0,LOCATION_MZONE)
			e7:SetCondition(cm.atkcon)
			e7:SetTarget(cm.atktg)
			e7:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e7,tp)
			local e8=Effect.CreateEffect(c)
			e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e8:SetCode(EVENT_ATTACK_ANNOUNCE)
			e8:SetOperation(cm.checkop)
			e8:SetLabelObject(e7)
			e8:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e8,tp)
		end
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(1-tp,15000129)~=0
end
function cm.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(1-tp,15000129)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	Duel.RegisterFlagEffect(1-tp,15000129,RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x11ae,1) end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsCanAddCounter(0x11ae,1) then return end
	if e:GetHandler():IsRelateToEffect(e) then
		local list={}
		local ct=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetCount()
		local x=1
		while x<=ct do
			table.insert(list,x)
			x=x+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000129,1))
		local n,x1=Duel.AnnounceNumber(tp,table.unpack(list))
		if Duel.IsPlayerAffectedByEffect(tp,29065580) then
			n=n+1
		end
		e:GetHandler():AddCounter(0x11ae,n)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.thcon)
		e1:SetOperation(cm.thop)
		e1:SetLabelObject(e:GetHandler())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.thfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToHand()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,15000129)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local e1=Effect.CreateEffect(e:GetLabelObject())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(cm.sumlimit)
			e1:SetValue(cm.aclimit)
			e1:SetLabel(g:GetFirst():GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:GetHandler():IsLocation(LOCATION_HAND)
end