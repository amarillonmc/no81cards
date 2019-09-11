--URBEX HINDER-蛰伏者
function c65010514.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c65010514.lcheck)
	c:EnableReviveLimit()
	--tod+dr
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65010514)
	e1:SetTarget(c65010514.tg)
	e1:SetOperation(c65010514.op)
	c:RegisterEffect(e1)
end
c65010514.setname="URBEX"
function c65010514.lcfil(c)
	return c.setname=="URBEX"
end
function c65010514.lcheck(g)
	return g:IsExists(c65010514.lcfil,1,nil) 
end
function c65010514.tgfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65010514.lafil(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==1-tp
end
function c65010514.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local m=0
	if Duel.IsExistingMatchingCard(c65010514.lafil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) then m=1 end
	e:SetLabel(m)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c65010514.tgfil,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.SelectTarget(tp,c65010514.tgfil,tp,LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65010514.spfil(c,e,tp,s)
	return c:IsType(TYPE_LINK) and c:GetLink()<=s and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) or (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0)) and c.setname=="URBEX"
end
function c65010514.op(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local s=sg:GetCount()
	if s>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)==s then
		Duel.Draw(tp,1,REASON_EFFECT)
		if m==1 and Duel.IsExistingMatchingCard(c65010514.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,s) and Duel.SelectYesNo(tp,aux.Stringid(65010514,0)) then
			while s~=0 do
				local mg=Duel.SelectMatchingCard(tp,c65010514.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,s)
				Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
				if Duel.GetMatchingGroupCount(c65010514.spfil,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp,s)==0 then return end
				if Duel.SelectYesNo(tp,aux.Stringid(65010514,1)) then return end
				s=s-mg:GetFirst():GetLink()
			end
		end
	end
end