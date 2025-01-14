--超时空世界 隐藏的折跃星
local m=13257335
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetCountLimit(1,TAMA_THEME_CODE+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(cm.recon)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	elements={{"theme_effect",e3}}
	cm[c]=elements
	
end
function cm.filter(c)
	return (c:IsCode(13257329) or c:IsCode(13257330)) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if not e:GetHandler():IsRelateToEffect(e) or dcount==0 then return end
	Duel.Hint(11,0,aux.Stringid(m,7))
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
		if g:GetCount()==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		local seq=-1
		local tc=g:GetFirst()
		local spcard=nil
		while tc do
			if tc:GetSequence()>seq then 
				seq=tc:GetSequence()
				spcard=tc
			end
			tc=g:GetNext()
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(spcard,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,spcard)
			Duel.ShuffleHand(tp)
		end
	end
end
function cm.check(c)
	local f=tama.cosmicFighters_getFormation(c)
	return c:IsSetCard(0x351) and ((Duel.GetAttacker() and f:IsContains(Duel.GetAttacker())) or (Duel.GetAttackTarget() and f:IsContains(Duel.GetAttackTarget())))
end
function cm.filter1(c)
	return (c:IsCode(13257331) or c:IsCode(13257332)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then 
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,spcard)
		Duel.ShuffleHand(tp)
	end
end
function cm.recon(e,tp)
	return not e:GetHandler():IsForbidden() and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(TAMA_THEME_CODE)
	e1:SetTargetRange(1,0)
	e1:SetValue(m)
	Duel.RegisterEffect(e1,tp)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetValue(cm.effectfilter)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(cm.effectfilter)
	Duel.RegisterEffect(e3,tp)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsCode(13257329,13257330,13257331,13257332)
end
