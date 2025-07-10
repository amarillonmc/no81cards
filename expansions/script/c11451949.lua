--清透幻翼
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,33900648)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCode(97811903)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCode(EVENT_CUSTOM+m)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(cm.con2)
	e5:SetTarget(cm.tg2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabelObject(e5)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(cm.eftg)
	e2:SetCondition(cm.condition)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.condition)
	e6:SetCode(m)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_ADJUST)
	e7:SetOperation(cm.adop)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if Duel.IsExistingMatchingCard(Card.IsHasEffect,p,LOCATION_MZONE,0,1,nil,m) then
			Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,p,ev)
		end
	end
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(0,1,1) --+Duel.GetFieldGroup(0,0xff,0xff)
	g=g:Filter(function(c) return c:GetFlagEffect(m)==0 end,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,0,0,1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,2))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetCode(EVENT_CUSTOM+m)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_EVENT_PLAYER)
		e3:SetCondition(cm.con2)
		e3:SetTarget(cm.tg2)
		e3:SetOperation(cm.op)
		tc:RegisterEffect(e3)
	end
end
function cm.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.eftg(e,c)
	local attchk=0
	local a0=Duel.IsExistingMatchingCard(function(c) return c:GetSequence()==5 and c:IsCode(33900648) and not c:IsDisabled() end,1,LOCATION_SZONE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(0,97811903)
	local a1=Duel.IsExistingMatchingCard(function(c) return c:GetSequence()==5 and c:IsCode(33900648) and not c:IsDisabled() end,0,LOCATION_SZONE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(1,97811903)
	local b0=a1 and Duel.IsPlayerAffectedByEffect(0,6089145)
	local b1=a1 and Duel.IsPlayerAffectedByEffect(1,6089145)
	if a0 or a1 then
		if b0 or b1 then
			attchk=ATTRIBUTE_LIGHT|ATTRIBUTE_DARK|ATTRIBUTE_EARTH|ATTRIBUTE_WATER|ATTRIBUTE_FIRE|ATTRIBUTE_WIND
		else
			if a0 then
				local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,0,nil)
				for tc in aux.Next(g) do attchk=attchk|tc:GetAttribute() end
			end
			if a1 then
				local g=Duel.GetMatchingGroup(Card.IsFaceup,1,LOCATION_MZONE,0,nil)
				for tc in aux.Next(g) do attchk=attchk|tc:GetAttribute() end
			end
		end
	end
	return c:IsType(TYPE_EFFECT) and c:IsAttribute(attchk)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_DESTROY)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_DESTROY) and eg:IsContains(c)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.eftg(e,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsHasEffect,tp,LOCATION_MZONE,0,1,nil,m) and Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,aux.FilterBoolFunction(aux.IsCodeListed,33900648),tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #tg>0 then
			local tc=tg:GetFirst()
			local code=g:GetFirst():GetOriginalCode()
			local cregister=Card.RegisterEffect
			Card.RegisterEffect=function(card,effect,flag)
				local eff=effect --:Clone()
				if eff:GetDescription()==0 then eff:SetDescription(aux.Stringid(m,2)) end
				if eff:GetRange()&(LOCATION_SZONE+LOCATION_PZONE+LOCATION_FZONE)>0 then
					eff:SetRange(LOCATION_MZONE)
				end
				if eff:IsHasType(EFFECT_TYPE_ACTIVATE) then
					eff:SetType(EFFECT_TYPE_QUICK_O)
					if not eff:GetOperation() then return end
				end
				return cregister(card,eff,flag)
			end
			local cid=tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			Card.RegisterEffect=cregister
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetCountLimit(1)
			e2:SetRange(LOCATION_MZONE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetLabel(cid)
			e2:SetOperation(cm.rstop)
			tc:RegisterEffect(e2)
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Hint(HINT_CODE,tp,code)
			tc:SetHint(CHINT_CARD,code)
		end
	end  
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	c:SetHint(CHINT_CARD,0)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end