local m=15005326
local cm=_G["c"..m]
cm.name="升格龙 娜蓝多耶"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.delop)
	c:RegisterEffect(e2)
	--apply
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SUMMON+CATEGORY_DESTROY+CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.delop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsDualState() then
		for _,i in ipairs{c:IsHasEffect(EFFECT_DUAL_STATUS)} do
			i:Reset()
		end
	end
	c:RegisterFlagEffect(15005326,RESET_EVENT+RESETS_STANDARD,0,1)
	if c:GetFlagEffect(15005326)==1 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
	if c:GetFlagEffect(15005326)==2 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if c:GetFlagEffect(15005326)==3 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	end
	if c:GetFlagEffect(15005326)==4 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	end
	if c:GetFlagEffect(15005326)==5 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,4))
	end
	if c:GetFlagEffect(15005326)>=6 then
		if c:GetFlagEffect(15005327)~=0 then c:ResetFlagEffect(15005327) end
		c:RegisterFlagEffect(15005327,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(15005326)
	local b1=ct>=1
	local b2=ct==2 and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	local b3=ct>=3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b4=ct==4 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	local b5=ct>=5 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(15005326)
	local res=0
	local b1=ct>=1
	if b1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		res=res+1
	end
	ct=c:GetFlagEffect(15005326)
	local b2=ct==2 and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	if b2 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
		local tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
			res=res+1
		end
	end
	ct=c:GetFlagEffect(15005326)
	local b3=ct>=3 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if b3 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
			res=res+1
		end
	end
	ct=c:GetFlagEffect(15005326)
	local b4=ct==4 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	if b4 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			res=res+1
		end
	end
	ct=c:GetFlagEffect(15005326)
	local b5=ct>=5 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
	if b5 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			--Duel.ConfirmCards(1-tp,g)
			res=res+1
		end
	end
end