--指引前路的苍蓝之星·片手剑
function c11561037.initial_effect(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,function(e) return c.SetCard_ZH_Bluestar end,2,true) 
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsAttackPos() end)
	c:RegisterEffect(e1)	  
	--discard
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c11561037.condition) 
	e1:SetOperation(c11561037.operation)
	c:RegisterEffect(e1) 
	--negate attack
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11561037.negcon)
	e2:SetOperation(c11561037.negop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11561037,1))
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,70369117)
	e3:SetCost(c11561037.cpcost)
	e3:SetTarget(c11561037.cptg)
	e3:SetOperation(c11561037.cpop)
	c:RegisterEffect(e3) 
	--Destroy
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c11561037.descon)
	e1:SetOperation(c11561037.desop)
	c:RegisterEffect(e1)
end
c11561037.SetCard_ZH_Bluestar=true 
function c11561037.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil) and e:GetHandler():IsAttackPos()
end 
function c11561037.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_HAND,nil) 
	if g:GetCount()>0 then 
		Duel.Hint(HINT_CARD,0,1561037)  
		local dg=g:RandomSelect(tp,1) 
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end  
end
function c11561037.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp and e:GetHandler():IsDefensePos()
end
function c11561037.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c11561037.cpfilter(c)
	return (c:GetType()==TYPE_SPELL) and c.SetCard_ZH_Bluestar and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c11561037.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c11561037.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c11561037.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11561037.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c11561037.cpop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end 
		if c:IsRelateToEffect(e) then 
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end 
	end 
end
function c11561037.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) 
end 
function c11561037.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then 
		Duel.Hint(HINT_CARD,0,1561037)  
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)  
		Duel.Destroy(dg,REASON_EFFECT)  
	end 
end 


