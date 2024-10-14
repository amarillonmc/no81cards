--祝你幸福 丰川祥子
local m=12847087
local cm=_G["c"..m]
cm.code=12847087
cm.side_code=12847088
function cm.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,nil,1,99)
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.sumsuc)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(cm.con2)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetCondition(cm.con2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetCondition(cm.con2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,m)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con1)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	c:RegisterEffect(e3) 
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m+200)
	e5:SetCode(EVENT_CUSTOM+m)
	e5:SetOperation(cm.setop)
	c:RegisterEffect(e5)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,m+100)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.condition)
	e4:SetOperation(cm.operation)
	--c:RegisterEffect(e4)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE) 
	e6:SetCountLimit(1,m+300)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(cm.con2)
	e6:SetTarget(cm.distg2)
	e6:SetOperation(cm.operation2)
	c:RegisterEffect(e6)
	if not cm.Side_Check then
		cm.Side_Check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_ADJUST)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCondition(cm.backon)
		e0:SetOperation(cm.backop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsLevel(3)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,0))
end
function cm.con1(e)
	return e:GetHandler():GetFlagEffect(16100000)==0
end
function cm.con2(e)
	return e:GetHandler():GetFlagEffect(16100000)>0
end
function cm.checkitside(c)
	return c.code and c.side_code and c:GetFlagEffect(16100000)==0 and c:GetOriginalCode()==c.side_code
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.checkitside,tp,0x7f,0x7f,nil)
	return dg:GetCount()>0
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.checkitside,tp,0x7f,0x7f,nil)
	for c in aux.Next(dg) do
		local tcode=c.code
		c:SetEntityCode(tcode)
		if c:IsFacedown() then
			Duel.ConfirmCards(1-tp,Group.FromCards(c))
		end
		c:ReplaceEffect(tcode,0,0)
		Duel.Hint(HINT_CARD,0,tcode)
		if c:IsLocation(LOCATION_HAND) then
			local sp=c:GetControler()
			Duel.ShuffleHand(sp)
		end
	end
	Duel.Readjust()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.discheck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)>=3 and e:GetHandler():GetFlagEffect(16100000)==0 and e:GetHandler():GetFlagEffect(16100001)==0
end
function cm.discheck(c)
	return c:IsFaceup() and c:IsDisabled()
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.discheck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local num=Duel.SendtoGrave(g,REASON_EFFECT)
	if num>0 then
		local atk=num*1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(16100000)==0 then
		Duel.Hint(HINT_CARD,0,12847088)
		local sidecode=c.side_code
		c:SetEntityCode(sidecode)
		c:RegisterFlagEffect(16100000,RESET_EVENT+0x7e0000,0,0)
		Duel.Hint(24,0,aux.Stringid(m+1,0))
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,re,r,rp,ep,0)
	end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(16100001,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,0)
	local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,nil)
	if c:GetFlagEffect(16100000)>0 then
		local tc=dg:GetFirst()
		while tc do
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			tc=dg:GetNext()
		end
		Duel.Hint(HINT_CARD,0,12847087)
		local g=c:GetOverlayGroup()
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		local sidecode=c.code
		c:SetEntityCode(code)
		c:ResetFlagEffect(16100000)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,re,r,rp,ep,0)
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=0
	if c:GetFlagEffectLabel(m) then ct=c:GetFlagEffectLabel(m) end
	if chkc then return chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and c:GetFlagEffect(16100000)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,ct,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetTargetsRelateToChain()
	local tc=dg:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=dg:GetNext()
	end
end
function cm.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.valcheck(e,c)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,c:GetMaterial():FilterCount(Card.IsLevel,nil,3))
end
