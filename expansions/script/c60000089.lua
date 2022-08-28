--闪耀☆★双子 艾莉
local m=60000089
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.lcheck,1,1)
	c:EnableReviveLimit()
	--linksummon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,160000089)
	e3:SetCondition(cm.recon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.retg)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end

function cm.lcheck(c)
	return c:IsLinkSetCard(0x1151) and c:IsLevelBelow(4)
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and tc:IsSummonPlayer(tp) and 
		(tc:IsSetCard(0x1151) or tc:IsSetCard(0x2151)) and tc:IsType(TYPE_MONSTER) then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end

function cm.thcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.tgtfilter(c)
	return c:IsCode(35487920) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgtfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)>=5
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetLabel(Duel.GetTurnCount())
	e3:SetCondition(cm.negcon)
	e3:SetOperation(cm.negop)
	Duel.RegisterEffect(e3,tp)
end

function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetHandler():IsType(TYPE_SPELL) and Duel.IsChainDisablable(ev) 
	and e:GetHandler():GetFlagEffect(m+1)==0 
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
end

function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
		local turn=e:GetLabel()
		if turn==Duel.GetTurnCount() then
			e:GetHandler():RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,2)
		else
			e:GetHandler():RegisterFlagEffect(m+1,RESET_PHASE+PHASE_END,0,1)
		end
	end
end