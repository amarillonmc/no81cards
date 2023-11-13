--随风旅鸟×渡渡鸟
local cm,m=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.thcon)
	e2:SetValue(cm.limval)
	c:RegisterEffect(e2)
	--hand tribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(function(e,c) return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c~=e:GetHandler() end)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(POS_FACEUP_ATTACK)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(cm.dccon)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--tribute
	local e32=Effect.CreateEffect(c)
	e32:SetType(EFFECT_TYPE_FIELD)
	e32:SetCode(EFFECT_SUMMON_COST)
	e32:SetTargetRange(LOCATION_HAND,0)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCost(cm.facechk)
	--e32:SetLabelObject(e22)
	c:RegisterEffect(e32)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsLocation,nil,LOCATION_HAND)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function cm.facechk(e,c)
	if c:IsRace(RACE_WINDBEAST) and c:IsControler(e:GetHandlerPlayer()) then
		local e22=Effect.CreateEffect(c)
		e22:SetType(EFFECT_TYPE_SINGLE)
		e22:SetCode(EFFECT_MATERIAL_CHECK)
		e22:SetReset(RESET_EVENT+RESETS_STANDARD)
		e22:SetValue(cm.valcheck)
		c:RegisterEffect(e22)
	end
	return true
end
function cm.dccon(e,c)
	return c:IsRace(RACE_WINDBEAST)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.refilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToRemove()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,0,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if g:GetFirst():IsLocation(LOCATION_REMOVED) then
		Duel.Draw(tp,2,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,true,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function cm.limval(e,re,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsDefensePos() and rc:IsSummonType(SUMMON_TYPE_SPECIAL)
end