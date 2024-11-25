--娱乐法师 马戏驯兽师
local s,id,o=GetID()
function c98921079.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--return
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98921079,3))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCountLimit(1,98921079)
	e0:SetTarget(c98921079.starget)
	e0:SetOperation(c98921079.soperation)
	c:RegisterEffect(e0)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921079,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98931079)
	e1:SetTarget(c98921079.lvtg)
	e1:SetOperation(c98921079.lvop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--change level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function c98921079.ssfilter(c)
	return c:IsSetCard(0xc6) and c:IsFaceup() and c:IsLevelAbove(1)
end
function c98921079.starget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c98921079.ssfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98921079.ssfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c98921079.ssfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c98921079.soperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Damage(tp,tc:GetLevel()*100,REASON_EFFECT)
		end
	end
end
function c98921079.lvfilter(c,lv,atk)
	return c:IsFaceup() and c:IsLevelAbove(1) and (not c:IsLevel(lv) or not c:IsAttack(atk))
end
function c98921079.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98921079.lvfilter(chkc) and chkc~=e:GetHandler() end
	local lv=e:GetHandler():GetLevel()
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingTarget(c98921079.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),lv,atk)
		and e:GetHandler():IsLevelAbove(1) and e:GetHandler():IsRelateToEffect(e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98921079.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),lv,atk)
end
function c98921079.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c98921079.cxfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
			local b1=tc:IsRelateToEffect(e)
			local b2=Duel.IsExistingMatchingCard(c98921079.tgfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
			local off=1
			local ops={}
			local opval={}
			if b1 then
				ops[off]=aux.Stringid(98921079,0)
				opval[off-1]=1
				off=off+1
			end
			if b2 then
				ops[off]=aux.Stringid(98921079,1)
				opval[off-1]=2
				off=off+1
			end
			ops[off]=aux.Stringid(98921079,2)
			opval[off-1]=3
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				Duel.BreakEffect()
				Duel.Destroy(tc,REASON_EFFECT)
			elseif sel==2 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,c98921079.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function c98921079.tgfilter2(c,cd)
	return c:IsCode(cd) and c:IsAbleToGrave()
end
function c98921079.cxfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98921079.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c98921079.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	e:SetLabelObject(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98921079,0))
	local g2=Duel.SelectTarget(tp,c98921079.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc1,tc1:GetLevel(),tc1:GetAttack())
end
function c98921079.filter1(c,tp)
	local lv=c:GetLevel()
	local atk=c:GetAttack()
	return lv>0 and c:IsFaceup() and Duel.IsExistingTarget(c98921079.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,lv,atk)
end
function c98921079.filter2(c,lv,atk)
	return not (c:IsLevel(lv) and c:IsAttack(atk)) and c:IsLevelAbove(1) and c:IsFaceup()
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=e:GetLabelObject()
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	local lv=tc1:GetLevel()
	local atk=tc1:GetAttack()
	if tc2:IsLevel(lv) and tc2:IsAttack(atk) then return end
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2)
	end
end