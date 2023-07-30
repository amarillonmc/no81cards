local m=82204258
local cm=_G["c"..m]
cm.name="小红帽「药剂师」"
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
	--search  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_TOHAND)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,m)   
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)
end
cm.SetCard_01_RedHat=true 
function cm.isRedHat(c)
	local code=c:GetCode()
	local ccode=_G["c"..code]
	return ccode.SetCard_01_RedHat
end
function cm.matfilter(c)
	return cm.isRedHat(c) and (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)))
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function cm.val(e,c)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*500  
end  
function cm.atkfilter(c)  
	return c:IsFaceup() and cm.isRedHat(c)
end  
function cm.thfilter(c)  
	return cm.isRedHat(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)  
	if #g>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  