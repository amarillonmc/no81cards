--作茧自赎
local cm,m=GetID()
function cm.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.immval)
	c:RegisterEffect(e3)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e5:SetTarget(cm.fliptg)
	e5:SetOperation(cm.flipop)
	c:RegisterEffect(e5)
end
function cm.immval(e,te)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local res=(te:GetOwner()~=c)
	if res then
		local flag=c:GetFlagEffectLabel(m)
		if flag then
			c:SetFlagEffectLabel(m,flag+1)
		else
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,1)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ADJUST)
		e4:SetOperation(cm.imcop)
		Duel.RegisterEffect(e4,tp)
		Duel.Readjust()
	end
	return res
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	e:Reset()
end 
function cm.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local flag=c:GetFlagEffectLabel(m)
	if flag then
		if rp>=2 then
			if tp==0 then rp=1 end
			if tp==1 then rp=0 end
		end
		Duel.SetTargetPlayer(rp)
		Duel.SetTargetParam(flag)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,rp,flag)
	end
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end