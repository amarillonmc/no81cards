--《吉他和孤独和蓝色星球》
function c79014036.initial_effect(c)
	aux.AddCodeList(c,79014030)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c79014036.mtcon)
	e1:SetOperation(c79014036.mtop)
	c:RegisterEffect(e1)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c79014036.accon) 
	e1:SetOperation(function(e) 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(79014036,15)) 
	end)
	c:RegisterEffect(e1) 
	--indes
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_FZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_SPIRIT) end) 
	e1:SetValue(c79014036.atkval) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_FZONE) 
	e1:SetTargetRange(LOCATION_MZONE,0) 
	e1:SetTarget(function(e,c) 
	return c:IsType(TYPE_SPIRIT) end) 
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2) 
	--xx
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_HAND) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,79014036) 
	e3:SetCondition(c79014036.xxcon) 
	e3:SetTarget(c79014036.xxtg)   
	e3:SetOperation(c79014036.xxop) 
	c:RegisterEffect(e3)   
end 
function c79014036.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c79014036.cfilter1(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevel(4) and c:IsAbleToDeckAsCost()
end
function c79014036.cfilter2(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) 
end
function c79014036.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c79014036.cfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c79014036.cfilter2,tp,LOCATION_EXTRA,0,nil)
	local select=2
	if g1:GetCount()>0 and g2:GetCount()>=3 then
		select=Duel.SelectOption(tp,aux.Stringid(79014036,0),aux.Stringid(79014036,1),aux.Stringid(79014036,2))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(79014036,0),aux.Stringid(79014036,2))
		if select==1 then select=2 end
	elseif g2:GetCount()>=3 then
		select=Duel.SelectOption(tp,aux.Stringid(79014036,1),aux.Stringid(79014036,2))+1
	else
		select=Duel.SelectOption(tp,aux.Stringid(79014036,2))
		select=2
	end
	if select==0 then 
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	elseif select==1 then 
		local g=g2:RandomSelect(tp,3)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c79014036.ckfil(c) 
	return c:IsFaceup() and c:IsCode(79014030) 
end 
function c79014036.accon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c79014036.ckfil,tp,LOCATION_MZONE,0,1,nil)
end 
function c79014036.atkfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) 
end 
function c79014036.atkval(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroup(c79014036.atkfil,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetAttribute)*500   
end 
function c79014036.xckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLevel(4) and c:IsType(TYPE_SPIRIT)	
end 
function c79014036.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79014036.xckfil,1,nil,tp)  
end 
function c79014036.pbfil(c) 
	return c:IsType(TYPE_SPIRIT) and not c:IsPublic() 
end 
function c79014036.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79014036.pbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c79014036.pbfil,tp,LOCATION_HAND,0,1,99,nil)
	Duel.ConfirmCards(1-tp,g) 
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SetTargetParam(g:GetCount()*500) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetCount()*500)
end 
function c79014036.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM) 
	Duel.Recover(tp,d,REASON_EFFECT) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e1:SetLabel(Duel.GetTurnCount()) 
	e1:SetLabelObject(e:GetLabelObject()) 
	e1:SetCountLimit(1) 
	e1:SetCondition(c79014036.xsumcon) 
	e1:SetOperation(c79014036.xsumop) 
	e1:SetReset(RESET_PHASE+PHASE_END,2) 
	Duel.RegisterEffect(e1,tp)
end 
function c79014036.xsumfil(c,att) 
	return c:IsSummonable(true,nil) and c:IsType(TYPE_SPIRIT) and c:IsLevel(4) and not c:IsAttribute(att)  
end 
function c79014036.xsumcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=e:GetLabelObject() 
	local att=0 
	local tc=g:GetFirst() 
	while tc do 
	if tc:IsAttribute(ATTRIBUTE_DARK) then att=bit.bor(att,ATTRIBUTE_DARK) end 
	if tc:IsAttribute(ATTRIBUTE_DIVINE) then att=bit.bor(att,ATTRIBUTE_DIVINE) end 
	if tc:IsAttribute(ATTRIBUTE_EARTH) then att=bit.bor(att,ATTRIBUTE_EARTH) end 
	if tc:IsAttribute(ATTRIBUTE_FIRE) then att=bit.bor(att,ATTRIBUTE_FIRE) end 
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then att=bit.bor(att,ATTRIBUTE_LIGHT) end 
	if tc:IsAttribute(ATTRIBUTE_WATER) then att=bit.bor(att,ATTRIBUTE_WATER) end
	if tc:IsAttribute(ATTRIBUTE_WIND) then att=bit.bor(att,ATTRIBUTE_WIND) end  
	tc=g:GetNext() 
	end 
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.IsExistingMatchingCard(c79014036.xsumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,att) 
end 
function c79014036.xsumop(e,tp,eg,ep,ev,re,r,rp) 
	local g=e:GetLabelObject() 
	local att=0 
	local tc=g:GetFirst() 
	while tc do 
	if tc:IsAttribute(ATTRIBUTE_DARK) then att=bit.bor(att,ATTRIBUTE_DARK) end 
	if tc:IsAttribute(ATTRIBUTE_DIVINE) then att=bit.bor(att,ATTRIBUTE_DIVINE) end 
	if tc:IsAttribute(ATTRIBUTE_EARTH) then att=bit.bor(att,ATTRIBUTE_EARTH) end 
	if tc:IsAttribute(ATTRIBUTE_FIRE) then att=bit.bor(att,ATTRIBUTE_FIRE) end 
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then att=bit.bor(att,ATTRIBUTE_LIGHT) end 
	if tc:IsAttribute(ATTRIBUTE_WATER) then att=bit.bor(att,ATTRIBUTE_WATER) end
	if tc:IsAttribute(ATTRIBUTE_WIND) then att=bit.bor(att,ATTRIBUTE_WIND) end  
	tc=g:GetNext() 
	end 
	if Duel.SelectYesNo(tp,aux.Stringid(79014036,3)) then 
	Duel.Hint(HINT_CARD,0,79014036) 
	local sc=Duel.SelectMatchingCard(tp,c79014036.xsumfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,att):GetFirst() 
	Duel.Summon(tp,sc,true,nil) 
	end 
end 





