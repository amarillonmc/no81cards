--人理之诗 呜呼，吾之枪自当献予心爱的公主！
function c22023590.initial_effect(c)
	aux.AddCodeList(c,22023580)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023590,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22023590)
	e1:SetCondition(c22023590.dbcon)
	e1:SetTarget(c22023590.target)
	e1:SetOperation(c22023590.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023590,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023591)
	e2:SetCost(c22023590.spcost)
	e2:SetTarget(c22023590.target1)
	e2:SetOperation(c22023590.activate1)
	c:RegisterEffect(e2)
end
function c22023590.dbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c22023590.filter(c)
	return c:IsFaceup() and c:IsCode(22023580)
end
function c22023590.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22023590.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023590.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22023590.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SelectOption(tp,aux.Stringid(22023590,2))
	Duel.SelectOption(tp,aux.Stringid(22023590,4))
	Duel.SelectOption(tp,aux.Stringid(22023590,5))
end
function c22023590.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	tc:RegisterFlagEffect(22023590,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc:GetFieldID())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(c22023590.atkcon)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(tc)
	e2:SetCondition(c22023590.discon)
	e2:SetOperation(c22023590.disop)
	Duel.RegisterEffect(e2,tp)
end
function c22023590.atkcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c22023590.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=tc:GetFlagEffectLabel(22023590)
	return fid and fid==tc:GetFieldID()
end
function c22023590.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	local tc=e:GetLabelObject()
	if not ac or not bc then return end
	if ac~=tc then ac,bc=bc,ac end
	if ac==tc and bc:IsControler(1-tp) then
		Duel.Hint(HINT_CARD,0,22023590)
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c22023590.cfilter1(c,tp)
	return c:IsSetCard(0xff1) and Duel.GetMZoneCount(tp,c)>1 and c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c22023590.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroup(tp,c22023590.cfilter1,1,nil,tp) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectReleaseGroup(tp,c22023590.cfilter1,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c22023590.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_FUSION)
end
function c22023590.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=(e:GetLabel()==1)
		e:SetLabel(0)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.IsExistingMatchingCard(c22023590.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp)
			and ((chkf and ft>0) or (not chkf and ft>1))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
	e:SetLabel(0)
	Duel.SelectOption(tp,aux.Stringid(22023590,3))
end
function c22023590.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22023590.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
