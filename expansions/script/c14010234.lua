--叱影军武装-烈风丸
local m=14010234
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--Atk Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	--change race
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(cm.destg)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
end
function cm.eqlimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.atkval(e,c)
	local val=c:GetBaseDefense()-c:GetDefense()
	if val<0 then return 0 end
	return val
end
function cm.desfilter(c,e)
	return c:IsSetCard(0x852) and c:GetOriginalType()&TYPE_MONSTER and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and not c:IsImmuneToEffect(e)
end
function cm.desfilter3(c)
	return c:IsSetCard(0x852) and c:GetOriginalType()&TYPE_MONSTER and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.fselect3(g,e,tp)
	local atk=g:GetSum(Card.GetAttack)
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,atk)
end
function cm.desfilter2(c)
	return c:IsLocation(LOCATION_MZONE) and Duel.GetMZoneCount(tp,c)>0
end
function cm.spfilter(c,e,tp,atk)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsAttackBelow(atk)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then loc=LOCATION_MZONE end
		local g=Duel.GetMatchingGroup(cm.desfilter3,tp,loc,0,nil)
		return #g>0 and g:CheckSubGroup(cm.fselect3,1,2,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA,0,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		dg=mg:Filter(cm.desfilter2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if dg and #dg>0 then
		tg=dg:Select(tp,1,1,nil)
	elseif mg and #mg>0 then
		tg=mg:Select(tp,1,1,nil)
	else
		return false
	end
	local tc=tg:GetFirst()
	if tc then
		local atk=tc:GetAttack()
		mg:RemoveCard(tc)
		if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,atk) and #mg>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local mg1=mg:Select(tp,1,1,nil)
			tg:Merge(mg1)
		end
		if tg and #tg>0 and Duel.Destroy(tg,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			atk=og:GetSum(Card.GetAttack)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,atk)
			if #g>0 then
				Duel.BreakEffect()
				if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
					local tc=Duel.GetOperatedGroup():GetFirst()
					Duel.Equip(tp,c,tc,false)
				end
			end
		end
	end
end