local m=25000012
local cm=_G["c"..m]
cm.name="百年孤独"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.filter(c,rac,att)
	return c:IsRace(rac) and c:IsAttribute(att) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,rc=e:GetHandler(),re:GetHandler()
	if chk==0 then return rc:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,rc:GetRace(),rc:GetAttribute()) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsRelateToEffect(re) then return end
	Duel.Release(eg,REASON_EFFECT)
	local rc=Duel.GetOperatedGroup():GetFirst()
	if not rc then return end
	local c=e:GetHandler()
	for i=1,100 do
		if c:GetFlagEffect(m+i*10000)==0 then
			c:RegisterFlagEffect(m+i*10000,RESET_EVENT+RESETS_STANDARD,0,0,rc:GetCode())
			break
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,rc:GetRace(),rc:GetAttribute()):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if not tc:IsSummonable(true,nil) then return end
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_CHAIN)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(cm.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc,res=e:GetHandler(),eg:GetFirst(),false
	for i=1,100 do
		if c:GetFlagEffect(m+i*10000)==0 then break end
		if tc:GetCode()==c:GetFlagEffectLabel(m+i*10000) then res=true end
	end
	if not res then return end
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	e:Reset()
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
