--秘传·不死斩
local s,id,o = GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,31740001)	
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.destg)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_ACTIVATING)
		e1:SetRange(LOCATION_PZONE)
		e1:SetCondition(s.lfcon)
		e1:SetOperation(s.lfop)
		c:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(s.destg)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(s.con4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)

end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==id
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(31740024)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(31740024,0,0)
	Duel.Hint(HINT_CARD,1,31740024)
end
function s.lfcon(e,tp,eg,ep,ev,re,r,rp)
	 
	return re and (re:GetHandler():IsCode(31740001) or aux.IsCodeListed(re:GetHandler(),31740001)) and re:GetHandlerPlayer()==tp and Duel.GetFirstTarget() and Duel.GetFirstTarget():IsLocation(LOCATION_ONFIELD)
end
function s.lfop(e,tp,eg,ep,ev,re,r,rp)
		local c = e:GetHandler()
		if not Duel.SelectYesNo(tp,aux.Stringid(id,1)) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
		local g=Group.CreateGroup()
		Duel.ChangeChainOperation(0,s.repop2)	
		Duel.Hint(HINT_CARD,0,id)
		
	
end
function s.repop2(e,tp,eg,ep,ev,re,r,rp)
		local tc = Duel.GetFirstTarget()
		local c= e:GetHandler()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) ~=0 then 
			local dg = Group.CreateGroup()
			local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			for ic in aux.Next(g) do
				local preatk=tc:GetAttack()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(Duel.GetCurrentChain()*(-500))
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ic:RegisterEffect(e1)
				if preatk~=0 and ic:IsAttack(0) then dg:AddCard(ic) end
			end
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
		end
	
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=  Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	return g:GetClassCount(Card.GetRightScale)==1 and #g==2
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=  Duel.GetMatchingGroup(s.ifilter,tp,LOCATION_PZONE,0,nil)
	if chk==0 then return #g==2 end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 2, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, LOCATION_DECK)
	
	
end

function s.ifilter(c)
	return c:IsDestructable()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c =e:GetHandler()
	local g=  Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
	local sg = Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if Duel.Destroy(g,REASON_EFFECT)==2  then 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EFFECT_ADD_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_FIRE)
		e2:SetTarget(s.skrfilter)
		e2:SetTargetRange(LOCATION_MZONE,0)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.sfilter(c)
	return c:IsCode(31740001) or aux.IsCodeListed(c,31740001)
end
function s.skrfilter(c)
	return c:IsCode(31740001) and c:IsFaceup()	
end