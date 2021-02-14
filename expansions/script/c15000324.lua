local m=15000324
local cm=_G["c"..m]
cm.name="内核删除 伊洛杰菲"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,15000324)   
	e1:SetCost(cm.cost)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1) 
	--Draw
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DRAW)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_TO_GRAVE)  
	e2:SetCountLimit(1,15010324)  
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DESTROYED) 
	e3:SetCondition(cm.spcon2)  
	c:RegisterEffect(e3) 
end  
function cm.cfilter(c)  
	return c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost() and c:IsAttribute(ATTRIBUTE_DARK)
end  
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())  
	Duel.SendtoGrave(g,REASON_COST)  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end  
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:GetHandler():IsSetCard(0xf39) and Duel.IsPlayerCanDraw(tp,1)
end  
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()  
	return (e:GetHandler():IsReason(REASON_BATTLE) or e:GetHandler():IsReason(REASON_EFFECT)) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerAffectedByEffect(tp,15000330)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end