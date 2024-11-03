function c10111137.initial_effect(c)
	aux.AddCodeList(c,10111128)
	 --fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10111137.ffilter,3,true)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10111137.splimit)
	c:RegisterEffect(e0)
    --lp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10111137)
	e1:SetCondition(c10111137.thcon1)
	e1:SetOperation(c10111137.lpop)
	c:RegisterEffect(e1)
    --look
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111137,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101111370)
	e2:SetCondition(c10111137.drcon)
	e2:SetTarget(c10111137.tgtg)
	e2:SetOperation(c10111137.tgop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10111137.reptg)
	e3:SetValue(c10111137.repval)
	c:RegisterEffect(e3)
end
function c10111137.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(10111128)
end
function c10111137.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x8) and c:IsLevelAbove(6) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c10111137.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10111137.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function c10111137.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and tc~=e:GetHandler() and tc:IsSummonType(SUMMON_TYPE_FUSION) and tc:IsSummonPlayer(tp)
		and tc:IsSetCard(0x8)
end
function c10111137.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_EXTRA)
end
function c10111137.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc1 and Duel.SendtoGrave(tc1,REASON_EFFECT)>0 and tc1:IsLocation(LOCATION_GRAVE) then
		local atk=tc1:GetAttack()
		local rg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		if #rg>0 then
			Duel.ConfirmCards(tp,rg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc2=rg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil):GetFirst()
			Duel.ShuffleExtra(1-tp)
			if tc2 and Duel.SendtoGrave(tc2,REASON_EFFECT)>0 and tc2:IsLocation(LOCATION_GRAVE) then
				atk=atk+tc2:GetAttack()
			end
		end
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(math.floor(atk/2))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function c10111137.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c10111137.rmfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c10111137.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10111137.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c10111137.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c10111137.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	end
	return false
end
function c10111137.repval(e,c)
	return c10111137.repfilter(c,e:GetHandlerPlayer())
end