-- 阿尔比昂·巴哈姆特
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptarget)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.atkcon3)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3b)
end
function s.get_required_count(tp)
	local base=13
	local flag_ct=Duel.GetFlagEffect(tp,60002148)
	return math.max(base-flag_ct,1)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local required=s.get_required_count(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,required,nil)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local required=s.get_required_count(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,required,13,nil)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g then
		Duel.SendtoGrave(g,REASON_COST)
		g:DeleteGroup()
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local all_mode=Duel.GetFlagEffect(tp,60012309)>0
	local target_player=1-tp
	if all_mode then
		local hand_ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local send_ct=hand_ct//2
		if send_ct>0 then
			Duel.Hint(HINT_SELECTMSG,target_player,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(target_player,Card.IsAbleToGrave,tp,LOCATION_HAND,0,send_ct,send_ct,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
		local extra_ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
		send_ct=extra_ct//2
		if send_ct>0 then
			Duel.Hint(HINT_SELECTMSG,target_player,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(target_player,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,send_ct,send_ct,nil)
			if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	else
		local opt=Duel.SelectOption(target_player,aux.Stringid(id,2),aux.Stringid(id,3))
		if opt==0 then
			local hand_ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
			local send_ct=hand_ct//2
			if send_ct>0 then
				Duel.Hint(HINT_SELECTMSG,target_player,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(target_player,Card.IsAbleToGrave,tp,LOCATION_HAND,0,send_ct,send_ct,nil)
				if #g>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
		else
			local extra_ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)
			local send_ct=extra_ct//2
			if send_ct>0 then
				Duel.Hint(HINT_SELECTMSG,target_player,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(target_player,Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,send_ct,send_ct,nil)
				if #g>0 then
					Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end
		end
	end
	Duel.RegisterFlagEffect(tp,60012308,0,0,1)
end
function s.atkcon3(e)
	return e:GetHandler():GetCounter(0x624)>0
end