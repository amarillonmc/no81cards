--喷射旋棍手
local m=60002272
local cm=_G["c"..m]
function cm.initial_effect(c)
	Art_g=Group.CreateGroup()
	Art_g:KeepAlive()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x6a9) and tc:IsType(TYPE_MONSTER) then
			Art_g:AddCard(tc)
		end
		tc=eg:GetNext()
	end
end
function cm.thfilter(c)
	return c:IsCode(60002250)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gm=nil
	if Art_g:GetClassCount(Card.GetCode)<6 then
		gm=60002238
		local tc1=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc2=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc2,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc3=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc3,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc4=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc4,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		gm=60002234
		local tc1=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc1,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc2=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc2,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc3=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc3,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local tc4=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc4,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc1:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc2:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc3:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc4:RegisterEffect(e1)
	end
	
end
