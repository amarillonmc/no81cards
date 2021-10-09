--爱国者
function c9950605.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,true)
	c:EnableReviveLimit()
 --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950605,2))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c9950605.destg)
	e2:SetOperation(c9950605.desop)
	c:RegisterEffect(e2)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9950605)
	e1:SetTarget(c9950605.sptg1)
	e1:SetOperation(c9950605.spop1)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950605.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950605.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950605,0))
end
function c9950605.filter(c)
	return c:IsFaceup() 
end
function c9950605.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9950605.filter(chkc) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<-1 then return false end
		return e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false)
			and Duel.IsExistingTarget(c9950605.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
		local loc=LOCATION_ONFIELD
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		g=Duel.SelectTarget(tp,c9950605.filter,tp,loc,loc,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
		Duel.SetChainLimit(c9950605.chlimit)
end
function c9950605.chlimit(e,ep,tp)
	return tp==ep
end
function c9950605.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9950605,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,c)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950605.atkval)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c9950605.atkval(e,c,tp)
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_TRAP+TYPE_SPELL)*500
end
function c9950605.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsPosition(POS_FACEUP_ATTACK) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
	local atk=math.floor(g:GetFirst():GetBaseAttack()/2)
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c9950605.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=math.floor(tc:GetBaseAttack()/2)
		if atk<0 then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950605,0))
end