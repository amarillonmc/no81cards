--神工之折纸使
function c9910023.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c9910023.lcheck)
	c:EnableReviveLimit()
	--sort
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910023,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910023.stcon)
	e1:SetTarget(c9910023.sttg)
	e1:SetOperation(c9910023.stop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910023.tdcon1)
	e2:SetTarget(c9910023.tdtg)
	e2:SetOperation(c9910023.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c9910023.tdcon2)
	c:RegisterEffect(e3)
end
function c9910023.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9910026)
		or not e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x5950)
end
function c9910023.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9910026)
		and e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x5950)
end
function c9910023.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3950) and not g:IsExists(Card.IsCode,1,nil,9910023)
end
function c9910023.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910023.mfilter(c)
	return c:IsSetCard(0x3950) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9910023.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=0
	local g=Duel.GetMatchingGroup(c9910023.mfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local tc=g:GetFirst()
	while tc do
		if tc then
			local mg=tc:GetMaterial():Filter(Card.IsType,nil,TYPE_PENDULUM)
			ct=ct+mg:GetCount()
		end
		tc=g:GetNext()
	end
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c9910023.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	local ct=0
	local g=Duel.GetMatchingGroup(c9910023.mfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local tc=g:GetFirst()
	while tc do
		if tc then
			local mg=tc:GetMaterial():Filter(Card.IsType,nil,TYPE_PENDULUM)
			ct=ct+mg:GetCount()
		end
		tc=g:GetNext()
	end
	if ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		local ctt={}
		local ctp=1
		while Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ctp and ct>=ctp do
			ctt[ctp]=ctp
			ctp=ctp+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910023,1))
		local stcount=Duel.AnnounceNumber(tp,table.unpack(ctt))
		Duel.SortDecktop(tp,1-tp,stcount)
	end
end
function c9910023.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910023.tdfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x3950) or c:IsSetCard(0x5950))
		and (c:IsAbleToDeck() or Duel.IsExistingMatchingCard(c9910023.xfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c9910023.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9910023.tdfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910023.tdfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c9910023.tdfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c9910023.locfilter(c,sp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(sp)
end
function c9910023.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if not Duel.IsExistingTarget(c9910023.xfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	else
		if tg:FilterCount(Card.IsAbleToDeck,nil)==2
			and Duel.SelectOption(tp,aux.Stringid(9910023,2),aux.Stringid(9910023,3))==0 then
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,c9910023.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
			local sc=sg:GetFirst()
			Duel.Overlay(sc,tg)
		end
	end
	local ct=Duel.GetOperatedGroup():FilterCount(c9910023.locfilter,nil,tp)
	if ct<=0 then return end
	Duel.ShuffleDeck(tp)
	if ct~=2 then return end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
