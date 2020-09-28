--欲望战士OOOOOO·修卡联组
function c9980803.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),5,99,c9980803.lcheck)
	c:EnableReviveLimit()
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980803,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9980803.rmcon)
	e4:SetTarget(c9980803.rmtg)
	e4:SetOperation(c9980803.rmop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980803.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980803.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980803,1))
end
function c9980803.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c9980803.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980803.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c9980803.filter(c,rc)
	return c:IsRelateToCard(rc) and c:IsSetCard(0xabc1) and c:IsType(TYPE_FUSION+TYPE_LINK)
end
function c9980803.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	if tc and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		local g=Duel.GetMatchingGroup(c9980803.filter,tp,LOCATION_REMOVED,0,nil,c)
		if c:GetOriginalCode()==9980803 and c:IsFaceup() and g:IsContains(tc) and g:GetClassCount(Card.GetCode)==9 then
			local WIN_REASON_EXODIUS = 0x14
			Duel.Win(tp,WIN_REASON_EXODIUS)
		end
	end
end