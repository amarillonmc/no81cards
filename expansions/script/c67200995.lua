--圣树修正者 谧光之刻
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x67a),1,99)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.stcon)
	e3:SetTarget(s.sttg)
	e3:SetOperation(s.stop)
	c:RegisterEffect(e3)
end
function s.pfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.pfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.pfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.pfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			local lv=math.min(tc:GetLevel(),11)
			if lv>0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
				local lv2=Duel.AnnounceLevel(tp,1,lv)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(-lv2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.sfilter(c,e,tp)
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,0)) and not c:IsForbidden()
	local b2=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_DECK))
	or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA))
	return c:IsSetCard(0x667a) and c:IsType(TYPE_MONSTER) and (b1 or b2) and c:IsFaceupEx()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,c,e,tp) end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,c,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,0)) and not tc:IsForbidden()
		local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsLocation(LOCATION_DECK))
	or (Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and tc:IsLocation(LOCATION_EXTRA))
		if b1 and (not b2 or Duel.SelectOption(tp,aux.Stringid(id,1),1118)==0) then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not e:GetHandler():IsForbidden() end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and e:GetHandler():IsRelateToEffect(e) then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end