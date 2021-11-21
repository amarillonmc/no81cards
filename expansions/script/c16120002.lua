--超圣龙 霍尔菲乌斯
local m=16120002
local cm=_G["c"..m]
Duel.LoadScript("c16199990.lua")
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.sfilter,aux.NonTuner(cm.sfilter1),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.atktg)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.effectfilter)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	--to hand/spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.thcon)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
end
cm.material_type=TYPE_SYNCHRO
function cm.sfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_SYNCHRO)
end
function cm.sfilter1(c)
	return c:IsRace(RACE_DRAGON) 
end
function cm.atktg(e,c)
	return c:IsFaceup()
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.inc(c,tpe)
	return c:IsType(tpe) and c:IsFaceup()
end
function cm.rmc(c,tp)
	local Extpe=TYPE_SPSUMMON|TYPE_PENDULUM|TYPE_RITUAL|TYPE_FUSION|TYPE_NORMAL|TYPE_SYNCHRO|TYPE_LINK|TYPE_XYZ
	return c:IsAbleToRemoveAsCost() and c:IsType(Extpe) and Duel.IsExistingMatchingCard(cm.inc,tp,LOCATION_MZONE,0,1,nil,c:GetType()&Extpe)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local Extpe=TYPE_SPSUMMON|TYPE_PENDULUM|TYPE_RITUAL|TYPE_FUSION|TYPE_NORMAL|TYPE_SYNCHRO|TYPE_LINK|TYPE_XYZ
	if chk==0 then 
		if e:GetLabel()~=100 then
			return false
		else
			return Duel.IsExistingMatchingCard(cm.rmc,tp,LOCATION_GRAVE,0,1,nil,tp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rgc=Duel.SelectMatchingCard(tp,cm.rmc,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	local tpe=rgc:GetType()&Extpe
	Duel.Remove(rgc,POS_FACEUP,REASON_COST)
	Duel.SetTargetParam(tpe)
end
function cm.operation(e,tp)
	local c=e:GetHandler()
	local tpe=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local sg=Duel.GetMatchingGroup(cm.inc,tp,LOCATION_MZONE,0,nil,tpe)
	for tc in aux.Next(sg) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e4)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==1-tp and c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		e:GetLabelObject():SetLabel(c:GetReasonEffect():GetActiveType()&0x7)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		if e:GetLabel()&TYPE_MONSTER~=0 then
			e1:SetDescription(aux.Stringid(m,2))
			e1:SetValue(cm.aclimit1)
		elseif e:GetLabel()&TYPE_SPELL~=0 then
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetValue(cm.aclimit2)
		else
			e1:SetDescription(aux.Stringid(m,4))
			e1:SetValue(cm.aclimit3)
		end
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end