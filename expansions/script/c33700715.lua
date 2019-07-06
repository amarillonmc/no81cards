--虚毒往生
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700715
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.tdfilter(c)
	return c:IsSetCard(0x144b) and c:IsAbleToDeck()
end
function cm.spfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x144b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsCanRemoveCounter(tp,1,1,0x144b,c:GetLevel(),REASON_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,3,nil) and Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	   Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,tp,LOCATION_GRAVE)
	   Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=0 then return end
	if e:GetLabel()==0 then
	   if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		  local og=Duel.GetOperatedGroup()
		  if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			 Duel.ShuffleDeck(tp)
		  end
		  Duel.Draw(tp,1,REASON_EFFECT)
	   end
	else
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.RemoveCounter(tp,1,1,0x144b,g:GetFirst():GetLevel(),REASON_EFFECT) then
		  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	   end
	end
end
