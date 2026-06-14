--火树银花
function c11182325.initial_effect(c)
	aux.AddCodeList(c,ATTRIBUTE_FIRE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11182325)
	e1:SetTarget(c11182325.destg)
	e1:SetOperation(c11182325.desop)
	c:RegisterEffect(e1)
	--special
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,11182325+1)
	e2:SetCondition(c11182325.dspcon)
	e2:SetTarget(c11182325.dsptg)
	e2:SetOperation(c11182325.dspop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e22)
end
function c11182325.dspcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc
	if c:IsReason(REASON_BATTLE) then tc=c:GetBattleTarget() end
	if c:IsReason(REASON_EFFECT+REASON_COST) then tc=re:GetHandler() end
	return tc and tc:IsSetCard(0x6454)
end
function c11182325.dspfilter(c,e,tp)
	return c:IsSetCard(0x6454) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11182325.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182325.dspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11182325.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11182325.dspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11182325.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
end
function c11182325.desop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	local b0=false
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182325 then
			b0=true
		end
	end
	local b1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>0
	local b2=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_MZONE,nil)>0 and b0
	local b3=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,0x6)>0 and b0
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(11182325,0)},{b2,aux.Stringid(11182325,1)},{b3,aux.Stringid(11182325,2)})
	if op==1 then
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,0x40)
	elseif op==2 then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		Duel.Destroy(g,0x40)
	elseif op==3 then
		local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,0x6)
		Duel.Destroy(g,0x40)
	end
end