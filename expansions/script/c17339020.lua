--·莱茵哈鲁特·范·阿斯特雷亚·
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(s.spsumop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.wincon)
	e4:SetOperation(s.winop)
	c:RegisterEffect(e4)
end

function s.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

function s.mfilter(c,exc)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable() and not c:IsCode(id)
end

function s.wcfilter(c)
	return c:IsSetCard(0x5f52) and c:IsType(TYPE_MONSTER)
end

function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()

	local ct2=Duel.GetFlagEffect(tp,17337900)
	local required=12
	if ct2>0 then
		if ct2>11 then ct2=11 end 
		required=required-ct2
		if required<1 then required=1 end
	end

	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,nil)
	if #mg<required then return false end

	local wmg=mg:Filter(s.wcfilter,nil)
	if #wmg==0 then return false end

	local function check(g)
		return g:GetCount()==required and g:IsExists(s.wcfilter,1,nil)
	end
	
	return mg:CheckSubGroup(check,required,required)
end

function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local required=12
	local ct2=Duel.GetFlagEffect(tp,17337900)
	if ct2>0 then
		if ct2>11 then ct2=11 end
		required=required-ct2
		if required<1 then required=1 end
	end
	
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,nil)
	local g=Group.CreateGroup()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,function(g)
		return g:GetCount()==required and g:IsExists(s.wcfilter,1,nil)
	end,true,required,required)
	
	if sg then
		g:Merge(sg)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.spsumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonPlayer(tp)
end

function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0xf7) 
end