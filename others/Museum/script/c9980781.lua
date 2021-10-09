--欲望战士OOO·燃烧联组
function c9980781.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9980777,c9980781.ffilter,1,true,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980781,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99807810)
	e1:SetTarget(c9980781.destg)
	e1:SetOperation(c9980781.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c9980781.spr)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980781,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1,9980781)
	e3:SetCondition(c9980781.spcon)
	e3:SetTarget(c9980781.sptg)
	e3:SetOperation(c9980781.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xabc1))
	e3:SetValue(c9980781.atkval)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980781.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980781.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980781,3))
end
function c9980781.ffilter(c)
	return c:IsSetCard(0x3bcf) and c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function c9980781.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9980781.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980781.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9980781.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(9980781,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980781.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY)) then return end
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(9980781,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(9980781,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function c9980781.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(9980781)>0
end
function c9980781.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(9980781)
end
function c9980781.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9980781.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bcf,0xbca)
end
function c9980781.atkval(e,c)
	return Duel.GetMatchingGroupCount(c9980781.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end