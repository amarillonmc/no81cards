local m=82224039
local cm=_G["c"..m]
cm.name="无限自由"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)  
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_IGNITION)	
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.descost)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop)  
	c:RegisterEffect(e2) 
	--pendulum  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e4:SetOperation(cm.penop)  
	c:RegisterEffect(e4)  
end
function cm.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM) and g:GetClassCount(Card.GetLinkCode)==g:GetCount() 
end 
function cm.penop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsSummonType(TYPE_LINK) then return end
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,0)  
	e2:SetValue(cm.pendvalue)  
	e2:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e2,tp)  
end 
function cm.pendvalue(e,c)  
	return true 
end 
function cm.cfilter(c,lg,tp)  
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsControler(tp)
		and lg:IsContains(c)
end  
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local lg=e:GetHandler():GetLinkedGroup()  
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,lg,tp) end  
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,lg,tp)  
	Duel.Release(g,REASON_COST)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  