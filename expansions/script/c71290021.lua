--邂逅于下一个花季
Duel.LoadScript("c71290002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290020)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_TOSS_DICE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.millcon)
	e2:SetTarget(cm.milltg)
	e2:SetOperation(cm.millop)
	c:RegisterEffect(e2)
	DPEcho.Register(e2,3)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.plcon)
	e3:SetTarget(cm.pltg)
	e3:SetOperation(cm.plop)
	c:RegisterEffect(e3)
end
if not cm.galaxycity then
	cm.galaxycity=true
	cm._tossdice=Duel.TossDice
	Duel.TossDice=function (tp,a,b)
		if Duel.GetFlagEffect(tp,71290005)~=0 then
			local rt={}
			local c=a
			if b then
				c=c+b
			end
			for i=1,c do
				table.insert(rt,99)
			end
			Duel.ResetFlagEffect(tp,71290005)
			return table.unpack(rt)
		else
			return cm._tossdice(tp,a,b)
		end   
	end
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(71290020) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			Duel.RegisterFlagEffect(tp,71290005,0,0,1)
		end
	end
end
function cm.millcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function cm.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetDecktopGroup(tp,1)
		return #g>0 and g:GetFirst():IsAbleToGrave()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.millop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.plcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
