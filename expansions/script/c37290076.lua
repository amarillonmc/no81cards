--创生结晶 
local cm,m=GetID()
function c37290076.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.stcost)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(cm.mvtg)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
end
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp)
	local ft3=Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ft1 or ft2 or ft3 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp)
	local ft3=Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,37290070,0x370,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,2,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if ft1 or ft2 or ft3 then		 
		for i=1,2 do
			local token=Duel.CreateToken(tp,37290070)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0x00600060)
			 local sump=0
						if zone&0x1f>0 then
							sump=tp
						else
							sump=1-tp
							zone=zone>>16
						end
			Duel.SpecialSummonStep(token,0,tp,sump,false,false,POS_FACEUP,zone)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.filter(c,tp)
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(c:GetOwner()) then r=LOCATION_REASON_CONTROL end
	return (c:IsType(TYPE_TOKEN)) and c:IsFaceupEx()
		and Duel.GetLocationCount(c:GetOwner(),LOCATION_SZONE,tp,r)>0
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=aux.SelectTargetFromFieldFirst(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function cm.fit(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x370)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		local g=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
		end
	end
end