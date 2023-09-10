--祭铜步行机 伊迪菲斯
function c22348227.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348227,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,22348227)
	e1:SetTarget(c22348227.sptg1)
	e1:SetOperation(c22348227.spop1)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348227,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c22348227.spcon)
	e3:SetTarget(c22348227.sptg)
	e3:SetOperation(c22348227.spop)
	c:RegisterEffect(e3)	
end
--
function c22348227.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348227.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE) and c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)~=0 then
			local fid=c:GetFieldID()
			c:RegisterFlagEffect(22348227,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(c)
			e1:SetCondition(c22348227.thcon1)
			e1:SetOperation(c22348227.thop1)
			Duel.RegisterEffect(e1,tp)
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c22348227.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348227,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,c22348227.thfilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function c22348227.thfilter(c)
	return c:IsSetCard(0x708) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(22348227)
end
function c22348227.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(22348227)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c22348227.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
--
function c22348227.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c22348227.smmfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x708) and c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c22348227.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348227.smmfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c22348227.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tg=Duel.SelectMatchingCard(tp,c22348227.smmfilter,tp,LOCATION_HAND,0,1,1,nil)
	local ttc=tg:GetFirst()
	if ttc then
		local s1=ttc:IsSummonable(true,nil,1)
		local s2=ttc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,ttc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,ttc,true,nil,1)
		else
			Duel.MSet(tp,ttc,true,nil,1)
		end
	end
end

