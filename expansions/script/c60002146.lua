--灭剑焰龙·爆裂模式
local m=60002146
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60002134)
	c:EnableReviveLimit()
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function cm.filter(c)
	return c:IsFaceup()
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and not eg:IsContains(e:GetHandler())
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if ec:IsFaceup() then
		local e1=Effect.CreateEffect(ec)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		ec:RegisterEffect(e1)
	end
	Card.RegisterFlagEffect(ec,60002134,RESET_PHASE+PHASE_END,0,1000) --card 
	Duel.RegisterFlagEffect(tp,60002134,RESET_PHASE+PHASE_END,0,1) --ply t turn
	Duel.RegisterFlagEffect(tp,60002135,RESET_PHASE+PHASE_END,0,1000) --ply fore
	if Duel.GetFlagEffect(tp,60002134)>=2 then 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,60002134)>=4 then 
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end