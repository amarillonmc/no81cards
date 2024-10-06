chuoying=chuoying or {}
shushu=shushu or {}
function chuoying.gaixiaoguo1(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348359)
		and Duel.IsPlayerCanDiscardDeck(tp,3)
		and Duel.SelectYesNo(tp,aux.Stringid(22348359,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348359)
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
	end
end
function chuoying.gaixiaoguo2(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348360)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348360,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348360)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,1,2,nil)
		Duel.HintSelection(rg)
		if #rg>0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function chuoying.gaixiaoguo3(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348361)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348361,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348361)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(dg)
		if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function chuoying.thfilter(c)
	return (c:IsSetCard(0xb70a) or c:IsCode(22348370)) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function chuoying.gaixiaoguo4(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348362)
		and Duel.IsExistingMatchingCard(chuoying.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348362,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348362)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tg=Duel.SelectMatchingCard(tp,chuoying.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
		end
	end
end
function chuoying.disfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.NegateMonsterFilter(c)
end
function chuoying.gaixiaoguo5(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348413)
		and Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(22348413,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348413)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local dg=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=dg:GetFirst()
		Duel.HintSelection(dg)
		if tc:IsFaceup() and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		end
	end
end
function chuoying.gaixiaoguo6(e,tp,res)
	local c=e:GetHandler()
	local chk=c:IsSetCard(0xd70a)
	if chk and c:GetFlagEffectLabel(22348414)
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(22348414,3)) then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,22348414)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function shushu.EnableUnionAttribute(c)
	--destroy sub
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e1:SetValue(Auxiliary.UnionReplaceFilter)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNION_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--equip
	local equip_filter=shushu.UnionEquipFilter()
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1068)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(shushu.UnionEquipTarget(equip_filter))
	e3:SetOperation(Auxiliary.UnionEquipOperation(equip_filter))
	c:RegisterEffect(e3)
	--unequip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1152)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(Auxiliary.UnionUnequipTarget)
	e4:SetOperation(Auxiliary.UnionUnequipOperation)
	c:RegisterEffect(e4)
end
function shushu.UnionEquipFilter()
	return  function(c,tp)
				local ct1,ct2=c:GetUnionCount()
				return c:IsFaceup() and ct2==0
			end
end
function shushu.UnionEquipTarget(equip_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local c=e:GetHandler()
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and equip_filter(chkc,tp) end
				if chk==0 then return c:GetFlagEffect(FLAG_ID_UNION)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
					and Duel.IsExistingTarget(equip_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectTarget(tp,equip_filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,tp)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
				c:RegisterFlagEffect(FLAG_ID_UNION,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
			end
end