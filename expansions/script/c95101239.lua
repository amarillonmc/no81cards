--化龙神术
function c95101239.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1,95101239+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95101239.target)
	e1:SetOperation(c95101239.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c95101239.setcon)
	e2:SetTarget(c95101239.settg)
	e2:SetOperation(c95101239.setop)
	c:RegisterEffect(e2)
	if not c95101239.global_check then
		c95101239.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c95101239.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c95101239.tfilter(c,e,tp)
	return c:IsSetCard(0x5bb0) and c:IsFaceup() and c:IsAbleToGrave()-- and c:GetEquipCount()~=0
		and Duel.IsExistingMatchingCard(c95101239.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c95101239.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x5bb0) and c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsAttribute(tc:GetAttribute())
end
function c95101239.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101239.tfilter(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	--if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
	if chk==0 then return Duel.IsExistingTarget(c95101239.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c95101239.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c95101239.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101239.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if not sc or Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)==0 then return end
	sc:CompleteProcedure()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c95101239.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ac,dc=Duel.GetBattleMonster(0)
	if ac and ac:IsSetCard(0x5bb0) then
		Duel.RegisterFlagEffect(ac:GetControler(),95101239,RESET_PHASE+PHASE_END,0,1)
	end
	if dc and dc:IsSetCard(0x5bb0) then
		Duel.RegisterFlagEffect(dc:GetControler(),95101239,RESET_PHASE+PHASE_END,0,1)
	end
end
function c95101239.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,95101239)~=0
end
function c95101239.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c95101239.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.SSet(tp,c)
	end
end
