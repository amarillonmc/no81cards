-- 新昼地的瞭望
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320352)
    s.tohand(c)
	s.spsummon(c)
end
function s.tohand(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsSetCard(0x5c17) and not c:IsCode(47320351) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
    if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,47320352) then
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if #sg<3 then return end
	Duel.ConfirmCards(1-tp,sg)
	local tg=sg:RandomSelect(1-tp,1)
	if tg and #tg>0 then
		Duel.SendtoHand(tg,tp,REASON_EFFECT)
		sg:Sub(tg)
	end
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,47320352) then
		local dg=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,47320352)
		if #dg>0 then
			Duel.SendtoGrave(dg,REASON_EFFECT)
		end
	end
end
function s.spsummon(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spfilter(c)
	return c:GetSequence()<5
end
function s.ofilter(c)
	return c:IsSetCard(0x5c17) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil) and Duel.IsExistingMatchingCard(s.ofilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.spfilter2(c,e,tp,sp)
	if not c:IsCode(47320352) then return false end
	local fl=false
	if sp&1~=0 then
		fl=c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP,tp)
	end
	if sp&2~=0 then
		fl=fl or c:IsCanBeSpecialSummoned(e,0,tp,false,true,POS_FACEUP,1-tp)
	end
	return fl
end
function s.getzone(g,tp)
	local szone=0
	local ozone=0
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq<5 then
			if tc:IsControler(tp) then
				szone=szone|(1<<seq)
			else
				ozone=ozone|(1<<seq)
			end
		end
	end
	return szone,ozone
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sp=0
	for tc in aux.Next(eg) do
		if tc:GetSequence()<5 then
			local p=tc:GetControler()
			if tp==p then
				sp=sp|1
			else
				sp=sp|2
			end
		end
	end
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter2(chkc,e,tp,sp) end
	if chk==0 then return sp>0 and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,sp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sp)
	local szone,ozone=s.getzone(eg,tp)
	e:SetLabel(szone,ozone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local szone,ozone=e:GetLabel()
	local oflag=ozone<<16
	local sflag=szone
	local zone=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xffffffff-oflag-sflag,47320352)
	local p=tp
	if zone>(1<<16) then
		p=1-tp
		zone=zone>>16
	end
	local seq=math.log(zone,2)
	local pc=Duel.GetFieldCard(p,LOCATION_MZONE,seq)
	if pc then
		Duel.Destroy(pc,REASON_RULE)
	end
	Duel.SpecialSummon(tc,0,tp,p,false,true,POS_FACEUP,zone)
end