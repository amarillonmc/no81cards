--长生丹
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410001)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,11)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,23410001,LOCATION_MZONE)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	c:RegisterEffect(e1)
	--eff indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(cm.valcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	--e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE+CATEGORY_DESTROY+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.plcon)
	e2:SetTarget(cm.pltg)
	e2:SetOperation(cm.plop)
	c:RegisterEffect(e2)
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,8000,REASON_EFFECT)
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local n=Duel.GetMatchingGroupCount(cm.filter,tp,0,LOCATION_SZONE,nil)
	local num=Duel.GetLP(1-tp)
	Duel.Damage(1-tp,500*n,REASON_EFFECT)
	Duel.Recover(tp,500*n,REASON_EFFECT)
end


function cm.plcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.plfil(c)
	return c:IsCode(m-1) and not c:IsForbidden()
end
function cm.checkfil(c)
	return c:GetSequence()<5
end
function cm.tgfil(c,zone)
	return 1<<c:GetSequence()==zone
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetMatchingGroupCount(checkfil,tp,LOCATION_SZONE,0,nil)~=0 end
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)+Duel.GetMatchingGroupCount(checkfil,tp,LOCATION_SZONE,0,nil)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local zone=Duel.SelectField(tp,1,0,LOCATION_SZONE,nil)
		Debug.Message(zone>>24)
		if Duel.IsExistingMatchingCard(cm.tgfil,tp,0,LOCATION_SZONE,1,nil,zone>>24) then 
			local tg=Duel.GetMatchingGroup(cm.tgfil,tp,0,LOCATION_SZONE,nil,zone>>24)
			Duel.SendtoGrave(tg,REASON_RULE)
		end
		Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone>>24)
	end
end


