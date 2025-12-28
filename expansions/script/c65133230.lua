--幻叙从者 东际
local s,id,o=GetID()
function s.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--Pendulum Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.pcon)
	e1:SetTarget(s.ptg)
	e1:SetOperation(s.pop)
	c:RegisterEffect(e1)
	--Monster Effect 1: On Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.m1tg)
	e2:SetOperation(s.m1op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Monster Effect 2: From Extra Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.m2con)
	e4:SetTarget(s.m2tg)
	e4:SetOperation(s.m2op)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function s.get_attr_flag(att)
	if (att&ATTRIBUTE_LIGHT>0) or (att&ATTRIBUTE_DARK>0) then return 0 end
	if (att&ATTRIBUTE_WATER>0) or (att&ATTRIBUTE_FIRE>0) then return 1 end
	if (att&ATTRIBUTE_EARTH>0) or (att&ATTRIBUTE_WIND>0) then return 2 end
	if (att&ATTRIBUTE_DIVINE>0) then return 3 end
	return -1
end

function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local att=rc:GetAttribute()
	if not (re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE and rp==1-tp) then return false end
	local flag_idx=s.get_attr_flag(att)
	if flag_idx==-1 then return false end
	return Duel.GetFlagEffect(tp,id+flag_idx)==0
end

function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	local rc=re:GetHandler()
	local att=rc:GetAttribute()
	local flag_idx=s.get_attr_flag(att)
	if flag_idx==0 then e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DESTROY)
	elseif flag_idx==1 then e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DISABLE)
	elseif flag_idx==2 then e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_ATKCHANGE)
	elseif flag_idx==3 then e:SetCategory(CATEGORY_TOEXTRA+CATEGORY_REMOVE) end
	e:SetLabel(flag_idx)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	if flag_idx==0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	elseif flag_idx==1 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,re,1,0,0)
	elseif flag_idx==3 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,0,0)
	end
end

function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoExtraP(c,nil,REASON_EFFECT)>0 then
		local flag_idx=e:GetLabel()
		if flag_idx==-1 then return end
		Duel.RegisterFlagEffect(tp,id+flag_idx,RESET_PHASE+PHASE_END,0,1)		
		Duel.BreakEffect()
		if flag_idx==0 then
			if rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
		elseif flag_idx==1 then
			Duel.NegateEffect(ev)
		elseif flag_idx==2 then
			if rc:IsRelateToEffect(re) and rc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				rc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				rc:RegisterEffect(e2)
			end
		elseif flag_idx==3 then
			if rc:IsRelateToEffect(re) then
				Duel.Remove(rc,POS_FACEDOWN,REASON_RULE,1-tp)
			end
		end
	end
end

function s.thfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.m1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,3)}, --Place in P-Zone
		{b2,1190}) --Add to Hand
	e:SetLabel(op)
	if op==1 then
		--
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.m1op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if op==1 then
		if not c:IsRelateToChain() then return end
		if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.cfilter(c,tp)
	return c:IsSetCard(0x838) and c:IsRace(RACE_WARRIOR) and c:IsControler(tp) and c:IsFaceup()
end
function s.m2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and e:GetHandler():IsFaceup()
end
function s.m2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,3)},
		{b2,1152})
	e:SetLabel(op)
	if op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end
function s.m2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local op=e:GetLabel()
	if op==1 then
		if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
