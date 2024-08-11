--连结的绊炎 传承:琉迩
local m=75000007
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	aux.AddFusionProcCodeFunRep(c,75000001,c75000007.ffilter,1,127,true,true)
	--material check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c75000007.matcon)
	e1:SetOperation(c75000007.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c75000007.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--SetCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000007,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75000007.efcon2)
	e3:SetTarget(c75000007.sttg)
	e3:SetOperation(c75000007.stop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75000007.efcon3)
	e4:SetValue(c75000007.atkval)
	c:RegisterEffect(e4)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_SINGLE)
	e41:SetCode(EFFECT_UPDATE_DEFENSE)
	e41:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e41:SetRange(LOCATION_MZONE)
	e41:SetCondition(c75000007.efcon3)
	e41:SetValue(c75000007.atkval)
	c:RegisterEffect(e41)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(75000007,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75000007.efcon4)
	e5:SetTarget(c75000007.sptg)
	e5:SetOperation(c75000007.spop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,75000007+EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(c75000007.sp4con)
	e6:SetTarget(c75000007.sp4tg)
	e6:SetOperation(c75000007.sp4op)
	c:RegisterEffect(e6)
	
end
function c75000007.sp4con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)-- and c:GetReasonPlayer()==1-tp
end
function c75000007.sp4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_EXTRA)
end
function c75000007.sp4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
			c:SetMaterial(nil)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(math.floor(Duel.GetLP(tp)/2))
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e2:SetValue(math.floor(Duel.GetLP(tp)/2))
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(75000007,RESET_EVENT+RESETS_STANDARD,0,1,4)
		c:RegisterFlagEffect(75000010,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(75000007,5))
	end
end
function c75000007.efcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(75000007) and e:GetHandler():GetFlagEffectLabel(75000007)>1
end
function c75000007.efcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(75000007) and e:GetHandler():GetFlagEffectLabel(75000007)>2
end
function c75000007.efcon4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(75000007) and e:GetHandler():GetFlagEffectLabel(75000007)>3 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c75000007.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,75000001)
end
function c75000007.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c75000007.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(75000007,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
	if e:GetLabel()==2 then
		e:GetHandler():RegisterFlagEffect(75000008,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(75000007,3))
	elseif e:GetLabel()==3 then
		e:GetHandler():RegisterFlagEffect(75000009,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(75000007,4))
	elseif e:GetLabel()>3 then
		e:GetHandler():RegisterFlagEffect(75000010,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(75000007,5))
	end
end
function c75000007.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetClassCount(Card.GetFusionAttribute)
	e:GetLabelObject():SetLabel(ct)
end
function c75000007.setfilter(c)
	return c:IsSetCard(0x75a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c75000007.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000007.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c75000007.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000007.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(75000007,6))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c75000007.atkval(e,c)
	return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetClassCount(Card.GetAttribute)*400
end
function c75000007.spfilter(c,e,tp)
	return aux.IsCodeListed(c,75000001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLocation(LOCATION_EXTRA)) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c75000007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000007.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c75000007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000007.spfilter),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
