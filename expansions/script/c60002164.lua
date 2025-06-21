--乌拉诺斯
local m=60002164
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attackup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(cm.incon)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(cm.incon)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(cm.incon)
	e4:SetOperation(cm.tgop)
	c:RegisterEffect(e4)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.filter(c)
	return c:IsLevelBelow(3)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Remove(g:GetFirst(),POS_FACEUP,REASON_EFFECT)
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=20 then
		if e:GetHandler():IsRelateToEffect(e) then
			e:GetHandler():AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
			Duel.Recover(tp,1200,REASON_EFFECT)
		end
	end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dmg=0
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=5 then
		dmg=3600
	else
		dmg=1200
	end
	Duel.Damage(1-tp,dmg,REASON_EFFECT)
end












