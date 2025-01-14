--飞球造物·能量
local m=13254052
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.thcost1)
	e3:SetTarget(cm.thtg1)
	e3:SetOperation(cm.thop1)
	c:RegisterEffect(e3)
	elements={{"tama_elements",{{TAMA_ELEMENT_ENERGY,2}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local el={{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_ORDER,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local el={{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_ORDER,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.filter(c)
	return c:IsAbleToDeck()
end
function cm.conditon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ENERGY,4}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.thfilter1(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x356) and c:IsAbleToHand()
end
function cm.thtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
