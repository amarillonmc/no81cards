--五条悟
local m=12847127
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.linklimit)
	c:RegisterEffect(e3)
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.sumsuc)
	c:RegisterEffect(e0)
	--無下限术式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.mkcon)
	e1:SetOperation(cm.mkop)
	c:RegisterEffect(e1)
	--虚式·茈
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	--leave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(cm.leaveop)
	c:RegisterEffect(e4)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,1))
end
function cm.mkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.mkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	c:SetHint(CHINT_CARD,ac)
	cm[c]=cm[c] or {}
	c:RegisterFlagEffect(m+ac,RESET_EVENT+RESETS_STANDARD,0,1)
	table.insert(cm[c],m+ac)
	if c:GetFlagEffect(m)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cm.efilter)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.indval)
		c:RegisterEffect(e2,true)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.efilter(e,te)
	return e~=te and e:GetHandler():GetFlagEffect(m+te:GetHandler():GetCode())>0
end
function cm.indval(e,c)
	return e:GetHandler():GetFlagEffect(m+c:GetCode())>0
end
function cm.rmfilter(c,ec)
	return ec:GetFlagEffect(m+c:GetCode())>0 and c:IsAbleToRemove()
end
function cm.rmfilter2(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local dg=Duel.GetMatchingGroup(cm.rmfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		if not cm[c] or #cm[c]==0 then return false end
		for _,code in pairs(cm[c]) do
			if #dg>0 and c:GetFlagEffect(code)>0 then return true end
		end
		return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	Duel.Hint(24,0,aux.Stringid(m,0))
	local dg=Duel.GetMatchingGroup(cm.rmfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	Duel.ConfirmCards(tp,dg)
	Duel.ConfirmCards(1-tp,dg)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,nil,e:GetHandler())
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			cm[c]=cm[c] or {}
			for _,code in pairs(cm[c]) do
				c:ResetFlagEffect(code)
			end
			cm[c]={}
			c:SetHint(CHINT_CARD,0)
		end
	end
end
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,2))
end