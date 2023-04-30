--深 底 的 闯 入 者  萨 克 切 尔
local m=22348241
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RECOVER)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22348241)
	e1:SetCondition(c22348241.spcon)
	e1:SetTarget(c22348241.sptg)
	e1:SetOperation(c22348241.spop)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348241,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RECOVER)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c22348241.drcon)
	e2:SetCost(c22348241.drcost)
	e2:SetTarget(c22348241.drtg)
	e2:SetOperation(c22348241.drop)
	c:RegisterEffect(e2)
end
function c22348241.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22348241.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (e:GetHandler():IsLocation(LOCATION_HAND) or (e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0))end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c22348241.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:IsPreviousLocation(LOCATION_HAND) and Duel.Recover(tp,500,REASON_EFFECT)~=0 then 
		Duel.BreakEffect()
		if c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		elseif c:IsPreviousLocation(LOCATION_GRAVE) then
		Duel.DiscardHand(tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)
		Duel.BreakEffect()
		if c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
		end
	end
end
function c22348241.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22348241.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local coc=c:GetAttack()
	if chk==0 then return Duel.CheckLPCost(tp,coc) end
	Duel.PayLPCost(tp,coc)
end
function c22348241.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348241.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end






