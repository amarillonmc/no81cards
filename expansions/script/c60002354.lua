--达摩克里斯之咏叹调
Duel.LoadScript("c60002355.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetCurrentChain()~=1 or Duel.GetFlagEffect(tp,60002355)<2 then 
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
	elseif Duel.GetCurrentChain()==1 and Duel.GetFlagEffect(tp,60002355) then
		if chk==0 then return true end
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=1 or Duel.GetFlagEffect(tp,60002355)<2 then 
		Duel.SortDecktop(tp,1-tp,3)
	elseif Duel.GetCurrentChain()==1 and Duel.GetFlagEffect(tp,60002355)>=2 then
		Aria.StartAria(c)
	end
	if Duel.GetCurrentChain()>=4 then
		Duel.RegisterFlagEffect(tp,70002355,RESET_PHASE+PHASE_END,0,1)
	end
end