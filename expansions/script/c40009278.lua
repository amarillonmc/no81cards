--超整重机动
function c40009278.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009278,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCountLimit(1,40009278)
	e1:SetCost(c40009278.thcost)
	e1:SetTarget(c40009278.thtg)
	e1:SetOperation(c40009278.thop)
	c:RegisterEffect(e1)   
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009278,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,40009279)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c40009278.settg)
	e3:SetOperation(c40009278.setop)
	c:RegisterEffect(e3) 
end
function c40009278.cfilter(c,e,tp)
	return c:IsSetCard(0x127) and c:GetOriginalLevel()>0 and c:IsAbleToGraveAsCost()  
end
function c40009278.filter(c,e,tp)
	local rg=Duel.GetMatchingGroup(c40009278.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,c)
	local rk=c:GetRank()
	return rk>0 and c:IsSetCard(0x127) and rg:CheckWithSumEqual(Card.GetLevel,rk,1,99) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009278.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c40009278.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c40009278.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		end
	local rg=Duel.GetMatchingGroup(c40009278.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(c40009278.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local lvt={}
	local pc=1
	for i=5,9 do
		if g:IsExists(c40009278.thfilter,1,nil,e,tp,i) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local rk=Duel.AnnounceNumber(tp,table.unpack(lvt))
	aux.GCheckAdditional=aux.dncheck
	local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,rk,1,2)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(rk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c40009278.thfilter(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c40009278.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009278.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		if  c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
function c40009278.setfilter(c)
	return c:IsCode(34721681,88667504) and c:IsSSetable()
end
function c40009278.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009278.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c40009278.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009278.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end




