--幽暗之影 苍炎刃鬼
function c75010001.initial_effect(c)
	c:EnableReviveLimit()
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetOperation(c75010001.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75010001,0))
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75010001.damcon)
	e3:SetTarget(c75010001.damtg)
	e3:SetOperation(c75010001.damop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(c75010001.sptg)
	e4:SetOperation(c75010001.spop)
	c:RegisterEffect(e4)
end
function c75010001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=math.ceil(c:GetDefense()/2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(-val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if c:IsHasEffect(EFFECT_REVERSE_UPDATE) then return end
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c:GetDefense())
	c:RegisterEffect(e2)
end
function c75010001.cfilter(c,p)
	return c:IsPreviousControler(p) and c:IsPreviousLocation(LOCATION_MZONE)
		and not (c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT))
end
function c75010001.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75010001.cfilter,1,nil,1-tp)
end
function c75010001.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDefenseAbove(0) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.ceil(e:GetHandler():GetAttack()/10)+240)
end
function c75010001.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsReleasable(e) or c:IsFacedown() then return end
	local val=math.ceil(c:GetAttack()/10)+240
	if Duel.Damage(1-tp,val,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c75010001.tgfilter(c)
	return bit.band(c:GetType(),TYPE_RITUAL+TYPE_SPELL)==TYPE_RITUAL+TYPE_SPELL and c:IsAbleToGrave()
end
function c75010001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c75010001.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c75010001.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c75010001.tgfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local c=e:GetHandler()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(0x10) and c:IsRelateToEffect(e) then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end
