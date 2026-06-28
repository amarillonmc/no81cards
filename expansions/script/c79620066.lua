--光波降临
function c79620066.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,79620066)
	e1:SetTarget(c79620066.target)
	e1:SetOperation(c79620066.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79620066,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79620066+100)
	e2:SetCondition(c79620066.thcon)
	e2:SetTarget(c79620066.thtg)
	e2:SetOperation(c79620066.thop)
	c:RegisterEffect(e2)
end
function c79620066.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xe5) 
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c79620066.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetCode())
end
function c79620066.filter2(c,e,tp,mc,code)
	return c:IsSetCard(0xe5) and not c:IsCode(code) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c79620066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c79620066.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c79620066.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c79620066.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79620066.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		or tc:IsFacedown() or not tc:IsRelateToChain() or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79620066.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetCode())
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
			if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79620066,1)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
						local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
						local g=g1:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					if tc:IsFaceup() then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_EFFECT)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
					local e4=Effect.CreateEffect(e:GetHandler())
					e4:SetType(EFFECT_TYPE_SINGLE)
					e4:SetCode(EFFECT_SET_ATTACK_FINAL)
					e4:SetValue(sc:GetBaseAttack())
					e4:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e4)
					local e5=Effect.CreateEffect(e:GetHandler())
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetCode(EFFECT_CHANGE_CODE)
					e5:SetValue(sc:GetCode())
					e5:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e5)
					end
					Duel.GetControl(tc,tp)
				end
			end
	end
end
function c79620066.cfilter(c)
	return c:IsFaceup()
end
function c79620066.get_count(g)
	if g:GetCount()==0 then return 0 end
	local ret=0
	repeat
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		local ct1=g:GetCount()
		g:Remove(Card.IsCode,nil,tc:GetCode())
		local ct2=g:GetCount()
		local c=ct1-ct2+1
		if c>ret then ret=c end
	until g:GetCount()==0 or g:GetCount()<=ret
	return ret
end
function c79620066.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79620066.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=c79620066.get_count(g)
	e:SetLabel(ct)
	return ct>=2
end
function c79620066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c79620066.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
