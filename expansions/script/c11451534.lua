--汐潮之斗争军势
--21.06.17
local cm,m=GetID()
function cm.initial_effect(c)
	--advance
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451537,2))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_MSET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.adcon)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SSET)
	c:RegisterEffect(e4)
	local e7=e1:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(cm.adcon2)
	c:RegisterEffect(e7)
	local e10=e7:Clone()
	e10:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e10)
	--control
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(11451537,3))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+6)
	e2:SetCondition(cm.ctcon)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SSET)
	c:RegisterEffect(e5)
	local e8=e2:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(cm.ctcon2)
	c:RegisterEffect(e8)
	local e11=e8:Clone()
	e11:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e11)
	--draw
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(11451537,4))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+12)
	e3:SetCondition(aux.TRUE)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e9=e3:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	e9:SetCondition(cm.drcon2)
	c:RegisterEffect(e9)
	local e12=e3:Clone()
	e12:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e12)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.fdfilter,1,nil)
end
function cm.fdfilter(c)
	return c:IsOnField() and c:IsFacedown()
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
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or not c:IsSummonType(SUMMON_TYPE_ADVANCE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,1-tp,REASON_EFFECT)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end