--圣兽装骑·鲨-闲暇
local m=60001117
local cm=_G["c"..m]

function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.sptg1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)
	--Checkgrave
	local e27=Effect.CreateEffect(c)
	e27:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e27:SetProperty(EFFECT_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e27:SetCode(EVENT_ADJUST)
	e27:SetOperation(cm.gravecheckop)
	Duel.RegisterEffect(e27,0)
end

function cm.gravecheckop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then
		e:GetHandler():RegisterFlagEffect(0,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001111,0))
	end
end

function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_MONSTER) and c:IsSetCard(0x62e))
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) or Duel.GetFlagEffect(tp,m)==0
end

function cm.rmfilter(c,tp)
	return c:IsSetCard(0x562e) and not c:IsCode(m) and (((c:IsAbleToDeck() or c:IsAbleToExtra()) and Duel.IsPlayerCanDraw(tp,1)) or c:IsAbleToHand())
end

function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.rmfilter(chkc) end
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	c:ResetFlagEffect(m)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.RegisterFlagEffect(tp,m,0,0,1)
		c:RegisterFlagEffect(m,0,0,1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsAbleToDeck() or tc:IsAbleToExtra() then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		if tc:IsAbleToDeck() then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,LOCATION_GRAVE)
		elseif tc:IsAbleToExtra() then
			Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,tc,1,tp,LOCATION_GRAVE)
		end
	elseif tc:IsAbleToHand() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_GRAVE)
	end
end

function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		if tc:IsAbleToHand() and 
		(not ((tc:IsAbleToDeck() or tc:IsAbleToExtra()) and Duel.IsPlayerCanDraw(tp,1)) or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
			if Duel.SendtoHand(tc,nil,REASON_EFFECT) and c:IsRelateToEffect(e) and c:GetFlagEffect(m)~=0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) and Duel.Draw(tp,1,REASON_EFFECT) and c:IsRelateToEffect(e) and c:GetFlagEffect(m)~=0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end