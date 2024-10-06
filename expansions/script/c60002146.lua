--灭剑焰龙·爆裂模式
local m=60002146
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60002134)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
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
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	local e1=e2:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		Card.RegisterFlagEffect(c,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
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
end
function cm.indtg(e,c)
	return c:IsRace(RACE_DRAGON) and e:GetHandler()~=c and c:IsFaceup()
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and not eg:IsContains(e:GetHandler()) and Card.GetFlagEffect(e:GetHandler(),60002134)~=0
end
function cm.checkfil(c) 
	return c:IsFaceup() and c:IsDefenseAbove(0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local mg=eg:Filter(cm.checkfil,nil)
	if #mg==0 then return end
	for ec in aux.Next(mg) do
		if ec:IsFaceup() and ec:IsLocation(LOCATION_MZONE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(500)
			ec:RegisterEffect(e1)
			Card.RegisterFlagEffect(ec,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
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
	end
end