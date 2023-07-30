--药剂师学徒 兰
local m=11631007
local cm=_G["c"..m]
--strings
cm.yaojishi=true 
function cm.isYaojishi(card)  
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.yaojishi
end
function cm.isZhiyaoshu(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.zhiyaoshu
end
function cm.isTezhiyao(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.tezhiyao
end



function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.spcon)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--draw  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m+1) 
	e2:SetTarget(cm.drtg)  
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2)  
	--activate from hand  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTarget(cm.actfilter)  
	e4:SetTargetRange(LOCATION_HAND,0)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EFFECT_TRAP_ACT_IN_HAND)  
	c:RegisterEffect(e5) 
end

--spsummon
function cm.spfilter(c)
	return cm.isYaojishi(c) and c:IsFaceup() and not c:IsCode(m)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  

--draw
function cm.tdfilter(c)  
	return (cm.isYaojishi(c) or cm.isZhiyaoshu(c) or cm.isTezhiyao(c)) and c:IsAbleToDeck()  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) end  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)  
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	if tg:GetCount()==0 then return end  
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)  
	local g=Duel.GetOperatedGroup()  
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end  
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)  
	if ct>0 and Duel.IsPlayerCanDraw(tp,1) then  
		Duel.BreakEffect()  
		Duel.Draw(tp,1,REASON_EFFECT)  
	end  
end  

--act in hand
function cm.actfilter(e,c)
	return cm.isTezhiyao(c) and c:IsPublic()
end