--砂金·戏浪·激浪跃金-
Duel.LoadScript("c71290002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290002)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,3,3)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.linkcon)
	e1:SetTarget(cm.rolltg)
	e1:SetOperation(cm.rollop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000000)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
	DPEcho.Register(e2,3)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DICE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.ahacon)
	e3:SetTarget(cm.ahatg)
	e3:SetOperation(cm.ahaop)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,71290002) 
end
function cm.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.rolltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.rollop(e,tp,eg,ep,ev,re,r,rp)
	local all=true

	while all==true do
		local res=table.pack(Duel.TossDice(tp,3))
		local draw=0
		for i=1,3 do
			if res[i]>=6 then
				draw=draw+1
			else
				all=false
			end
		end
		if draw>0 then
			Duel.Draw(tp,draw,REASON_EFFECT)
		end
	end
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	Duel.Recover(tp,d*1000,REASON_EFFECT)
end
function cm.ahacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),71290002)~=0
end
function cm.ahatg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		e:SetLabel(Duel.GetCurrentChain()+1)
		return c:IsAbleToHand()
			or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.ahaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tf=false
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			tf=true
		end
	end
	if not tf and c:IsAbleToHand() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		tf=true
	end
	if not tf then return end
	local chain=e:GetLabel()
	local num=0
	if chain<3 then num=1
	else
		while chain>=3 do
			num=num+1
			chain=chain-3
		end
	end
	local res=table.pack(Duel.TossDice(tp,num))
	local ct=0
	for i=1,num do
		if res[i]>=6 then
			ct=ct+1
		end
	end
	if ct>0 then
		local g=Duel.GetDecktopGroup(1-tp,ct*2)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
