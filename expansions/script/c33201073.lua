--新老血液的交替
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)   
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(s.retg)
	e2:SetOperation(s.reop)
	c:RegisterEffect(e2)
end
s.VHisc_Vampire=true

--e1
function s.tdfilter(c)
	return c.VHisc_Vampire and c:IsAbleToDeck()
end
function s.tgfilter(c,tdg)
	return c.VHisc_Vampire and not tdg:IsExists(Card.IsCode,1,nil,c:GetCode()) and c:IsAbleToGrave()
end
function s.fselect1(g,tp)
	local tgg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil,g)
	return g:GetClassCount(Card.GetCode)==g:GetCount() and tgg:CheckSubGroup(s.fselect2,g:GetCount(),g:GetCount())
end
function s.fselect2(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.tdfilter(chkc) end
	if chk==0 then return g:CheckSubGroup(s.fselect1,1,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,s.fselect1,false,1,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,sg:GetCount(),0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local dg=g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	local tdc=dg:GetCount()
	local tgg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil,dg)
	if tdc>0 and tgg:CheckSubGroup(s.fselect2,dg:GetCount(),dg:GetCount()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=tgg:SelectSubGroup(tp,s.fselect2,false,dg:GetCount(),dg:GetCount())
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--e2
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end