--超级量子幻士 暗光层
local m=89387017
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,cm.spcheck)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(m)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.etlimit)
	c:RegisterEffect(e4)
	if not cm.initcheck then
		cm.initcheck=true
		local sop=Effect.SetOperation
		Effect.SetOperation=function(e,op)
			local ec=e:GetOwner()
			if ec:IsOriginalSetCard(0xdc) and ec:IsType(TYPE_XYZ) then
				if bit.band(e:GetProperty(),EFFECT_FLAG_CARD_TARGET)>0 then
					sop(e,function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						local tc=Duel.GetFirstTarget()
						if tc:IsRelateToEffect(e) then
							if c:IsHasEffect(89387017) and c:IsRelateToEffect(e) and cm.ofilter(tc,e) and Duel.SelectYesNo(tp,aux.Stringid(89387017,0)) then
								local og=tc:GetOverlayGroup()
								if og:GetCount()>0 then
									Duel.SendtoGrave(og,REASON_RULE)
								end
								Duel.Overlay(c,tc)
							else
								op(e,tp,eg,ep,ev,re,r,rp)
							end
						end
					end)
				end
				if e:GetDescription()==aux.Stringid(84025439,0) then
					sop(e,function(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
						local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
						if sg:GetCount()>0 then
							Duel.HintSelection(sg)
							if c:IsHasEffect(89387017) and c:IsRelateToEffect(e) and not sg:IsExists(aux.NOT(cm.ofilter),nil,1,e) and Duel.SelectYesNo(tp,aux.Stringid(89387017,0)) then
								for tc in aux.Next(sg) do
									local og=tc:GetOverlayGroup()
									if og:GetCount()>0 then
										Duel.SendtoGrave(og,REASON_RULE)
									end
								end
								Duel.Overlay(c,sg)
							else
								Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
							end
						end
					end)
				end
			else
				sop(e,op)
			end
		end
		local rg=Duel.GetMatchingGroup(Card.IsOriginalSetCard,tp,0xff,0xff,nil,0x20dc)
		for tc in aux.Next(rg) do
			if tc.initial_effect then
				local tinit=cm.initial_effect
				cm.initial_effect=function() end
				tc:ReplaceEffect(114303426,0)
				cm.initial_effect=tinit
				tc.initial_effect(tc)
			end
		end
	end
end
function cm.spcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xdc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetHandler():GetLinkedZone(tp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone)
	if c:IsRelateToEffect(e) and g and g:GetCount()>0 then
		local zone=c:GetLinkedZone(tp)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		if ct>g:GetCount() then ct=g:GetCount() end
		if ct>c:GetMaterialCount() then ct=c:GetMaterialCount() end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then ct=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,ct,nil,e,tp,zone)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0xdc)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xdc) and c:IsType(TYPE_XYZ)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,47819246) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetControler()==tp then
		local c=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,47819246)
		if not c then return end
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer() and c:IsSetCard(0xdc) and c:IsType(TYPE_XYZ)
end
function cm.etlimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

function cm.ofilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if c:IsHasEffect(89387017) and c:IsRelateToEffect(e) and cm.ofilter(tc,e) and Duel.SelectYesNo(tp,aux.Stringid(89387017,0)) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,tc)
		else
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
