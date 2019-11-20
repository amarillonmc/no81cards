--本条二亚的换衣作战
function c33400257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400257)
	e1:SetCost(c33400257.cost)
	e1:SetTarget(c33400257.target)
	e1:SetOperation(c33400257.activate)
	c:RegisterEffect(e1)
	--NEGATE
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,33400257+10000)
	e2:SetCondition(c33400257.condition)
	e2:SetOperation(c33400257.neop)
	c:RegisterEffect(e2)
end
function c33400257.refilter(c)
	return (c:IsSetCard(0x341) or c:IsSetCard(0x340)) and c:IsReleasable()
end
function c33400257.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c33400257.refilter,tp,loc,0,1,e:GetHandler(),e,tp) and Duel.IsExistingMatchingCard(c33400257.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c33400257.refilter,tp,loc,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c33400257.filter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400257.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400257.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c33400257.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400257.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c33400257.nefilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x6342)
end
function c33400257.condition(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c33400257.nefilter,1,nil,tp)
end
function c33400257.neop(e,tp,eg,ep,ev,re,r,rp)
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	 Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local token=Duel.CreateToken(tp,ac)
	local t1=bit.band(token:GetType(),0x7)
	local t2=bit.band(tc:GetType(),0x7)
	if t1==t2  then 
		 Duel.Damage(1-tp,500,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400257,0))  then
		   Duel.NegateEffect(ev)
		end
	end
	if tc:IsCode(ac) then 
		 Duel.Damage(1-tp,500,REASON_EFFECT)  
		 if Duel.SelectYesNo(tp,aux.Stringid(33400257,1))  then
		 Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		 end
	end
end
