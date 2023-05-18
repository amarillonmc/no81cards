--炼狱的葬亡
local m=82209078
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	--return to grave  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_BATTLE_START)  
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.tgcon)  
	e3:SetCost(aux.bfgcost)  
	e3:SetTarget(cm.tgtg)  
	e3:SetOperation(cm.tgop)  
	c:RegisterEffect(e3)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)  
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,0x0e,0,1,e:GetHandler()) end  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,0x0e,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)  
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end  
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)  
	if ct>0 and Duel.DiscardDeck(tp,ct,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		if not g:IsExists(Card.IsRace,2,nil,RACE_FIEND) then
			Duel.BreakEffect()
			Duel.Remove(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),POS_FACEDOWN,REASON_EFFECT)
		end
	end  
end  
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetAttacker()  
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end  
	e:SetLabelObject(tc)  
	return tc and tc:IsFaceup() and tc:IsSetCard(0xbb)
end  
function cm.tgfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()>0
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local bc=e:GetLabelObject()  
	if chk==0 then return bc and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED) 
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if not tc then return end
	if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 then
		local bc=e:GetLabelObject()  
		if bc:IsRelateToBattle() and bc:IsControler(tp) then  
			local atk=tc:GetAttack()
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			e1:SetValue(math.ceil(atk/2))  
			bc:RegisterEffect(e1)   
		end  
	end
end  