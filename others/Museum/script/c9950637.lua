--凯尔特·格雷德尔
function c9950637.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c9950637.mfilter,1,1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9950637.condition)
	e1:SetOperation(c9950637.regop)
	c:RegisterEffect(e1)
 --atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c9950637.atkcon)
	e1:SetTarget(c9950637.atktg)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	--untarget
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
--destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950637,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c9950637.descon)
	e1:SetTarget(c9950637.destg1)
	e1:SetOperation(c9950637.desop1)
	c:RegisterEffect(e1)
	--destroy spell & trap
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9950637,2))
	e2:SetTarget(c9950637.destg2)
	e2:SetOperation(c9950637.desop2)
	c:RegisterEffect(e2)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950637.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950637.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950637,0))
end
function c9950637.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x6ba2)
end
function c9950637.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9950637.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9950637.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9950637.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(9950637) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c9950637.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function c9950637.atktg(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return c==e:GetHandler() or g:IsContains(c)
end
function c9950637.descon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsCode(9950637) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9950637.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950637.desfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9950637.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9950637.desfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950637.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9950637.desfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950637.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950637,0))
end
function c9950637.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950637,0))
end
