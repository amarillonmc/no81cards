--炭酸装姬的邂逅
function c11526307.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11526307,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,11526307)
	e2:SetCondition(c11526307.setcon)
	e2:SetTarget(c11526307.settg)
	e2:SetOperation(c11526307.setop)
	c:RegisterEffect(e2)
  
	--synchro effect
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c11526307.sctg)
	e6:SetOperation(c11526307.scop)
	c:RegisterEffect(e6)
end
c11526307.SetCard_Carbonic_Acid_Girl=true 
--
function c11526307.setcon(e,tp,eg,ep,ev,re,r,rp)
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler().SetCard_Carbonic_Acid_Girl and te:IsActiveType(TYPE_MONSTER) and p==tp and rp==1-tp
end
function c11526307.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c11526307.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--
function c11526307.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler().SetCard_Carbonic_Acid_Girl and te:IsActiveType(TYPE_MONSTER)
end
--
function c11526307.mfilter(c)
	return c.SetCard_Carbonic_Acid_Girl and c:IsType(TYPE_MONSTER)
end
function c11526307.syncheck(g,tp,syncard)
	return g:IsExists(c11526307.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c11526307.spfilter(c,tp,mg)
	return mg:CheckSubGroup(c11526307.syncheck,2,#mg,tp,c)
end
function c11526307.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c11526307.spfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11526307.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c11526307.spfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c11526307.syncheck,false,2,#mg,tp,sc)
		Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
	end
end


