-- 一缕光芒
Duel.LoadScript("c60013002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--连结
	Heidemarie.LianJie(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.AnXitg)
	e1:SetOperation(cm.AnXiop)
	c:RegisterEffect(e1)
end
cm.isChaosZeroNightmare=true
function cm.fil(c)
	return c:IsCode(60013002) and c:IsFaceup()
end
function cm.dcfil(c)
	return  c:IsDiscardable()
end
function cm.thfil(c)
	return not c:IsCode(m) and c:IsAbleToHand() and c.isChaosZeroNightmare and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,2,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	if chk==0 then return b1 or b2 or b3 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,2,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,2,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	if not b1 and not b2 and not b3 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)},
		{b3,aux.Stringid(m,3)})
	if op==2 or op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	if not Duel.DiscardHand(tp,cm.dcfil,2,2,REASON_EFFECT+REASON_DISCARD,nil) then return end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,2,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local sg=Duel.GetOperatedGroup()
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	elseif op==3 then
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
		Duel.RegisterFlagEffect(tp,60013005,0,0,1)
	end
end

function cm.AnXitg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsPlayerCanDraw(tp,1) then b1=true end
	local b2=false
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	if chk==0 then return b1 or b2 or b3 end
end
function cm.AnXiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsPlayerCanDraw(tp,1) then b1=true end
	local b2=false
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=3 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	if not b1 and not b2 and not b3 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,4)},
		{b3,aux.Stringid(m,5)})
	
	if op==2 or op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	if op==1 then Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==2 then Duel.Draw(tp,2,REASON_EFFECT)
	elseif op==3 then
		local rg=Duel.GetDecktopGroup(1-tp,3)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end












