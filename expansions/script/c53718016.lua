local m=53718016
local cm=_G["c"..m]
cm.name="太平要术-体"
function cm.initial_effect(c)
	aux.AddCodeList(c,53718001)
	aux.AddCodeList(c,53718002)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.filter(c,ft,e,tp)
	return aux.IsCodeListed(c,53718001) and aux.IsCodeListed(c,53718002) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,ft,e,tp)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		local ct1=0
		local ct2=0
		if op==0 then
			ct1=Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			ct2=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		if ct1+ct2>0 then
			local rg=Duel.GetDecktopGroup(1-tp,2)
			if rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==2
				and Duel.IsExistingMatchingCard(function(c)return c:IsFaceup() and c:IsSetCard(0x653c)end,tp,LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.BreakEffect()
				Duel.DisableShuffleCheck()
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(53718001,53718002)
end
function cm.setfilter(c)
	return c:IsSetCard(0x953c) and not c:IsCode(m) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then Duel.SSet(tp,g) end
end
