--最低世界的魔王
function c6160403.initial_effect(c)
	c:SetUniqueOnField(1,0,6160403) 
	 --link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,c6160403.lcheck)  
	c:EnableReviveLimit()  
	--atk up  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetValue(c6160403.val)  
	c:RegisterEffect(e2) 
	--copy  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(6160403,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,6160403)  
	e3:SetCost(c6160403.cpcost)  
	e3:SetTarget(c6160403.cptg)  
	e3:SetOperation(c6160403.cpop)  
	c:RegisterEffect(e3)  
end   
function c6160403.lcheck(g)  
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x616)  
end
function c6160403.atkfilter(c)  
	return c:IsFaceup() and c:GetAttribute()~=0  
end  
function c6160403.val(e,c)  
	local g=Duel.GetMatchingGroup(c6160403.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	return ct*500  
end 
function c6160403.cpfilter(c)  
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_TRAP)) and c:IsSetCard(0x616) and c:IsAbleToGraveAsCost()  
		and c:CheckActivateEffect(false,true,false)~=nil  
end  
function c6160403.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)  
	if chk==0 then return true end  
end  
function c6160403.cptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		if e:GetLabel()==0 then return false end  
		e:SetLabel(0)  
		return Duel.CheckLPCost(tp,2000) and Duel.IsExistingMatchingCard(c6160403.cpfilter,tp,LOCATION_DECK,0,1,nil)  
	end  
	e:SetLabel(0)  
	Duel.PayLPCost(tp,2000)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,c6160403.cpfilter,tp,LOCATION_DECK,0,1,1,nil)  
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)  
	Duel.SendtoGrave(g,REASON_COST)  
	e:SetProperty(te:GetProperty())  
	local tg=te:GetTarget()  
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end  
	te:SetLabelObject(e:GetLabelObject())  
	e:SetLabelObject(te)  
	Duel.ClearOperationInfo(0)  
end  
function c6160403.cpop(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject()  
	if te then  
		e:SetLabelObject(te:GetLabelObject())  
		local op=te:GetOperation()  
		if op then op(e,tp,eg,ep,ev,re,r,rp) end  
end  
end