--炭酸装姬·怪能
function c11526308.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(c11526308.turnerfilter),nil,nil,aux.FilterBoolFunction(aux.TRUE),1,99)
	c:EnableReviveLimit()

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,11526308)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11526308.condition)
	e1:SetTarget(c11526308.target)
	e1:SetOperation(c11526308.activate)
	c:RegisterEffect(e1)	
end
c11526308.SetCard_Carbonic_Acid_Girl=true 
--
function c11526308.turnerfilter(c)
	return c.SetCard_Carbonic_Acid_Girl
end

--
function c11526308.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Duel.GetCurrentChain()>=3
end
function c11526308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c11526308.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev)~=0 then
		local card=0
		local dg=Group.CreateGroup()
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp==tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and te:GetHandler().SetCard_Carbonic_Acid_Girl then
				local tc=te:GetHandler()
				card=card+1
			end
		end 
		if Duel.IsExistingMatchingCard(c11526308.spfilter,tp,LOCATION_GRAVE,0,card,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>card-1 and not (card>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) and Duel.SelectYesNo(tp,aux.Stringid(11526308,2)) then
			local gg=Duel.GetFieldGroup(c11526308.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
			if gg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,c11526308.spfilter,tp,LOCATION_GRAVE,0,card,card,nil,e,tp)
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end  
		end
	end
end

function c11526308.spfilter(c,e,tp)
	return c.SetCard_Carbonic_Acid_Girl and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end