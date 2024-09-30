--奥特兰赛 传说之天
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--MTC.LHini(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+60010002)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	if not cst==true then
		cst=true
		--local tp=c:GetOwner()
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
		--spsm
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.LHcon1)
		e1:SetOperation(cm.LHop1)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.filter(c)
	return c:IsSetCard(0xa621) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,60010002)==3 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Recover(tp,1000,REASON_EFFECT)
	elseif Duel.GetFlagEffect(tp,60010002)==5 then
		local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ht<5 then
			Duel.Draw(tp,5-ht,REASON_EFFECT)
		end
	elseif Duel.GetFlagEffect(tp,60010002)==7 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.filter2(c)
	return c:IsCode(60010003) and c:IsAbleToHand()
end
function cm.LHfil1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0xa621)
end
function cm.LHcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=eg:GetFirst():GetOwner()
	return eg:IsExists(cm.LHfil1,1,nil,tp)
end
function cm.LHop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xa621) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),60010002,RESET_PHASE+PHASE_END,0,1)
			Duel.RaiseEvent(c,EVENT_CUSTOM+60010002,nil,0,tc:GetSummonPlayer(),tc:GetSummonPlayer(),0)
		end
		tc=eg:GetNext()
	end
end