local m=82228572
local cm=_G["c"..m]
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetTarget(cm.target)
	e1:SetCondition(cm.con)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()   
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)   
	c:RegisterEffect(e2)  
	local e3=e1:Clone()   
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e3:SetTarget(cm.target2)  
	e3:SetOperation(cm.activate2)  
	c:RegisterEffect(e3)  
	--to hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_TO_GRAVE)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCondition(cm.thcon)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)   
end  
function cm.cfilter(c)  
	return c:IsCode(82228562)  
end  
function cm.con(c,e,tp)   
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)  
end 
function cm.filter(c,tp,ep)  
	return c:IsLocation(LOCATION_MZONE) and ep~=tp and c:IsAbleToRemove()  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=eg:GetFirst()  
	if chk==0 then return cm.filter(tc,tp,ep) end  
	Duel.SetTargetCard(eg)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=eg:GetFirst()  
	if tc and tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)  
	end  
end  
function cm.filter2(c,tp)  
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp  
		and c:IsAbleToRemove()  
end  
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(cm.filter2,1,nil,tp) end  
	local g=eg:Filter(cm.filter2,nil,tp)  
	Duel.SetTargetCard(eg)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)  
end  
function cm.filter3(c,e,tp)  
	return c:GetSummonPlayer()~=tp  
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)  
end  
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)  
	local g=eg:Filter(cm.filter3,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)  
	end  
end  
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x297) and not c:IsCode(m) and c:IsAbleToHand() and not c:IsType(TYPE_MONSTER) 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  