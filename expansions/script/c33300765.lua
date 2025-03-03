--秘林诞地蜂巢
local s,id,o=GetID()
function c33300765.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.target)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)

	--battled
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.atcon)
	e4:SetOperation(s.atop)
	c:RegisterEffect(e4)
end
function s.thfilter(c)
	return c:IsSetCard(0xc569) and c:IsRace(RACE_INSECT) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.target(e,c)
	return c:IsSetCard(0xc569) and c:IsRace(RACE_INSECT)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local c=Duel.GetAttackTarget()
	if tc:IsControler(tp) then 
		tc=Duel.GetAttackTarget()
		c=Duel.GetAttacker()
	end
	if not (tc and c) then return end
	e:SetLabelObject(tc)
	return c:IsSetCard(0xc569) and c:IsRace(RACE_INSECT)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(1-tp) then
		--destroy
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,0))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetOperation(s.desop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Damage(c:GetControler(),c:GetBaseAttack(),REASON_EFFECT)
	end
end