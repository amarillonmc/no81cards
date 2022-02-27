--珊海环门
function c67200530.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200530+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200530.cost)
	e1:SetTarget(c67200530.target)
	e1:SetOperation(c67200530.activate)
	c:RegisterEffect(e1)
end
function c67200530.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c67200530.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x675) and c:IsAbleToGraveAsCost()
end
function c67200530.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x675) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200530.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(c67200530.cfilter,tp,LOCATION_DECK,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cg:GetCount()>0
			and Duel.IsExistingMatchingCard(c67200530.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,cg:GetClassCount(Card.GetCode))
	end
	local cg=Duel.GetMatchingGroup(c67200530.cfilter,tp,LOCATION_DECK,0,nil)
	local ct=cg:GetClassCount(Card.GetCode)
	local tg=Duel.GetMatchingGroup(c67200530.spfilter,tp,LOCATION_DECK,0,nil,e,tp,ct)
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200530,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=aux.dncheck
	local rg=cg:SelectSubGroup(tp,aux.TRUE,false,lv,lv)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(rg,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c67200530.spfilter2(c,e,tp,lv)
	return c:IsSetCard(0x675) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200530.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67200530.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		tc:RegisterFlagEffect(67200530,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c67200530.descon)
		e1:SetOperation(c67200530.desop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SpecialSummonComplete()
end
function c67200530.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(67200530)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c67200530.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
