--方舟骑士·徘徊黑伞 絮雨
function c82567891.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,82567891)
	e1:SetTarget(c82567891.adtg)
	e1:SetOperation(c82567891.adop)
	c:RegisterEffect(e1)
	--link summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,8257991)
	e5:SetTarget(c82567891.target)
	e5:SetOperation(c82567891.operation)
	c:RegisterEffect(e5)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetDescription(aux.Stringid(82567891,1))
	e3:SetCountLimit(1,82567984)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c82567891.rccon)
	e3:SetTarget(c82567891.rctg)
	e3:SetOperation(c82567891.rcop)
	c:RegisterEffect(e3)
end
function c82567891.adfilter(c)
	return c:IsFaceup() 
end
function c82567891.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(c82567891.adfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567891.adfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,1)
end
function c82567891.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
  then  tc:AddCounter(0x5825,1)
	local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e9)
	end
end
function c82567891.tgfilter(c,tp,ec)
	local lg=Duel.GetMatchingGroup(c82567891.adfilter,tp,LOCATION_MZONE,0,nil)
	local mg=Group.FromCards(c)
	mg:Merge(lg)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c82567891.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg) and c:GetCounter(0x5825)>0
end
function c82567891.tgfilter2(c,tp,ec)
	local lg=Duel.GetMatchingGroup(c82567891.adfilter,tp,LOCATION_MZONE,0,nil)
	local mg=Group.FromCards(c)
	mg:Merge(lg)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c82567891.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c82567891.lfilter(c,mg)
	return c:IsLinkSummonable(mg,nil,2,99)
end
function c82567891.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567891.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler()) or  Duel.IsExistingMatchingCard(c82567891.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567891.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c82567891.adfilter,tp,LOCATION_MZONE,0,nil,tp)
	local mg=Duel.GetMatchingGroup(c82567891.tgfilter,tp,0,LOCATION_MZONE,nil,tp)
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) then
		mg:Merge(lg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82567891.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.LinkSummon(tp,lc,mg,nil,2,99)
		end
	end
end
function c82567891.rccon(e)
	return e:GetHandler():GetSummonLocation()==LOCATION_GRAVE
end
function c82567891.rcfilter(c)
	return c:IsFaceup() and c:GetDefense()>0
end
function c82567891.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c82567891.rcfilter,tp,LOCATION_MZONE,0,1,nil) end
	 Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,nil)
end
function c82567891.rcop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c82567891.rcfilter,tp,LOCATION_MZONE,0,nil)
	local df=g:GetMaxGroup(Card.GetDefense)
	if df:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
	local val=df:GetFirst():GetDefense()
	Duel.Recover(tp,val,REASON_EFFECT)
	end
end