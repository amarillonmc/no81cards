--动物朋友 小包EX
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m=33701353
local cm=_G["c"..m]
function c33701353.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsCode,33700055),1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,cm.sprcon,cm.sprop)
	
end
function cm.spcfilter(c,tp)
	return c:IsAbleToDeckAsCost() and c:IsCode(33700055)
end
function cm.spzfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.sprcon(e,c,tp)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	return g:IsExists(cm.spzfilter,1,nil,tp)
end
function cm.sprop(e,tp)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sg=g:SelectSubGroup(tp,cm.spzfilter,false,1,1,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,0,0,0)
end
function cm.tgfilter(c)
	return c:IsSetCard(0x442)
end
function cm.regop(e,tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToGrave,nil)
	local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x442)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ConfirmCards(tp,g)
		if g:GetClassCount(Card.GetCode,nil)==g:GetCount() then
			g=g:Filter(cm.tgfilter,nil)
			if g1:GetCount()==0 and g:GetClassCount(Card.GetCode,nil)>=7 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:SelectSubGroup(tp,aux.dncheck,true,7,7)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			elseif g1:FilterCount(Card.IsAbleToDeck,nil)>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg=g1:FilterSelect(tp,Card.IsAbleToDeck,1,math.min(7,g:GetCount()),nil)
				Duel.DisableShuffleCheck()
				Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
				local g2=Duel.GetOperatedGroup()
				g2=g2:Filter(Card.IsLocation,nil,LOCATION_DECK)
				if g2:GetCount()>0 then
					local num=g2:GetCount()
					Duel.Recover(tp,500*num,REASON_EFFECT)
					Duel.SortDecktop(tp,tp,num)
				end
			end
		end
	end
end