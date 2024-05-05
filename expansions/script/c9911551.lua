--紫炎蔷薇响彻舞台
dofile("expansions/script/c9911550.lua")
function c9911551.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911551,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+9911551)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,9911551)
	e3:SetTarget(c9911551.thtg)
	e3:SetOperation(c9911551.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(9911551,1))
	e4:SetCode(EVENT_CUSTOM+9911552)
	e4:SetTarget(c9911551.thtg2)
	c:RegisterEffect(e4)
	QutryZyqw.RegisterMergedDelayedEvent(c,9911551,EVENT_SPSUMMON_SUCCESS)
end
function c9911551.cfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911551.fselect(g,tp)
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	if lv1>lv2 then lv1,lv2=lv2,lv1 end
	return lv2-lv1>1 and Duel.IsExistingMatchingCard(c9911551.thfilter,tp,LOCATION_DECK,0,1,nil,lv1,lv2)
end
function c9911551.thfilter(c,lv1,lv2)
	return c:IsType(TYPE_PENDULUM) and c:GetLevel()>lv1 and c:GetLevel()<lv2 and c:IsAbleToHand()
end
function c9911551.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Clone()
	if chk==0 then
		if #g==0 then return false end
		g=g:Filter(c9911551.cfilter,nil,e)
		return g:CheckSubGroup(c9911551.fselect,2,2,tp)
	end
	g=g:Filter(c9911551.cfilter,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911551.fselect,false,2,2,tp)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911551.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(function(c) return c:GetFlagEffect(9911551)==0 end,nil)
	if chk==0 then
		if #g==0 or not g:IsExists(function(c) return c:GetFlagEffect(9911550)>0 end,1,nil) then return false end
		g=g:Filter(c9911551.cfilter,nil,e)
		return g:CheckSubGroup(c9911551.fselect,2,2,tp)
	end
	g=g:Filter(c9911551.cfilter,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911551.fselect,false,2,2,tp)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911551.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911551.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911551.cfilter2,nil,e)
	if #g~=2 then return end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	if lv1>lv2 then lv1,lv2=lv2,lv1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c9911551.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv1,lv2)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
