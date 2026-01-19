--关怀之梦 史塔尔莲华
function c75075630.initial_effect(c)
	-- 衍生物生成
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075630,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75075630)
	e1:SetTarget(c75075630.tg1)
	e1:SetOperation(c75075630.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	-- 赋予效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75075630,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,75075631)
	e3:SetTarget(c75075630.tg2)
	e3:SetOperation(c75075630.op2)
	c:RegisterEffect(e3)
end
-- 1
function c75075630.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75075631,0,TYPES_TOKEN_MONSTER,1200,1200,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c75075630.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75075631,0,TYPES_TOKEN_MONSTER,1200,1200,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,75075631)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
-- 2
function c75075630.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c75075630.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75075630.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c75075630.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c75075630.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c75075630.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(75075630,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,c:GetFieldID())
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0:SetCode(EVENT_CHAIN_END)
			e0:SetReset(RESET_PHASE+PHASE_END)
			e0:SetLabelObject(tc)
			e0:SetCountLimit(1)
			e0:SetOperation(c75075630.retop)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c75075630.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local cid=tc:GetFlagEffectLabel(75075630)
	local c=Duel.GetMatchingGroup(function(c) return c:GetFieldID()==cid end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetFirst()
	if tc and Duel.ReturnToField(tc) then
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(75075630,2))
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(75075630)
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75075630,2))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCondition(c75075630.descon)
		e1:SetCost(c75075630.descost)
		e1:SetTarget(c75075630.destg)
		e1:SetOperation(c75075630.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
-- 获得的效果
function c75075630.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c75075630.relfilter(c,ec)
	return c:IsReleasable() and c~=ec
end
function c75075630.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075630.relfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c75075630.relfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c75075630.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function c75075630.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
