local m=82204261
local cm=_G["c"..m]
cm.name="勇气旗帜"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--atkup  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5299))  
	e2:SetValue(500)  
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,2))  
	e3:SetCategory(CATEGORY_TOGRAVE)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.tgtg)  
	e3:SetOperation(cm.tgop)  
	c:RegisterEffect(e3)	
end
function cm.cfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x5299)
end  
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)  
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	Duel.Damage(p,Duel.GetFieldGroupCount(p,LOCATION_HAND,0)*400,REASON_EFFECT)  
end  
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)  
end  
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.SendtoGrave(g,REASON_EFFECT)  
	end  
end  