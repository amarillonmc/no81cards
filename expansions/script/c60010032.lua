--花火-焰锦游鱼-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31755044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.mattg)
	e1:SetOperation(cm.matop)
	c:RegisterEffect(e1)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31755044,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.mattg)
	e1:SetOperation(cm.matop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c,race,attr)
	return c:IsFaceup() and not c:IsRace(race) and not c:IsAttribute(attr)
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local races=e:GetHandler():GetRace()
	local attrs=e:GetHandler():GetAttribute()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.matfilter(chkc,races,attrs) end
	if chk==0 then return Duel.IsExistingTarget(cm.matfilter,tp,LOCATION_MZONE,0,1,nil,races,attrs) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil,races,attrs)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local raceo=tc:GetRace()
	local attro=tc:GetAttribute()
	local races=e:GetHandler():GetRace()
	local attrs=e:GetHandler():GetAttribute()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local i=0
	while i<=0xffff do
		if tc:IsSetCard(i) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(i)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e1)
		end
		i=i+1
	end
	
	if Duel.IsExistingMatchingCard(cm.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,raceo,attro,races,attrs,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local sc=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,raceo,attro,races,attrs,e,tp):Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function cm.spfil(c,raceo,attro,races,attrs,e,tp)
	return not c:IsRace(raceo) and not c:IsAttribute(attro) and not c:IsRace(races) and not c:IsAttribute(attrs) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.repfilter(c,tp,races,attrs)
	return c:IsControler(tp) and c:IsOnField() and not c:IsAttribute(races) and not c:IsRace(attrs)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local races=e:GetHandler():GetRace()
	local attrs=e:GetHandler():GetAttribute()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp,races,attrs) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	local races=e:GetHandler():GetRace()
	local attrs=e:GetHandler():GetAttribute()
	return cm.repfilter(c,e:GetHandlerPlayer(),races,attrs)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(e:GetHandlerPlayer(),m)<3 then
		Duel.Draw(e:GetHandlerPlayer(),1,REASON_EFFECT)
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.Hint(HINT_CARD,0,m)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_FZONE,0,1,nil,60010029) and Duel.GetTurnPlayer()~=tp
end














