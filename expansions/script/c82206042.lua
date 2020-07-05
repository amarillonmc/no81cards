local m=82206042
local cm=_G["c"..m]
cm.name="植占师22-炸弹"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x129d),2,2,cm.lcheck) 
	c:EnableReviveLimit() 
	--set
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.setcon)  
	e1:SetTarget(cm.settg)  
	e1:SetOperation(cm.setop)  
	c:RegisterEffect(e1) 
	--draw  
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(m,1)) 
	e2:SetCategory(CATEGORY_DRAW)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e2:SetCode(EVENT_RECOVER)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCountLimit(1,82216042)  
	e2:SetCondition(cm.drcon)  
	e2:SetTarget(cm.drtg)  
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2)  
	--destroy  
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCountLimit(1,82226042)  
	e3:SetCondition(cm.descon)  
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)  
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()  
end  
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.setfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x129d) and not c:IsForbidden()  
end  
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500) 
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			Duel.Recover(tp,500,REASON_EFFECT)  
		end
	end  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==tp  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function cm.descfilter(c,lg)  
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and lg:IsContains(c)  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	local lg=e:GetHandler():GetLinkedGroup()  
	return eg:IsExists(cm.descfilter,1,nil,lg)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() end  
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,PLAYER_ALL,LOCATION_ONFIELD)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  