--天觉龙 查耶
local s,id=GetID()
s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end

function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_BATTLE_DESTROYING)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,id+100) 
	e0:SetCondition(s.descon)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)  
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(s.imcon)
	e2:SetTarget(s.imtg)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=eg:GetFirst()
	return bc:IsControler(tp) and bc:IsType(TYPE_MONSTER) and s.AwakenedDragon(bc) and bc:IsReason(REASON_BATTLE)
		and Duel.IsExistingMatchingCard(s.AwakenedDragon,tp,LOCATION_ONFIELD,0,1,c)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDestroy() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		local tc=eg:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function s.lvfilter(c)
	return c:IsFaceup() and s.AwakenedDragon(c) and c:IsLevelAbove(6)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE)
			and s.lvfilter(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingTarget(s.lvfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.imcon(e)
	local c=e:GetHandler()
	local rc=c:GetOverlayTarget()
	return rc and rc:IsFaceup()
		and rc:IsControler(e:GetHandlerPlayer())
		and rc:IsType(TYPE_XYZ)
		and s.AwakenedDragon(rc)
end
function s.imtg(e,c)
	return c==e:GetHandler():GetOverlayTarget()
end
function s.efilter(e,re)
	if re:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		return true
	end
	if re:IsActiveType(TYPE_MONSTER) then
		local rc=re:GetOwner()
		if rc:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_WATER+ATTRIBUTE_WIND) then
			return true
		end
	end
	return false
end
