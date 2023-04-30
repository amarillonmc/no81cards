local m=82204259
local cm=_G["c"..m]
cm.name="小红帽「契约师」"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	--atkup  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(cm.val)  
	c:RegisterEffect(e1)  
	--draw  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.drcost)  
	e3:SetTarget(cm.drtg)  
	e3:SetOperation(cm.drop)  
	c:RegisterEffect(e3)  
end
cm.SetCard_01_RedHat=true 
function cm.matfilter(c)
	return c.SetCard_01_RedHat and (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)))
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function cm.val(e,c)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*500  
end  
function cm.atkfilter(c)  
	return c:IsFaceup() and c.SetCard_01_RedHat
end  
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,1500) end  
	Duel.PayLPCost(tp,1500)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetDecktopGroup(tp,1):FilterCount(Card.IsAbleToRemove,nil)==1 end  
	local rg=Duel.GetDecktopGroup(tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,1,0,0) 
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_REMOVED)  
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)  
		e1:SetCountLimit(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)  
		e1:SetCondition(cm.thcon)  
		e1:SetOperation(cm.thop)  
		e1:SetLabel(0)  
		tc:RegisterEffect(e1) 
	end
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetTurnPlayer()==tp  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)  
	Duel.ConfirmCards(1-tp,e:GetHandler())  
end  