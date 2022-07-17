--破碎世界的审判
function c6160404.initial_effect(c)
	c:SetUniqueOnField(1,0,6160404) 
	 --link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,c6160404.lcheck)  
	c:EnableReviveLimit()  
	--ban   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6160404,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,6160404)
	e1:SetTarget(c6160404.bantg)
	e1:SetOperation(c6160404.banop)
	c:RegisterEffect(e1) 
	--copy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160403,1))  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,6160403)  
	e2:SetCost(c6160404.cpcost)  
	e2:SetTarget(c6160404.cptg)  
	e2:SetOperation(c6160404.cpop)  
	c:RegisterEffect(e2)  
end
function c6160404.lcheck(g)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x616) 
end 
function c6160404.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c6160404.banop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c6160404.distg1)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(c6160404.discon)
	e2:SetOperation(c6160404.disop)
	e2:SetLabel(ac)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c6160404.distg2)
	e3:SetLabel(ac)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c6160404.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c6160404.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c6160404.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c6160404.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c6160404.cpfilter(c)  
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_TRAP)) and c:IsSetCard(0x616) and c:IsAbleToGraveAsCost()  
		and c:CheckActivateEffect(false,true,false)~=nil  
end  
function c6160404.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)  
	if chk==0 then return true end  
end  
function c6160404.cptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		if e:GetLabel()==0 then return false end  
		e:SetLabel(0)  
		return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(c6160404.cpfilter,tp,LOCATION_DECK,0,1,nil)  
	end  
	e:SetLabel(0)  
	Duel.PayLPCost(tp,2000)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c6160404.cpfilter,tp,LOCATION_DECK,0,1,1,nil)  
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)  
	Duel.SendtoGrave(g,REASON_COST)  
	e:SetProperty(te:GetProperty())  
	local tg=te:GetTarget()  
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
	te:SetLabelObject(e:GetLabelObject())  
	e:SetLabelObject(te)  
	Duel.ClearOperationInfo(0)  
end  
function c6160404.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject()  
	if te then  
		e:SetLabelObject(te:GetLabelObject())  
		local op=te:GetOperation()  
		if op then op(e,tp,eg,ep,ev,re,r,rp) end  
end  
end