local m=82204263
local cm=_G["c"..m]
cm.name="充能棒"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--draw  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DRAW)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,m) 
	e2:SetCondition(cm.drcon)
	e2:SetTarget(cm.drtg)  
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_RedHat=true 
function cm.isRedHat(c)
	local code=c:GetCode()
	local ccode=_G["c"..code]
	return ccode.SetCard_01_RedHat
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	e:SetLabel(0)  
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end  
	return true
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ct=1
	if e:GetLabel()==1 then
		ct=2
	end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) and Duel.IsPlayerCanDraw(1-tp,1) end   
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local ct=1
	if e:GetLabel()==1 then
		ct=2
	end 
	Duel.Draw(tp,ct,REASON_EFFECT) 
	Duel.Draw(1-tp,1,REASON_EFFECT) 
end  