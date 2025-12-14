--天觉龙 托
local s,id=GetID()
s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,id+3)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.drwcon1)
	e1:SetTarget(s.drwtg)
	e1:SetOperation(s.drwop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(s.drwcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.extg)
	e5:SetOperation(s.exop)
	c:RegisterEffect(e5)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

local function destroyed_juelong(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp)
		and s.AwakenedDragon(c)
		and c:IsType(TYPE_MONSTER)
		and bit.band(c:GetReason(),REASON_BATTLE+REASON_EFFECT)~=0
end
local function removed_juelong(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp)
		and s.AwakenedDragon(c)
		and c:IsType(TYPE_MONSTER)
end
function s.drwcon1(e,tp,eg,ep,ev,re,r,rp)
	local tp2=e:GetHandlerPlayer()
	if e:IsHasType(EFFECT_TYPE_XMATERIAL) then
		local c=e:GetHandler()
		local rc=c:GetOverlayTarget()
		if not rc or not s.AwakenedDragon(rc) or not rc:IsType(TYPE_XYZ) then
			return false
		end
	end
	return eg:IsExists(destroyed_juelong,1,nil,tp2)
end
function s.drwcon2(e,tp,eg,ep,ev,re,r,rp)
	local tp2=e:GetHandlerPlayer()
	if e:IsHasType(EFFECT_TYPE_XMATERIAL) then
		local c=e:GetHandler()
		local rc=c:GetOverlayTarget()
		if not rc or not s.AwakenedDragon(rc) or not rc:IsType(TYPE_XYZ) then
			return false
		end
	end
	return eg:IsExists(removed_juelong,1,nil,tp2)
end
function s.drwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drwop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return 
			not c:IsForbidden()
			
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
end
-- 把单卡 c 当作灵摆卡使用加入额外
function s.SendToExtraAsPendulum(c,tp,reason,e)
	if not c then return end
	local handler = e and e:GetHandler() or nil
	if not c:IsType(TYPE_PENDULUM) then
		local e1=Effect.CreateEffect(handler)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_PENDULUM)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	Duel.SendtoExtraP(c,tp,reason)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		s.SendToExtraAsPendulum(c,tp,REASON_EFFECT,e)
	end
end
