local m=15000081
local cm=_G["c"..m]
cm.name="廷达魔三角之游曳者"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)  
	c:EnableReviveLimit()
	--remove  
	local e1=Effect.CreateEffect(c)   
	e1:SetCategory(CATEGORY_TOGRAVE)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.rmtg)  
	e1:SetOperation(cm.rmop)  
	c:RegisterEffect(e1)
	--actlimit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetCondition(cm.actcon)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)  
	return g:IsExists(cm.hspfilter,1,nil)  
end
function cm.hspfilter(c)
	return c:IsLinkSetCard(0x10b) and not c:IsLinkCode(15000081)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandlerPlayer()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_REMOVED,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_REMOVED,0,1,2,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,LOCATION_REMOVED)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)   
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)~=0 then
		local tc=g:GetFirst()
		local ag=Group.CreateGroup()
		while tc do
			if not tc:IsSetCard(0x10b) then ag:AddCard(tc) end
			tc=g:GetNext()
		end
		if ag:GetCount()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>=0 and Duel.SelectYesNo(tp,aux.Stringid(15000081,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)  
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)  
			local nseq=math.log(s,2)  
			Duel.MoveSequence(e:GetHandler(),nseq)
		end
	end  
end
function cm.cfilter(c,tp)  
	return c:IsSetCard(0x10b) and c:IsFaceup() and c:IsControler(tp)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)   
	local tp=e:GetHandlerPlayer() 
	local a=Duel.GetAttacker()  
	local d=Duel.GetAttackTarget()  
	return ((a and cm.cfilter(a,tp)) or (d and cm.cfilter(d,tp))) and e:GetHandler():GetLinkedGroup():FilterCount(cm.cfilter,nil)==2
end