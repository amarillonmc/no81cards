--凯尔特·迪木卢多saber
function c9950643.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,nil,3,4,c9950643.ovfilter,aux.Stringid(9950643,1),3,c9950643.xyzop)
	c:EnableReviveLimit()
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950643.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9950643.defval)
	c:RegisterEffect(e2)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950643,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c9950643.descon)
	e3:SetTarget(c9950643.destg)
	e3:SetOperation(c9950643.desop)
	c:RegisterEffect(e3)
  --cannot spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950643,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c9950643.dcon)
	e3:SetOperation(c9950643.dop)
	c:RegisterEffect(e3)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950643.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950643.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950643,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950643,4))
end
function c9950643.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba2) and not c:IsCode(9950643)
end
function c9950643.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9950643)==0 end
	Duel.RegisterFlagEffect(tp,9950643,RESET_PHASE+PHASE_END,0,1)
end
function c9950643.atkfilter(c)
	return c:IsSetCard(0x6ba2) and c:GetAttack()>=0
end
function c9950643.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950643.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9950643.deffilter(c)
	return c:IsSetCard(0x6ba2) and c:GetDefense()>=0
end
function c9950643.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9950643.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c9950643.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9950643.filter(c)
	return c:IsFaceup()
end
function c9950643.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950643.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9950643.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950643.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c9950643.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9950643.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9950643.dop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	e1:SetTarget(c9950643.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c9950643.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end