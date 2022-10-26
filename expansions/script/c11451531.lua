--日冕之斗争军势
--21.05.31
local cm,m=GetID()
function cm.initial_effect(c)
	--advance
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451537,2))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.adcon)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	--destroy
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(11451537,3))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+6)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(11451537,4))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+12)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451531,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--summon or send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.tgcon)
	e2:SetOperation(cm.tgop)
	if 1~=1 then
		e2:SetReset(RESET_PHASE+PHASE_BATTLE_START,2)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START,0,1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START,0,2)
	else
		e2:SetReset(RESET_PHASE+PHASE_BATTLE_START)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START,0,1)
	end
	Duel.RegisterEffect(e2,tp)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 or not c:IsLocation(LOCATION_HAND) or (c:GetOriginalCode()~=m and not c:IsStatus(STATUS_COPYING_EFFECT)) then
		e:Reset()
		return false
	else
		return c:GetFlagEffect(m)==1
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos~=0 and Duel.SelectYesNo(tp,aux.Stringid(11451537,1)) then
		if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
			Duel.Summon(tp,c,true,nil,1)
		else
			Duel.MSet(tp,c,true,nil,1)
		end
	else
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or not c:IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g1>0 and (#g2==0 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
		local sg=g1:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	elseif #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g2:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		if tc then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
		end
	end
end