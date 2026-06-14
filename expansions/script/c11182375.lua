--至高主宰·京玉·水之主宰
function c11182375.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c11182375.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c11182375.matval)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,11182375)
	e1:SetCondition(aux.exccon)
	e1:SetTarget(c11182375.sptg)
	e1:SetOperation(c11182375.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,11182375)
	e2:SetTarget(c11182375.thtg)
	e2:SetOperation(c11182375.thop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c11182375.immunefilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c11182375.efilter)
	c:RegisterEffect(e4)
end
function c11182375.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c11182375.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
		and (te:GetHandler():IsAttribute(ATTRIBUTE_WATER) or te:GetHandler():IsType(TYPE_LINK))
end
function c11182375.thfilter(c)
	return c:IsSetCard(0x6454) and c:IsAbleToHand()
end
function c11182375.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11182375.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11182375.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ch=Duel.GetCurrentChain()
	local ck=false
	if ch>1 then
		local code=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_CODE)
		if code==11182320 then ck=true end
	end
	local b1=Duel.IsExistingMatchingCard(c11182375.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) and ck
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(11182375,1)},{b2,aux.Stringid(11182375,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c11182375.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		c11182375.remop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c11182375.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(11182375,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(11182375,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(11182375,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c11182375.is_goddess_opp(mc,lc,mg,tp)
	return mc:IsType(0x6) and mc:IsSetCard(0x6454)
end
function c11182375.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	-- 閉ザサレシ世界ノ冥神 only concerns opponent monsters
	if not c:IsType(0x6) or not c:IsSetCard(0x6454) then return false,nil end
	-- related=true
	if not mg then
		return true,true
	end
	-- Otherwise this would be "via 閉ザサレシ世界ノ冥神": allow at most one such opponent monster.
	if mg:IsExists(c11182375.is_goddess_opp,1,c,lc,mg,tp) then
		return true,false
	end
	return true,true
end
function c11182375.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x6454)
end
function c11182375.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11182375.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end