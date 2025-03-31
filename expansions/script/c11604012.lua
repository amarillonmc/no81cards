--宝可·沉重球
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.copy(c,e,tp,ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-500*ct)
	c:RegisterEffect(e1)
	if c:GetAttack()==0 then
		Duel.SendtoHand(c,tp,REASON_EFFECT,tp)
		if c:IsLocation(LOCATION_EXTRA+LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		end	
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,2)
	--Duel.SetOperationInfo(0,CATEGORY_TOEXTRA+CATEGORY_TOHAND,nil,1,1-tp,LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	local cont=2
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()|tc:GetRank()|tc:GetLink()
	if lv>0 then
		cont=cont+lv
	end
	local res={Duel.TossCoin(tp,cont)}	
	for i=1,cont do
		if res[i]==1 then
			ct=ct+1
		end
	end		
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		s.copy(tc,e,tp,ct)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x9224)
end
