--可爱的电子朋友
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,70095154,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	-- e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
		return g>=1
	end)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	-- e4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
		return g>=4
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local e10=Effect.CreateEffect(e:GetHandler())
		e10:SetType(EFFECT_TYPE_FIELD)
		e10:SetCode(EFFECT_CANNOT_ACTIVATE)
		e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e10:SetTargetRange(0,1)
		e10:SetReset(RESET_PHASE+PHASE_BATTLE)
		e10:SetValue(s.actlimit)
		Duel.RegisterEffect(e10,tp)
	end)
	c:RegisterEffect(e4)
	-- e5
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_ALL)
	e5:SetCondition(function(e)
		local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
		return g>=7
	end)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
		return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER) and g>=7
	end)
	e6:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2100)
	end)
	e6:SetOperation(s.damop)
	c:RegisterEffect(e6)
	-- e6
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetCondition(function(e)
		local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
		return g>=10
	end)
	c:RegisterEffect(e7)
end
function s.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function s.fselect(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and aux.gffcheck(g,Card.IsType,TYPE_TUNER,Card.IsCode,70095154)
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(s.fselect,2,2,tp,c)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,s.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroupCount(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,70095154)
	return g*300
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2100,REASON_EFFECT)
end