--永夏的花海
function c9910970.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910970+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910970.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910970,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910981)
	e2:SetTarget(c9910970.cttg)
	e2:SetOperation(c9910970.ctop)
	c:RegisterEffect(e2)
end
function c9910970.filter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToGrave()
end
function c9910970.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910970.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910970,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9910970.tgfilter(c,e,tp,chk)
	local b1=c:IsCanAddCounter(0x6954,1)
	local b2=c:IsCanRemoveCounter(tp,0x6954,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1)
	return c:IsCanHaveCounter(0x6954) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
		and c:IsCanBeEffectTarget(e) and (chk or b1 or b2)
end
function c9910970.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c9910970.tgfilter(chkc,e,tp,true) end
	local g=eg:Filter(c9910970.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 end
	local tc=nil
	if g:GetCount()==1 then
		tc=g:GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.SetTargetCard(tc)
	local b1=tc:IsCanAddCounter(0x6954,1)
	local b2=tc:IsCanRemoveCounter(tp,0x6954,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910970,2),aux.Stringid(9910970,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910970,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910970,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_COUNTER)
	else
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c9910970.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 and tc:IsCanAddCounter(0x6954,1) then
		tc:AddCounter(0x6954,1)
	end
	if e:GetLabel()==1 and tc:RemoveCounter(tp,0x6954,1,REASON_EFFECT) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
