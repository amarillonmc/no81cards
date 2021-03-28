--刻兽使·美舍基安
function c40008465.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c40008465.cost)
	e1:SetTarget(c40008465.target)
	e1:SetOperation(c40008465.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c40008465.sptg)
	e2:SetOperation(c40008465.spop)
	c:RegisterEffect(e2)
end
function c40008465.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c40008465.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,40008466,0xf17,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c40008465.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,40008466,0xf2,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,40008466)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c40008465.desfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xf17) 
end
function c40008465.spfilter(c,e,tp)
	return c:IsSetCard(0xf17) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008465.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(e:GetLabel()) and chkc:IsControler(tp) and chkc~=c and c40008465.desfilter1(chkc) end
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<-1 then return false end
		local loc=LOCATION_ONFIELD
		if ft==0 then loc=LOCATION_MZONE end
		e:SetLabel(loc)
		return Duel.IsExistingTarget(c40008465.desfilter1,tp,loc,0,1,c)
			and Duel.IsExistingMatchingCard(c40008465.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c40008465.desfilter1,tp,e:GetLabel(),0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c40008465.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c40008465.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()==0 then return end
		local sc=g:GetFirst()
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e3,true)
			local e2=e3:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			sc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
