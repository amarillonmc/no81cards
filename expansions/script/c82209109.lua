--清莲仙的巡丽
local m=82209109
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.actcon)  
	c:RegisterEffect(e1)  
	--atk&def  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc298))  
	e2:SetValue(cm.atkval)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()  
	e3:SetCode(EFFECT_UPDATE_DEFENSE)  
	c:RegisterEffect(e3)
	--effect 2
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_BATTLE_START)  
	e4:SetRange(LOCATION_SZONE)  
	e4:SetCondition(cm.con) 
	e4:SetTarget(cm.tg)  
	e4:SetOperation(cm.op)  
	c:RegisterEffect(e4)   
	--effect 3  
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)  
	e5:SetCountLimit(1,m) 
	e5:SetCost(cm.cost2)
	e5:SetCondition(cm.con2) 
	e5:SetTarget(cm.tg2)  
	e5:SetOperation(cm.op2)  
	c:RegisterEffect(e5) 
end
function cm.actfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.atkval(e,c)
	return Duel.GetTurnCount()*300
end
--effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetAttacker()  
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end  
	return tc and tc:IsFaceup() and tc:IsSetCard(0xc298) 
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tg=Duel.GetDecktopGroup(1-tp,3)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 and tg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==3 end  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetDecktopGroup(1-tp,3)  
	Duel.DisableShuffleCheck()  
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end  
--effect 3
function cm.confilter(c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end 
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end
end  
function cm.op2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetCode(EVENT_CHAIN_SOLVING)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.discon)  
	e1:SetOperation(cm.disop)  
	Duel.RegisterEffect(e1,tp) 
end 
function cm.disfilter(c,seq2)  
	local seq1=aux.MZoneSequence(c:GetSequence())  
	return c:IsFaceup() and c:IsSetCard(0xc298) and seq1==4-seq2  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)  
	return rp==1-tp 
	and (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
	and loc&LOCATION_SZONE==LOCATION_SZONE 
	and seq<=4  
	and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,0,1,nil,seq)  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,m)  
	Duel.NegateEffect(ev)  
end  