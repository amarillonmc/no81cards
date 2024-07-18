--云上骑士·合致天裁
local m=40011340
local cm=_G["c"..m]
cm.named_with_KeterSanctuary=1
function cm.KeterSanctuary(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_KeterSanctuary
end
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(cm.drcon1)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.drcon2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_REMOVE)
	e5:SetCondition(cm.drcon2)
	c:RegisterEffect(e5)
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and not c:IsLevel(8) and c:IsLevelAbove(1)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.spfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
	   if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		   if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(8) then
		   local e1=Effect.CreateEffect(c)
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			   e1:SetCode(EFFECT_CHANGE_LEVEL)
			   e1:SetValue(8)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			   local e2=Effect.CreateEffect(c)
			   e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_CHANGE_LEVEL)
			   e2:SetValue(8)
			   e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			   c:RegisterEffect(e2)
		   end
		   local e3=Effect.CreateEffect(c)
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		   e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		   e3:SetValue(LOCATION_REMOVED)
		   c:RegisterEffect(e3,true)
		end
	end
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION+REASON_SYNCHRO+REASON_LINK)~=0
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(40009559) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.cfilter(c)
	return c:IsFaceup() and (c:IsLevelAbove(8) or c:IsRankAbove(8))
end
function cm.setfilter(c)
	return cm.KeterSanctuary(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,3,nil) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local tg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SSet(tp,tg)
			end
		end
	end
end
