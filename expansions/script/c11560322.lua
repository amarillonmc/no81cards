--混沌的支配者·艾希连德凛克
function c11560322.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,function(c) return c.SetCard_XdMcy end,5,5,true) 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)  
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,11560322+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c11560322.xxcon) 
	e1:SetOperation(c11560322.xxop) 
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560322)
	e2:SetTarget(c11560322.rmtg)
	e2:SetOperation(c11560322.rmop)
	c:RegisterEffect(e2)
end
c11560322.SetCard_XdMcy=true  
function c11560322.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()	
end 
function c11560322.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.ConfirmCards(1-tp,c) 
	Duel.Hint(HINT_CARD,0,11560322) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11560322,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE) 
	e1:SetCost(c11560322.cpcost)
	e1:SetTarget(c11560322.cptg)
	e1:SetOperation(c11560322.cpop) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_XdMcy end)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
end  
function c11560322.cpfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.SetCard_XdMcy and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c11560322.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c11560322.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c11560322.cpfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,11560322)==0 
	end 
	Duel.RegisterFlagEffect(tp,11560322,RESET_CHAIN,0,1) 
	e:SetLabel(0)  
	local g=Duel.SelectMatchingCard(tp,c11560322.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true) 
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c11560322.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end 
end
function c11560322.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),POS_FACEDOWN)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end  
function c11560322.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),POS_FACEDOWN)
	if g:GetCount()>0 then 
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)  
	end 
end 












