local m=53721011
local cm=_G["c"..m]
cm.name="深海禁处 悚牢"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_SEASERPENT) and c:IsType(TYPE_TUNER) and (c:IsAbleToHand() and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(cm.activate)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsRelateToEffect(e) then
		local th=tc:IsAbleToHand()
		local sp=ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return tc:IsControler(tp) and tc:IsAttribute(ATTRIBUTE_WATER) and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local sg=g:Select(tp,1,3,nil)
		for tc in aux.Next(sg) do
			Duel.MoveSequence(tc,0)
		end
		Duel.SortDecktop(tp,tp,#sg)
		for i=1,#sg do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end
