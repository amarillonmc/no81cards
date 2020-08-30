local m=82228600
local cm=_G["c"..m]
cm.name="八荒"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(cm.target)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)
	--cannot release  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_RELEASE)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetTargetRange(0,1)  
	e3:SetTarget(cm.target)  
	c:RegisterEffect(e3)  
	--draw   
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCountLimit(1,m)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e4:SetCode(EVENT_CHAIN_SOLVING) 
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCondition(cm.drcon)  
	e4:SetTarget(cm.drtg)  
	e4:SetOperation(cm.drop)  
	c:RegisterEffect(e4)  
	--to deck  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))  
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e5:SetRange(LOCATION_GRAVE)  
	e5:SetCountLimit(1,82218600)  
	e5:SetTarget(cm.tdtg)  
	e5:SetOperation(cm.tdop)  
	c:RegisterEffect(e5)   
end
function cm.target(e,c)  
	return c:IsSetCard(0x2299) and c:IsType(TYPE_XYZ) and c:GetControler()==e:GetHandler():GetControler()
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)   
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x2299)
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp,chk)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x2299) and c:IsAbleToDeck()  
end  
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end  
	if chk==0 then return e:GetHandler():IsAbleToDeck()  
		and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)  
end  
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then  
		Duel.SendtoHand(c,nil,REASON_EFFECT)  
	end  
end  