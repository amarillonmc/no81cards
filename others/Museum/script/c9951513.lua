--局部坏死-煌
function c9951513.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),4,99,c9951513.lcheck)
	c:EnableReviveLimit()
  --Battle!!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9951513.batg)
	e1:SetOperation(c9951513.baop)
	c:RegisterEffect(e1)
 --handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951513,0))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,99515130)
	e3:SetTarget(c9951513.hdtg)
	e3:SetOperation(c9951513.hdop)
	c:RegisterEffect(e3)
 --destroy and summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951513,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9951513)
	e3:SetCondition(c9951513.spcon)
	e3:SetCost(c9951513.spcost)
	e3:SetTarget(c9951513.sptg)
	e3:SetOperation(c9951513.spop)
	c:RegisterEffect(e3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951513.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951513.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951513,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951513,1))
end
function c9951513.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c9951513.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9951513.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c9951513.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c9951513.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,2)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
end
function c9951513.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9951513.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c9951513.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9951513.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(3500)
		c:RegisterEffect(e1)
	end
end