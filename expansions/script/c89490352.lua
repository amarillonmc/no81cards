--维萨斯-水仙女星霜
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748,89490273,89490351)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.ssettg)
	e2:SetOperation(s.ssetop)
	c:RegisterEffect(e2)
end
function s.tgfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil) or #Duel.GetDecktopGroup(tp,1)>0 and Duel.GetMZoneCount(tp)>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=#Duel.GetDecktopGroup(tp,1)>0 and Duel.GetMZoneCount(tp)>0
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,0)},{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if Duel.Destroy(sg,REASON_EFFECT)>0 and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(56099748)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	else
		if Duel.Destroy(Duel.GetDecktopGroup(tp,1),REASON_EFFECT)>0 and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(89490273)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(89490351,PLAYER_ALL,LOCATION_FZONE)
end
function s.ssetfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (aux.IsCodeListed(c,56099748) or aux.IsCodeListed(c,89490273)) and c:IsSSetable()
end
function s.ssettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ssetfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.ssetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.ssetfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SSet(tp,g)
	end
end
