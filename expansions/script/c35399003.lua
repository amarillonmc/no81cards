--幻星龙 地森
function c35399003.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c35399003.MatFilter,8,2)
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c35399003.val0)
	c:RegisterEffect(e0)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c35399003.val1)
	c:RegisterEffect(e1)
--
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetCode(EFFECT_CANNOT_REMOVE)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetTargetRange(0,1)
	e2_1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2_1)
	local e2_2=Effect.CreateEffect(c)
	e2_2:SetType(EFFECT_TYPE_FIELD)
	e2_2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_2:SetTargetRange(0,1)
	e2_2:SetTarget(c35399003.splimit2_2)
	e2_2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2_2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399003,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,35399003)
	e3:SetTarget(c35399003.tg3)
	e3:SetOperation(c35399003.op3)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(35399003,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCountLimit(1,35399004)
	e4:SetCondition(c35399003.con4)
	e4:SetCost(c35399003.cost4)
	e4:SetOperation(c35399003.op4)
	c:RegisterEffect(e4)
--
end
--
function c35399003.MatFilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsXyzType(TYPE_SYNCHRO)
end
function c35399003.val0(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and not se)
end
--
function c35399003.val1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
--
function c35399003.splimit2_2(e,c,sump,sumtype,sumpos,targetp,se)
	return se and c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end
--
function c35399003.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function c35399003.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
--
function c35399003.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c35399003.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,REASON_COST)
end
function c35399003.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e4_1=Effect.CreateEffect(c)
		e4_1:SetType(EFFECT_TYPE_SINGLE)
		e4_1:SetCode(EFFECT_UPDATE_ATTACK)
		e4_1:SetReset(RESET_PHASE+PHASE_END)
		e4_1:SetValue(bc:GetAttack())
		c:RegisterEffect(e4_1)
	end
end
--