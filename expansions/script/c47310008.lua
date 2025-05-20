-- 面灵气 心的轮盘
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.change(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.chtg)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
end
function s.tdfilter(c,tp)
	if c:IsFacedown() or not c:IsSetCard(0x3c10) or not c:IsType(TYPE_EQUIP) or not c:IsAbleToDeck() then return false end
	local ec=c:GetEquipTarget()
	local code=c:GetCode()
	return Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK,0,1,nil,code,ec,tp)
end
function s.eqfilter(c,code)
	return c:IsSetCard(0x3c10) and c:IsType(TYPE_SPELL) and not c:IsCode(code)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
    if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,tp,LOCATION_SZONE)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		local tc2=tg:GetFirst()
		local flag=0
		local ec=tc:GetPreviousEquipTarget()
		if ec and tc2:IsType(TYPE_EQUIP) and Hnk.eqfilter(tc2,ec,tp) then
			if not tc2:IsAbleToHand() then
				flag=1
			elseif Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				flag=1
			end
		end
		if flag==0 then
			Duel.SendtoHand(tc2,tp,REASON_EFFECT)
		else
			Duel.Equip(tp,tc2,ec)
		end
	end
end
function s.initial_effect(c)
    s.change(c)
	Hata_no_Kokoro.steff2(c,id)
end
