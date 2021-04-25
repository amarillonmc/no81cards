local m=82204238
local cm=_G["c"..m]
cm.name="虚妄灵域"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--destroy
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCode(EVENT_CHANGE_POS) 
	e2:SetCondition(cm.descon) 
	e2:SetCountLimit(1,m)  
	e2:SetTarget(cm.destg)  
	e2:SetOperation(cm.desop) 
	c:RegisterEffect(e2)  
	--draw
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_DRAW)  
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)  
	e3:SetCode(EVENT_CHANGE_POS) 
	e3:SetCondition(cm.drcon) 
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.drtg)  
	e3:SetOperation(cm.drop) 
	c:RegisterEffect(e3)  
end
function cm.cfilter1(c,tp)  
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() and c:IsControler(tp)  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.cfilter1,1,nil,tp)  
end  
function cm.desfilter(c)  
	return c:IsFacedown()
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(cm.desfilter,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	if ct>0 and g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local dg=g:Select(tp,1,ct,nil)  
		Duel.HintSelection(dg)  
		Duel.Destroy(dg,REASON_EFFECT)  
	end  
end  
function cm.cfilter2(c,tp)  
	return c:IsPreviousPosition(POS_FACEDOWN) and c:IsFaceup() and c:IsControler(tp)  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.cfilter2,1,nil,tp)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp,chk)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  