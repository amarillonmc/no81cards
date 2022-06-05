--光子龙 绯红爆裂
function c25000021.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c25000021.mfilter,c25000021.xyzcheck,3,3) 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000021,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,25000021)
	e1:SetTarget(c25000021.atktg)
	e1:SetOperation(c25000021.atkop)
	c:RegisterEffect(e1)   
	--Destroy 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000021,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000021)
	e2:SetCost(c25000021.descost)
	e2:SetTarget(c25000021.destg)
	e2:SetOperation(c25000021.desop)
	c:RegisterEffect(e2)
end
function c25000021.mfilter(c,xyzc)
	return c:IsRace(RACE_MACHINE) and c:IsLevelAbove(1)
end
function c25000021.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
function c25000021.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(tp)
	if chk==0 then return a and d  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c25000021.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a,d=Duel.GetBattleMonster(tp)
	if d and d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c25000021.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(c25000021.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(c:GetFieldID())
	Duel.RegisterEffect(e2,tp)
	end
end
function c25000021.disable(e,c)
	return (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function c25000021.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsOnField() 
end
function c25000021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c25000021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and eg:IsExists(Card.IsPreviousControler,1,nil,1-tp) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c25000021.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end









