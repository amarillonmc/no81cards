--珠玉圣骑·严戒
local m=40010376
local cm=_G["c"..m]
cm.named_with_JewelPaladin=1
function cm.JewelPaladin(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_JewelPaladin
end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and cm.JewelPaladin(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(cm.cfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.tgfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function cm.spfilter(c,e,tp)
	return cm.JewelPaladin(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if Duel.IsCanRemoveCounter(tp,1,1,0xf1b,1,REASON_EFFECT) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.RemoveCounter(tp,1,1,0xf1b,1,REASON_EFFECT)
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=-1 then return end
				local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if sg:GetCount()>0 and ft>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				else
					local tg=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
					local tc=tg:GetFirst()
					if tc and Duel.Release(tc,REASON_COST) ~=0 and tc:IsLocation(LOCATION_GRAVE) then
						Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
						Duel.RegisterFlagEffect(tp,m,RESET_EVENT+0x1fe0000+RESET_CHAIN,EFFECT_FLAG_OATH,1)
					end
				end
				Duel.ResetFlagEffect(tp,m)
			end
		end
	end
end
function cm.chfilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.chfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,5,nil)
end
