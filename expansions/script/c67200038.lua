--神官骑士 洛卡
function c67200038.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2) 
	--destory card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200038,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,67200038)
	e1:SetCondition(c67200038.atkcon)
	e1:SetTarget(c67200038.atktg)
	e1:SetOperation(c67200038.atkop)
	c:RegisterEffect(e1) 
end
function c67200038.atkfilter(c,e)
	return c:IsType(TYPE_LINK) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()))
		and c:IsCanBeEffectTarget(e)
end
function c67200038.chainlm(e,ep,tp)
	return tp==ep
end
function c67200038.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200038.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	local gh=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chkc then return mg:IsContains(chkc) and c67200038.atkfilter(chkc,e) end
	if chk==0 then return mg:IsExists(c67200038.atkfilter,1,nil,e) and gh:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=mg:FilterSelect(tp,c67200038.atkfilter,1,1,nil,e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,gh,1,0,0)
	Duel.SetChainLimit(c67200038.chainlm)
end
function c67200038.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,tc:GetLink(),nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--
