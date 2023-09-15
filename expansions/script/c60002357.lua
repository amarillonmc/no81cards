--元创之咏叹调
Duel.LoadScript("c60002355.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Aria.ytdcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--back
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(Aria.bkcon)
	e2:SetCost(Aria.ytdcost)
	e2:SetTarget(Aria.bktg)
	e2:SetOperation(Aria.bkop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x627) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetCurrentChain()~=1 or Duel.GetFlagEffect(tp,60002355)<2 then   
		if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif Duel.GetCurrentChain()==1 and Duel.GetFlagEffect(tp,60002355)>=2 then
		if chk==0 then return true end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=1 or Duel.GetFlagEffect(tp,60002355)<2 then 
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 then
			local ft=math.min(2,#g)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local hg=g:SelectSubGroup(tp,cm.spcheck,false,1,ft)
			if #hg>0 then
				Duel.SendtoGrave(hg,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hg)
			end
		end
	elseif Duel.GetCurrentChain()==1 and Duel.GetFlagEffect(tp,60002355)>=2 then
		Aria.StartAria(c)
	end
	if Duel.GetCurrentChain()>=4 then
		Duel.RegisterFlagEffect(tp,70002355,RESET_PHASE+PHASE_END,0,1)
	end
end