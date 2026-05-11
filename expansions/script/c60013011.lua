-- 展开极光
Duel.LoadScript("c60013002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--安息
	Heidemarie.AnXi(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.isChaosZeroNightmare=true
function cm.fil(c)
	return c:IsCode(60013002) and c:IsFaceup()
end
function cm.thfil(c)
	return c:IsCode(60013005) and c:IsAbleToHand()
end
function cm.s5fil(c)
	return c:IsCode(60013005) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	local b5=false
	if Duel.IsExistingMatchingCard(cm.s5fil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b5=true end
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	local b5=false
	if Duel.IsExistingMatchingCard(cm.s5fil,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b5=true end
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end

	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)},
		{b3,aux.Stringid(m,3)},
		{b4,aux.Stringid(m,4)},
		{b5,aux.Stringid(m,5)})

	if op==2 or op==3 or op==4 or op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	if op==1 or op==2 or op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.GetMatchingGroup(cm.s5fil,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	if op==1 or op==2 or op==3 or op==5 then
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
	end
	if op==4 then
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
	end
end
















