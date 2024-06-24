local m=15000225
local cm=_G["c"..m]
cm.name="廷达魔三角之核"
function cm.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,cm.matfilter,1,1)
	e0:SetProperty(e0:GetProperty()|EFFECT_FLAG_SET_AVAILABLE)
	c:EnableReviveLimit()
	--record
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(0xff)
	e10:SetOperation(cm.adjustop)
	c:RegisterEffect(e10)
	--effect copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cycon)
	e1:SetTarget(cm.cytg)
	e1:SetOperation(cm.cyop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--position change
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)
end
function cm.matfilter(c)
	return (c:IsLinkSetCard(0x10b) and c:IsType(TYPE_FLIP) and c:IsFacedown()) or (c:IsType(TYPE_FLIP) and c:IsFaceup())
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not cm.globle_check then
		cm.globle_check=true
		local g=Duel.GetMatchingGroup(cm.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and bit.band(effect:GetType(),EFFECT_TYPE_FLIP)==EFFECT_TYPE_FLIP then
				local eff=effect:Clone()
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cm[tc:GetOriginalCode()]=eff
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
function cm.mchkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FLIP) and c:IsLinkSetCard(0x10b) and c:IsPreviousPosition(POS_FACEDOWN)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(cm.mchkfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.cycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function cm.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (cm.mchkfilter(c) and c:IsCanBeEffectTarget(e)) then return false end
	local te=cm[c:GetOriginalCode()]
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c)
end
function cm.cytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if chkc then return mg:IsContains(chkc) and cm.efffilter(chkc) end
	if chk==0 then
		return mg:IsExists(cm.efffilter,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=mg:FilterSelect(tp,cm.efffilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetTargetCard(g)
	local tc=g:GetFirst()
	Duel.ClearTargetCard()
	e:SetLabelObject(tc)
	local te=cm[tc:GetOriginalCode()]
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end
function cm.cyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=cm[tc:GetOriginalCode()]
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end