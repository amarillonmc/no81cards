--魔神仪的喧闹
function c98921029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921029)
	e1:SetTarget(c98921029.target)
	e1:SetOperation(c98921029.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921029,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98921029)
	e2:SetCondition(c98921029.setcon)
	e2:SetTarget(c98921029.settg)
	e2:SetOperation(c98921029.setop)
	c:RegisterEffect(e2)
end
function c98921029.thfilter(c,e,tp)
	return c:IsSetCard(0x117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98921029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE,tp)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	local g=Duel.GetMatchingGroup(c98921029.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 and ft1>0 and ft2>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98921029.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	local g=Duel.GetMatchingGroup(c98921029.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98921029,1))
		local cg=sg:FilterSelect(tp,c98921029.spsumfilter1,1,1,nil,e,tp)
		local tc1=cg:GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		tc1:RegisterFlagEffect(98921029,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		sg:RemoveCard(tc1)
		local tc2=sg:GetFirst()
		Duel.SpecialSummonStep(tc2,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
		tc2:RegisterFlagEffect(98921029,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c98921029.retcon)
		e1:SetOperation(c98921029.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetLabelObject(tc2)
		Duel.RegisterEffect(e2,tp)
	end
end
function c98921029.spsumfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c98921029.spsumfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c98921029.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(98921029)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c98921029.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c98921029.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c98921029.tdfilter(c)
	return c:IsSetCard(0x117) and c:IsLevelAbove(0) and c:IsAbleToDeck()
end
function c98921029.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98921029.cfilter,1,nil,tp)
end
function c98921029.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c98921029.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c98921029.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c98921029.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(c)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==2 then
		local atk=g:GetSum(Card.GetLevel)
		local lg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local tc=lg:GetFirst()
		while tc do
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_UPDATE_ATTACK)
		   e1:SetValue(-atk*100)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   tc=lg:GetNext()
	   end
	end
end