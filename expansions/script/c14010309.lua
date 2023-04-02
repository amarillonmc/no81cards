--色彩的先导者
local m=14010309
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,3,3)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.rcon)
	e3:SetOperation(cm.rop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.desreptg)
	e4:SetValue(cm.desrepval)
	e4:SetOperation(cm.desrepop)
	c:RegisterEffect(e4)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local lp=Duel.GetLP(tp)
	local f=math.floor((lp)/1000)
	local ct=re:GetHandler():GetOverlayCount()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and ep==tp and ct+f>=ev and Duel.CheckLPCost(tp,1000)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetOwnerPlayer()
	local lp=Duel.GetLP(tp)
	local min=ev&0xffff
	local max=(ev>>16)&0xffff
	local ct=re:GetHandler():GetOverlayCount()
	if ct==0 and min>0 then
		if min==max then
			Duel.PayLPCost(tp,max*1000)
			return max
		else
			local t={}
			local f=math.floor((lp)/1000)
			if f>=max-min+1 then f=max-min+1 end
			local l=1
			while l<=f and l<=20 do
				t[l]=(min+l-1)*1000
				l=l+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local announce=Duel.AnnounceNumber(tp,table.unpack(t))
			Duel.PayLPCost(tp,announce,true)
			local ct=math.floor((announce)/1000)
			return ct
		end
	else
		if ct>min then ct=min end
		local t={}
		local f=math.floor((lp)/1000)
		if f>=max-min+ct+1 then f=max-min+ct+1 end
		local l=1
		while l<=f and l<=20 do
			t[l]=(min-ct+l-1)*1000
			l=l+1
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local announce=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.PayLPCost(tp,announce,true)
		local ct=math.floor((announce)/1000)
		return ct
	end
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and Duel.CheckLPCost(tp,1000) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,m)
	Duel.PayLPCost(tp,1000)
end