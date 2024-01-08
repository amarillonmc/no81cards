--魔合之尸海降灵术师
local m=40010330
local cm=_G["c"..m]
cm.named_with_Spiritualist=1
function cm.MagicCombineDemon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagicCombineDemon
end
function cm.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.hspcon)
	e1:SetOperation(cm.hspop)
	c:RegisterEffect(e1)

	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.hspfilter(c,ft,tp)
	return cm.MagicCombineDemon(c)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(REASON_COST,tp,cm.hspfilter,1,nil,ft,tp)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,cm.hspfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp) and c:IsType(TYPE_SPELL)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end

function cm.thfilter(c,tp,e)
	return c:IsFaceup() and cm.MagicCombineDemon(c) and c:IsLocation(LOCATION_REMOVED)
		and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and (c:IsAbleToDeck() or c:IsAbleToExtra())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if chkc then return eg:IsContains(chkc) and cm.thfilter(chkc,tp,e) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil,tp,e)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
end
function cm.spfilter(c,e,tp)
	return cm.MagicCombineDemon(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0  then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end