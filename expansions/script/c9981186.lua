--Decade 全骑士VS大修卡
function c9981186.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981186,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1)
	e2:SetCondition(c9981186.spcon)
	e2:SetTarget(c9981186.sptg)
	e2:SetOperation(c9981186.spop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981186,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9981186.sptg2)
	e1:SetOperation(c9981186.spop2)
	c:RegisterEffect(e1)
end
function c9981186.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xbca)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
end
function c9981186.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c9981186.cfilter,nil,tp)
	e:SetLabel(ct)
	return ct>0
end
function c9981186.spfilter(c,e,tp)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981186.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981186.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981186.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>e:GetLabel() then ft=e:GetLabel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981186.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL+EFFECT_CANNOT_BE_XYZ_MATERIAL+EFFECT_CANNOT_BE_LINK_MATERIAL+EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(c9981186.synlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c9981186.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xbca)
end
function c9981186.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9981186.filter(c,e,tp,lv)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981186.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=math.min(3,Duel.GetMatchingGroupCount(c9981186.cfilter2,tp,LOCATION_GRAVE,0,nil))
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c9981186.filter,tp,LOCATION_DECK,0,1,nil,e,tp,ct)
	end
	local cg=Duel.GetMatchingGroup(c9981186.cfilter2,tp,LOCATION_GRAVE,0,nil)
	local ct=math.min(3,cg:GetCount())
	local tg=Duel.GetMatchingGroup(c9981186.filter,tp,LOCATION_DECK,0,nil,e,tp,ct)
	local lvt={}
	local pc=1
	for i=1,3 do
		if tg:IsExists(c9981186.sfilter,1,nil,i,e,tp) then lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9981186,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,lv,lv,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetParam(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981186.sfilter2(c,lv,e,tp)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_MONSTER) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981186.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981186.sfilter2,tp,LOCATION_DECK,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
